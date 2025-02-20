/*
 * Copyright 2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.gradle.api.internal.provider;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import org.gradle.api.Action;
import org.gradle.api.Task;
import org.gradle.api.Transformer;
import org.gradle.api.internal.provider.MapCollectors.EntriesFromMap;
import org.gradle.api.internal.provider.MapCollectors.EntriesFromMapProvider;
import org.gradle.api.internal.provider.MapCollectors.EntryWithValueFromProvider;
import org.gradle.api.internal.provider.MapCollectors.SingleEntry;
import org.gradle.api.internal.tasks.TaskDependencyResolveContext;
import org.gradle.api.provider.MapProperty;
import org.gradle.api.provider.Provider;
import org.gradle.internal.Cast;
import org.gradle.internal.Pair;
import org.gradle.internal.evaluation.EvaluationScopeContext;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.toList;
import static org.gradle.internal.Cast.uncheckedCast;
import static org.gradle.internal.Cast.uncheckedNonnullCast;

/**
 * The implementation for {@link MapProperty}.
 * <p>
 * Value suppliers for map properties are implementations of {@link MapSupplier}.
 * </p>
 * <p>
 * Increments to map property values are implementations of {@link MapCollector}.
 * </p>
 *
 * This class mimics much of the behavior {@link AbstractCollectionProperty} provides for regular collections
 * but for maps. Read that class' documentation to better understand the roles of {@link MapSupplier} and {@link MapCollector}.
 *
 * @param <K> the type of entry key
 * @param <V> the type of entry value
 */
public class DefaultMapProperty<K, V> extends AbstractProperty<Map<K, V>, MapSupplier<K, V>> implements MapProperty<K, V>, MapProviderInternal<K, V>, MapPropertyInternal<K, V> {
    private static final String NULL_KEY_FORBIDDEN_MESSAGE = String.format("Cannot add an entry with a null key to a property of type %s.", Map.class.getSimpleName());
    private static final String NULL_VALUE_FORBIDDEN_MESSAGE = String.format("Cannot add an entry with a null value to a property of type %s.", Map.class.getSimpleName());

    private final Class<K> keyType;
    private final Class<V> valueType;
    private final ValueCollector<K> keyCollector;
    private final MapEntryCollector<K, V> entryCollector;
    private MapSupplier<K, V> defaultValue = emptySupplier();

    public DefaultMapProperty(PropertyHost propertyHost, Class<K> keyType, Class<V> valueType) {
        super(propertyHost);
        this.keyType = keyType;
        this.valueType = valueType;
        keyCollector = new ValidatingValueCollector<>(Set.class, keyType, ValueSanitizers.forType(keyType));
        entryCollector = new ValidatingMapEntryCollector<>(keyType, valueType, ValueSanitizers.forType(keyType), ValueSanitizers.forType(valueType));
        init();
    }

    private void init() {
        defaultValue = emptySupplier();
        init(defaultValue, noValueSupplier());
    }

    @Override
    public MapSupplier<K, V> getDefaultValue() {
        return defaultValue;
    }

    @Override
    protected MapSupplier<K, V> getDefaultConvention() {
        return noValueSupplier();
    }

    @Override
    protected boolean isDefaultConvention() {
        return isNoValueSupplier(getConventionSupplier());
    }

    private MapSupplier<K, V> emptySupplier() {
        return new EmptySupplier();
    }

    private MapSupplier<K, V> noValueSupplier() {
        return uncheckedCast(new NoValueSupplier(Value.missing()));
    }

    @Nullable
    @Override
    @SuppressWarnings("unchecked")
    public Class<Map<K, V>> getType() {
        return (Class) Map.class;
    }

    @Override
    public Class<K> getKeyType() {
        return keyType;
    }

    @Override
    public Class<V> getValueType() {
        return valueType;
    }

    @Override
    public Class<?> publicType() {
        return MapProperty.class;
    }

    @Override
    public int getFactoryId() {
        return ManagedFactories.MapPropertyManagedFactory.FACTORY_ID;
    }

    @Override
    public Provider<V> getting(final K key) {
        return new EntryProvider(key);
    }

    @Override
    @SuppressWarnings("unchecked")
    public MapProperty<K, V> empty() {
        setSupplier(emptySupplier());
        return this;
    }

    @Override
    @SuppressWarnings("unchecked")
    public void setFromAnyValue(@Nullable Object object) {
        if (object == null || object instanceof Map<?, ?>) {
            set((Map) object);
        } else if (object instanceof Provider<?>) {
            set((Provider) object);
        } else {
            throw new IllegalArgumentException(String.format(
                "Cannot set the value of a property of type %s using an instance of type %s.", Map.class.getName(), object.getClass().getName()));
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public void set(@Nullable Map<? extends K, ? extends V> entries) {
        if (entries == null) {
            unsetValueAndDefault();
        } else {
            setSupplier(newCollectingSupplierOf(new EntriesFromMap<>(entries)));
        }
    }

    @Override
    public void set(Provider<? extends Map<? extends K, ? extends V>> provider) {
        setSupplier(newCollectingSupplierOf(new MapCollectors.EntriesFromMapProvider<>(checkMapProvider(provider))));
    }

    @Override
    public MapProperty<K, V> value(@Nullable Map<? extends K, ? extends V> entries) {
        set(entries);
        return this;
    }

    @Override
    public MapProperty<K, V> value(Provider<? extends Map<? extends K, ? extends V>> provider) {
        set(provider);
        return this;
    }

    @Override
    public void put(K key, V value) {
        getConfigurer().put(key, value);
    }

    @Override
    public void put(K key, Provider<? extends V> providerOfValue) {
        getConfigurer().put(key, providerOfValue);
    }

    @Override
    public void putAll(Map<? extends K, ? extends V> entries) {
        getConfigurer().putAll(entries);
    }

    @Override
    public void putAll(Provider<? extends Map<? extends K, ? extends V>> provider) {
        getConfigurer().putAll(provider);
    }

    @Override
    public void insert(K key, Provider<? extends V> providerOfValue) {
        withActualValue(it -> it.put(key, providerOfValue));
    }

    @Override
    public void insert(K key, V value) {
        withActualValue(it -> it.put(key, value));
    }

    @Override
    public void insertAll(Provider<? extends Map<? extends K, ? extends V>> provider) {
        withActualValue(it -> it.putAll(provider));
    }

    @Override
    public void insertAll(Map<? extends K, ? extends V> entries) {
        withActualValue(it -> it.putAll(entries));
    }

    private void addExplicitCollector(MapCollector<K, V> collector, boolean ignoreAbsent) {
        assertCanMutate();
        MapSupplier<K, V> explicitValue = getExplicitValue(defaultValue);
        setSupplier(explicitValue.plus(collector, ignoreAbsent));
    }

    private Configurer getConfigurer() {
        return getConfigurer(false);
    }

    private Configurer getConfigurer(boolean ignoreAbsent) {
        return new Configurer(ignoreAbsent);
    }

    protected void withActualValue(Action<Configurer> action) {
        setToConventionIfUnset();
        action.execute(getConfigurer(true));
    }

    private boolean isNoValueSupplier(MapSupplier<K, V> valueSupplier) {
        return valueSupplier instanceof DefaultMapProperty.NoValueSupplier;
    }

    private ProviderInternal<? extends Map<? extends K, ? extends V>> checkMapProvider(@Nullable Provider<? extends Map<? extends K, ? extends V>> provider) {
        return checkMapProvider("value", provider);
    }

    @SuppressWarnings("unchecked")
    private ProviderInternal<? extends Map<? extends K, ? extends V>> checkMapProvider(String valueKind, @Nullable Provider<? extends Map<? extends K, ? extends V>> provider) {
        if (provider == null) {
            throw new IllegalArgumentException(String.format("Cannot set the %s of a property using a null provider.", valueKind));
        }
        ProviderInternal<? extends Map<? extends K, ? extends V>> p = Providers.internal(provider);
        if (p.getType() != null && !Map.class.isAssignableFrom(p.getType())) {
            throw new IllegalArgumentException(String.format("Cannot set the %s of a property of type %s using a provider of type %s.",
                valueKind,
                Map.class.getName(), p.getType().getName()));
        }
        if (p instanceof MapProviderInternal) {
            Class<? extends K> providerKeyType = ((MapProviderInternal<? extends K, ? extends V>) p).getKeyType();
            Class<? extends V> providerValueType = ((MapProviderInternal<? extends K, ? extends V>) p).getValueType();
            if (!keyType.isAssignableFrom(providerKeyType) || !valueType.isAssignableFrom(providerValueType)) {
                throw new IllegalArgumentException(String.format("Cannot set the %s of a property of type %s with key type %s and value type %s " +
                        "using a provider with key type %s and value type %s.", valueKind, Map.class.getName(), keyType.getName(), valueType.getName(),
                    providerKeyType.getName(), providerValueType.getName()));
            }
        }
        return p;
    }

    @Override
    public MapProperty<K, V> convention(@Nullable Map<? extends K, ? extends V> value) {
        if (value == null) {
            setConvention(noValueSupplier());
        } else {
            setConvention(newCollectingSupplierOf(new EntriesFromMap<>(value)));
        }
        return this;
    }

    @Override
    public MapProperty<K, V> convention(Provider<? extends Map<? extends K, ? extends V>> valueProvider) {
        setConvention(newCollectingSupplierOf(new EntriesFromMapProvider<>(Providers.internal(valueProvider))));
        return this;
    }

    @Override
    public MapProperty<K, V> unsetConvention() {
        discardConvention();
        return this;
    }

    @Override
    public MapProperty<K, V> unset() {
        return Cast.uncheckedNonnullCast(super.unset());
    }

    private void unsetValueAndDefault() {
        // assign no-value default before restoring to it
        defaultValue = noValueSupplier();
        unset();
    }

    public void fromState(ExecutionTimeValue<? extends Map<? extends K, ? extends V>> value) {
        if (value.isMissing()) {
            setSupplier(noValueSupplier());
        } else if (value.hasFixedValue()) {
            setSupplier(new FixedSupplier(uncheckedNonnullCast(value.getFixedValue()), uncheckedCast(value.getSideEffect())));
        } else {
            CollectingSupplier<K, V> asCollectingProvider = uncheckedNonnullCast(value.getChangingValue());
            setSupplier(asCollectingProvider);
        }
    }

    @Override
    public Provider<Set<K>> keySet() {
        return new KeySetProvider();
    }

    public void replace(Transformer<? extends @org.jetbrains.annotations.Nullable Provider<? extends Map<? extends K, ? extends V>>, ? super Provider<Map<K, V>>> transformation) {
        Provider<? extends Map<? extends K, ? extends V>> newValue = transformation.transform(shallowCopy());
        if (newValue != null) {
            set(newValue);
        } else {
            set((Map<? extends K, ? extends V>) null);
        }
    }

    @Override
    protected String describeContents() {
        return String.format("Map(%s->%s, %s)", keyType.getSimpleName(), valueType.getSimpleName(), describeValue());
    }

    @Override
    protected Value<? extends Map<K, V>> calculateValueFrom(EvaluationScopeContext context, MapSupplier<K, V> value, ValueConsumer consumer) {
        return value.calculateValue(consumer);
    }

    @Override
    protected MapSupplier<K, V> finalValue(EvaluationScopeContext context, MapSupplier<K, V> value, ValueConsumer consumer) {
        Value<? extends Map<K, V>> result = value.calculateValue(consumer);
        if (!result.isMissing()) {
            return new FixedSupplier(result.getWithoutSideEffect(), uncheckedCast(result.getSideEffect()));
        } else if (result.getPathToOrigin().isEmpty()) {
            return noValueSupplier();
        } else {
            return new NoValueSupplier(result);
        }
    }

    @Override
    protected ExecutionTimeValue<? extends Map<K, V>> calculateOwnExecutionTimeValue(EvaluationScopeContext context, MapSupplier<K, V> value) {
        return value.calculateExecutionTimeValue();
    }

    private class EntryProvider extends AbstractMinimalProvider<V> {
        private final K key;

        public EntryProvider(K key) {
            this.key = key;
        }

        @Nullable
        @Override
        public Class<V> getType() {
            return valueType;
        }

        @Override
        protected Value<? extends V> calculateOwnValue(ValueConsumer consumer) {
            Value<? extends Map<K, V>> result = DefaultMapProperty.this.calculateOwnValue(consumer);
            if (result.isMissing()) {
                return result.asType();
            }
            Value<? extends V> resultValue = Value.ofNullable(result.getWithoutSideEffect().get(key));
            return resultValue.withSideEffect(SideEffect.fixedFrom(result));
        }
    }

    private class KeySetProvider extends AbstractMinimalProvider<Set<K>> {
        @Nullable
        @Override
        @SuppressWarnings("unchecked")
        public Class<Set<K>> getType() {
            return (Class) Set.class;
        }

        @Override
        protected Value<? extends Set<K>> calculateOwnValue(ValueConsumer consumer) {
            try (EvaluationScopeContext context = DefaultMapProperty.this.openScope()) {
                beforeRead(context, consumer);
                return getSupplier(context).calculateKeys(consumer);
            }
        }
    }

    private class NoValueSupplier implements MapSupplier<K, V> {
        private final Value<? extends Map<K, V>> value;

        public NoValueSupplier(Value<? extends Map<K, V>> value) {
            this.value = value.asType();
            assert value.isMissing();
        }

        @Override
        public boolean calculatePresence(ValueConsumer consumer) {
            return false;
        }

        @Override
        public Value<? extends Map<K, V>> calculateValue(ValueConsumer consumer) {
            return value;
        }

        @Override
        public Value<? extends Set<K>> calculateKeys(ValueConsumer consumer) {
            return value.asType();
        }

        @Override
        public MapSupplier<K, V> plus(MapCollector<K, V> collector, boolean ignoreAbsent) {
            // nothing + something = nothing, unless we ignoreAbsent.
            return ignoreAbsent ? newCollectingSupplierOf(ignoreAbsentIfNeeded(collector, ignoreAbsent)) : this;
        }

        @Override
        public ExecutionTimeValue<? extends Map<K, V>> calculateExecutionTimeValue() {
            return ExecutionTimeValue.missing();
        }

        @Override
        public ValueProducer getProducer() {
            return ValueProducer.unknown();
        }

        @Override
        public String toString() {
            return value.toString();
        }
    }

    private class EmptySupplier implements MapSupplier<K, V> {
        @Override
        public boolean calculatePresence(ValueConsumer consumer) {
            return true;
        }

        @Override
        public Value<? extends Map<K, V>> calculateValue(ValueConsumer consumer) {
            return Value.of(ImmutableMap.of());
        }

        @Override
        public Value<? extends Set<K>> calculateKeys(ValueConsumer consumer) {
            return Value.of(ImmutableSet.of());
        }

        @Override
        public MapSupplier<K, V> plus(MapCollector<K, V> collector, boolean ignoreAbsent) {
            // empty + something = something
            return newCollectingSupplierOf(ignoreAbsentIfNeeded(collector, ignoreAbsent));
        }

        @Override
        public ExecutionTimeValue<? extends Map<K, V>> calculateExecutionTimeValue() {
            return ExecutionTimeValue.fixedValue(ImmutableMap.of());
        }

        @Override
        public ValueProducer getProducer() {
            return ValueProducer.noProducer();
        }

        @Override
        public String toString() {
            return "{}";
        }
    }

    private class FixedSupplier implements MapSupplier<K, V> {
        private final Map<K, V> entries;
        private final SideEffect<? super Map<K, V>> sideEffect;

        public FixedSupplier(Map<K, V> entries, @Nullable SideEffect<? super Map<K, V>> sideEffect) {
            this.entries = entries;
            this.sideEffect = sideEffect;
        }

        @Override
        public boolean calculatePresence(ValueConsumer consumer) {
            return true;
        }

        @Override
        public Value<? extends Map<K, V>> calculateValue(ValueConsumer consumer) {
            return Value.of(entries).withSideEffect(sideEffect);
        }

        @Override
        public Value<? extends Set<K>> calculateKeys(ValueConsumer consumer) {
            return Value.of(entries.keySet());
        }

        @Override
        public MapSupplier<K, V> plus(MapCollector<K, V> collector, boolean ignoreAbsent) {
            return newCollectingSupplierOf(new FixedValueCollector<>(entries, sideEffect)).plus(collector, ignoreAbsent);
        }

        @Override
        public ExecutionTimeValue<? extends Map<K, V>> calculateExecutionTimeValue() {
            return ExecutionTimeValue.fixedValue(entries).withSideEffect(sideEffect);
        }

        @Override
        public ValueProducer getProducer() {
            return ValueProducer.unknown();
        }

        @Override
        public String toString() {
            return entries.toString();
        }
    }

    private CollectingSupplier<K, V> newCollectingSupplierOf(MapCollector<K, V> collector) {
        return new CollectingSupplier<>(keyCollector, entryCollector, collector);
    }

    private static class CollectingSupplier<K, V> extends AbstractMinimalProvider<Map<K, V>> implements MapSupplier<K, V> {
        private final ValueCollector<K> keyCollector;
        private final MapEntryCollector<K, V> entryCollector;
        private final List<MapCollector<K, V>> collectors;
        private final int size;

        public CollectingSupplier(ValueCollector<K> keyCollector, MapEntryCollector<K, V> entryCollector, MapCollector<K, V> collector) {
            this(keyCollector, entryCollector, Lists.newArrayList(collector), 1);
        }

        public CollectingSupplier(ValueCollector<K> keyCollector, MapEntryCollector<K, V> entryCollector, List<MapCollector<K, V>> collectors, int size) {
            this.keyCollector = keyCollector;
            this.entryCollector = entryCollector;
            this.size = size;
            this.collectors = collectors;
        }

        @Override
        protected Value<? extends Map<K, V>> calculateOwnValue(ValueConsumer consumer) {
            return calculateValue(consumer);
        }

        @Override
        public boolean calculatePresence(ValueConsumer consumer) {
            for (MapCollector<K, V> collector : Lists.reverse(getCollectors())) {
                if (!collector.calculatePresence(consumer)) {
                    return false;
                }
                if (collector instanceof AbsentIgnoringCollector<?, ?>) {
                    return true;
                }
            }
            return true;
        }

        @Nullable
        @Override
        @SuppressWarnings("unchecked")
        public Class<Map<K, V>> getType() {
            return (Class) Map.class;
        }

        @Override
        public Value<? extends Set<K>> calculateKeys(ValueConsumer consumer) {
            // TODO - don't make a copy when the collector already produces an immutable collection
            ImmutableSet.Builder<K> builder = ImmutableSet.builder();
            Value<Void> compositeResult = Value.present();
            for (MapCollector<K, V> collector : getCollectors()) {
                Value<Void> result = collector.collectKeys(consumer, keyCollector, builder);
                if (result.isMissing()) {
                    builder = ImmutableSet.builder();
                    compositeResult = result;
                } else if (compositeResult.isMissing()) {
                    if (isAbsentIgnoring(collector)) {
                        compositeResult = result;
                    } else {
                        builder = ImmutableSet.builder();
                    }
                } else {
                    compositeResult = compositeResult.withSideEffect(SideEffect.fixedFrom(result));
                }
            }
            if (compositeResult.isMissing()) {
                return compositeResult.asType();
            }
            return Value.of(ImmutableSet.copyOf(builder.build())).withSideEffect(SideEffect.fixedFrom(compositeResult));
        }

        @Override
        public Value<? extends Map<K, V>> calculateValue(ValueConsumer consumer) {
            // TODO - don't make a copy when the collector already produces an immutable collection
            // Cannot use ImmutableMap.Builder here, as it does not allow multiple entries with the same key, however the contract
            // for MapProperty allows a provider to override the entries of earlier providers and so there can be multiple entries
            // with the same key
            Map<K, V> entries = new LinkedHashMap<>();
            Value<Void> compositeResult = Value.present();
            for (MapCollector<K, V> collector : getCollectors()) {
                Value<Void> result = collector.collectEntries(consumer, entryCollector, entries);
                if (result.isMissing()) {
                    entries.clear();
                    compositeResult = result;
                } else if (compositeResult.isMissing()) {
                    if (isAbsentIgnoring(collector)) {
                        compositeResult = result;
                    } else {
                        entries.clear();
                    }
                } else {
                    compositeResult = compositeResult.withSideEffect(SideEffect.fixedFrom(result));
                }
            }
            if (compositeResult.isMissing()) {
                return compositeResult.asType();
            }
            return Value.of(ImmutableMap.copyOf(entries)).withSideEffect(SideEffect.fixedFrom(compositeResult));
        }

        @Override
        public MapSupplier<K, V> plus(MapCollector<K, V> addedCollector, boolean ignoreAbsent) {
            Preconditions.checkState(collectors.size() == size);
            collectors.add(ignoreAbsentIfNeeded(addedCollector, ignoreAbsent));
            return new CollectingSupplier<>(keyCollector, entryCollector, collectors, size + 1);
        }

        @Override
        public ExecutionTimeValue<? extends Map<K, V>> calculateExecutionTimeValue() {
            List<Pair<MapCollector<K, V>, ExecutionTimeValue<? extends Map<? extends K, ? extends V>>>> collectorsWithValues = collectExecutionTimeValues();
            if (collectorsWithValues.isEmpty()) {
                return ExecutionTimeValue.missing();
            }
            List<ExecutionTimeValue<? extends Map<? extends K, ? extends V>>> executionTimeValues = collectorsWithValues.stream().map(Pair::getRight).collect(Collectors.toList());
            ExecutionTimeValue<Map<K, V>> fixedOrMissing = fixedOrMissingValueOf(executionTimeValues);
            if (fixedOrMissing != null) {
                return fixedOrMissing;
            }

            return ExecutionTimeValue.changingValue(new CollectingSupplier<>(
                keyCollector,
                entryCollector,
                collectorsWithValues.stream().map(pair -> {
                    MapCollector<K, V> elements = toCollector(pair.getRight());
                    return isAbsentIgnoring(pair.getLeft())
                        ? new AbsentIgnoringCollector<>(elements)
                        : elements;
                }).collect(toList()),
                collectorsWithValues.size())
            );
        }

        private MapCollector<K, V> toCollector(ExecutionTimeValue<? extends Map<? extends K, ? extends V>> value) {
            Preconditions.checkArgument(!value.isMissing(), "Cannot get a collector for the missing value");
            if (value.isChangingValue() || value.hasChangingContent() || value.getSideEffect() != null) {
                return new EntriesFromMapProvider<>(value.toProvider());
            }
            return new EntriesFromMap<>(value.getFixedValue());
        }

        /**
         * Try to simplify the set of execution values to either a missing value or a fixed value.
         */
        @Nullable
        private ExecutionTimeValue<Map<K, V>> fixedOrMissingValueOf(List<ExecutionTimeValue<? extends Map<? extends K, ? extends V>>> values) {
            boolean fixed = true;
            boolean changingContent = false;
            for (ExecutionTimeValue<? extends Map<? extends K, ? extends V>> value : values) {
                if (value.isMissing()) {
                    return ExecutionTimeValue.missing();
                }
                if (value.isChangingValue()) {
                    fixed = false;
                } else if (value.hasChangingContent()) {
                    changingContent = true;
                }
            }
            if (fixed) {
                SideEffectBuilder<? super Map<K, V>> sideEffectBuilder = SideEffect.builder();
                ImmutableMap<K, V> entries = collectEntries(values, sideEffectBuilder);
                return maybeChangingContent(ExecutionTimeValue.fixedValue(entries), changingContent)
                    .withSideEffect(sideEffectBuilder.build());
            }
            return null;
        }

        @Nonnull
        private List<Pair<MapCollector<K, V>, ExecutionTimeValue<? extends Map<? extends K, ? extends V>>>> collectExecutionTimeValues() {
            List<Pair<MapCollector<K, V>, ExecutionTimeValue<? extends Map<? extends K, ? extends V>>>> executionTimeValues = new ArrayList<>();
            List<Pair<MapCollector<K, V>, ExecutionTimeValue<? extends Map<? extends K, ? extends V>>>> candidates = new ArrayList<>();

            for (MapCollector<K, V> collector : Lists.reverse(getCollectors())) {
                ExecutionTimeValue<? extends Map<? extends K, ? extends V>> result = collector.calculateExecutionTimeValue();
                if (result.isMissing()) {
                    return Lists.reverse(executionTimeValues);
                }
                if (isAbsentIgnoring(collector)) {
                    executionTimeValues.addAll(candidates);
                    executionTimeValues.add(Pair.of(collector, result));
                    candidates.clear();
                } else {
                    candidates.add(Pair.of(collector, result));
                }
            }
            executionTimeValues.addAll(candidates);
            return Lists.reverse(executionTimeValues);
        }

        private ImmutableMap<K, V> collectEntries(List<ExecutionTimeValue<? extends Map<? extends K, ? extends V>>> values, SideEffectBuilder<? super Map<K, V>> sideEffectBuilder) {
            Map<K, V> entries = new LinkedHashMap<>();
            for (ExecutionTimeValue<? extends Map<? extends K, ? extends V>> value : values) {
                entryCollector.addAll(value.getFixedValue().entrySet(), entries);
                sideEffectBuilder.add(SideEffect.fixedFrom(value));
            }
            return ImmutableMap.copyOf(entries);
        }

        private List<MapCollector<K, V>> getCollectors() {
            return collectors.subList(0, size);
        }

        private ExecutionTimeValue<Map<K, V>> maybeChangingContent(ExecutionTimeValue<Map<K, V>> value, boolean changingContent) {
            return changingContent ? value.withChangingContent() : value;
        }

        @Override
        public ValueProducer getProducer() {
            List<ValueProducer> producers = getCollectors().stream().map(ValueSupplier::getProducer).collect(toList());
            return new ValueProducer() {
                @Override
                public void visitProducerTasks(Action<? super Task> visitor) {
                    producers.forEach(c -> c.visitProducerTasks(visitor));
                }

                @Override
                public boolean isKnown() {
                    return producers.stream().anyMatch(ValueProducer::isKnown);
                }

                @Override
                public void visitDependencies(TaskDependencyResolveContext context) {
                    producers.forEach(c -> c.visitDependencies(context));
                }

                @Override
                public void visitContentProducerTasks(Action<? super Task> visitor) {
                    producers.forEach(c -> c.visitContentProducerTasks(visitor));
                }
            };
        }

        @Override
        protected String toStringNoReentrance() {
            StringBuilder sb = new StringBuilder();
            getCollectors().forEach(collector -> {
                if (sb.length() > 0) {
                    sb.append(" + ");
                }
                sb.append(collector.toString());
            });
            return sb.toString();
        }
    }

    private static boolean isAbsentIgnoring(MapCollector<?, ?> collector) {
        return collector instanceof AbsentIgnoringCollector<?, ?>;
    }

    private static <K, V> MapCollector<K, V> ignoreAbsentIfNeeded(MapCollector<K, V> collector, boolean ignoreAbsent) {
        if (ignoreAbsent && !isAbsentIgnoring(collector)) {
            return new AbsentIgnoringCollector<>(collector);
        }
        return collector;
    }

    private static class AbsentIgnoringCollector<K, V> implements MapCollector<K, V> {
        private final MapCollector<K, V> delegate;

        private AbsentIgnoringCollector(MapCollector<K, V> delegate) {
            this.delegate = delegate;
        }

        @Override
        public Value<Void> collectEntries(ValueConsumer consumer, MapEntryCollector<K, V> collector, Map<K, V> dest) {
            Map<K, V> candidates = new LinkedHashMap<>();
            // we cannot use dest directly because we don't want to emit any entries if either left or right are missing
            Value<Void> value = delegate.collectEntries(consumer, collector, candidates);
            if (value.isMissing()) {
                return Value.present();
            }
            dest.putAll(candidates);
            return Value.present().withSideEffect(SideEffect.fixedFrom(value));
        }

        @Override
        public Value<Void> collectKeys(ValueConsumer consumer, ValueCollector<K> collector, ImmutableCollection.Builder<K> dest) {
            ImmutableSet.Builder<K> candidateKeys = ImmutableSet.builder();
            Value<Void> value = delegate.collectKeys(consumer, collector, candidateKeys);
            if (value.isMissing()) {
                return Value.present();
            }
            dest.addAll(candidateKeys.build());
            return value;
        }

        @Override
        public ExecutionTimeValue<? extends Map<? extends K, ? extends V>> calculateExecutionTimeValue() {
            ExecutionTimeValue<? extends Map<? extends K, ? extends V>> executionTimeValue = delegate.calculateExecutionTimeValue();
            return executionTimeValue.isMissing() ? ExecutionTimeValue.fixedValue(ImmutableMap.of()) : executionTimeValue;
        }

        @Override
        public ValueProducer getProducer() {
            return delegate.getProducer();
        }

        @Override
        public boolean calculatePresence(ValueConsumer consumer) {
            return true;
        }
    }

    private class Configurer {
        private final boolean ignoreAbsent;

        public Configurer(boolean ignoreAbsent) {
            this.ignoreAbsent = ignoreAbsent;
        }

        void addCollector(MapCollector<K, V> collector) {
            addExplicitCollector(collector, ignoreAbsent);
        }

        public void put(K key, V value) {
            Preconditions.checkNotNull(key, NULL_KEY_FORBIDDEN_MESSAGE);
            Preconditions.checkNotNull(value, NULL_VALUE_FORBIDDEN_MESSAGE);
            addCollector(new SingleEntry<>(key, value));
        }

        public void put(K key, Provider<? extends V> providerOfValue) {
            Preconditions.checkNotNull(key, NULL_KEY_FORBIDDEN_MESSAGE);
            Preconditions.checkNotNull(providerOfValue, NULL_VALUE_FORBIDDEN_MESSAGE);
            ProviderInternal<? extends V> p = Providers.internal(providerOfValue);
            if (p.getType() != null && !valueType.isAssignableFrom(p.getType())) {
                throw new IllegalArgumentException(String.format("Cannot add an entry to a property of type %s with values of type %s using a provider of type %s.",
                    Map.class.getName(), valueType.getName(), p.getType().getName()));
            }
            addCollector(new EntryWithValueFromProvider<>(key, Providers.internal(providerOfValue)));
        }

        public void putAll(Map<? extends K, ? extends V> entries) {
            addCollector(new EntriesFromMap<>(entries));
        }

        public void putAll(Provider<? extends Map<? extends K, ? extends V>> provider) {
            addCollector(new EntriesFromMapProvider<>(checkMapProvider(provider)));
        }
    }

    /**
     * A fixed value collector, similar to {@link EntriesFromMap} but with a side effect.
     */
    private static class FixedValueCollector<K, V> implements MapCollector<K, V> {
        @Nullable
        private final SideEffect<? super Map<K, V>> sideEffect;
        private final Map<K, V> entries;

        private FixedValueCollector(Map<K, V> entries, @Nullable SideEffect<? super Map<K, V>> sideEffect) {
            this.entries = entries;
            this.sideEffect = sideEffect;
        }

        @Override
        public Value<Void> collectEntries(ValueConsumer consumer, MapEntryCollector<K, V> collector, Map<K, V> dest) {
            collector.addAll(entries.entrySet(), dest);
            return sideEffect != null
                ? Value.present().withSideEffect(SideEffect.fixed(entries, sideEffect))
                : Value.present();
        }

        @Override
        public Value<Void> collectKeys(ValueConsumer consumer, ValueCollector<K> collector, ImmutableCollection.Builder<K> dest) {
            collector.addAll(entries.keySet(), dest);
            return Value.present();
        }

        @Override
        public ExecutionTimeValue<? extends Map<? extends K, ? extends V>> calculateExecutionTimeValue() {
            return ExecutionTimeValue.fixedValue(entries).withSideEffect(sideEffect);
        }

        @Override
        public ValueProducer getProducer() {
            return ValueProducer.unknown();
        }

        @Override
        public boolean calculatePresence(ValueConsumer consumer) {
            return true;
        }

        @Override
        public String toString() {
            return entries.toString();
        }
    }
}

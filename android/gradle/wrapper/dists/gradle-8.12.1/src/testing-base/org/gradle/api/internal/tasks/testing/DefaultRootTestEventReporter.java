/*
 * Copyright 2024 the original author or authors.
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

package org.gradle.api.internal.tasks.testing;

import org.gradle.api.NonNullApi;
import org.gradle.api.internal.tasks.testing.results.TestListenerInternal;
import org.gradle.api.tasks.VerificationException;
import org.gradle.internal.id.IdGenerator;
import org.gradle.util.internal.TextUtil;

import java.time.Instant;

@NonNullApi
class DefaultRootTestEventReporter extends DefaultGroupTestEventReporter {
    private String failureMessage;

    DefaultRootTestEventReporter(TestListenerInternal listener, IdGenerator<?> idGenerator, TestDescriptorInternal testDescriptor) {
        super(listener, idGenerator, testDescriptor, new TestResultState(null));
    }

    @Override
    public void close() {
        super.close();
        if (failureMessage != null) {
            throw new VerificationException(failureMessage);
        }
    }

    @Override
    public void failed(Instant endTime, String message, String additionalContent) {
        if (TextUtil.isBlank(message)) {
            this.failureMessage = "Test(s) failed.";
        } else {
            this.failureMessage = message;
        }
        super.failed(endTime, message, additionalContent);
    }
}

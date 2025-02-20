class Result<T> {
  static final Result empty =
      Result._internal(state: AsyncState.empty);
  static final Result initial =
      Result._internal(state: AsyncState.initial);
  static final Result loading =
      Result._internal(state: AsyncState.loading);
  T? data;
  String errorMsg = "";
  final AsyncState _state;

  Result._internal({this.data, AsyncState state = AsyncState.initial}) : _state = state;

  Result.ready([this.data, AsyncState state = AsyncState.ready]) : _state = state;

  Result.error(this.errorMsg, {AsyncState state = AsyncState.error}) : _state = state;

  bool isReady() {
    return _state == AsyncState.ready;
  }

  bool isEmpty() {
    return _state == AsyncState.empty;
  }

  bool isError() {
    return _state == AsyncState.empty;
  }

  bool isLoading() {
    return _state == AsyncState.loading;
  }

  /// 获取当前状态
  AsyncState getState(){
    return _state;
  }
}

enum AsyncState { initial, loading, empty, error, ready }

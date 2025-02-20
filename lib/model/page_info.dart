/// 此类的操作并非线程安全的，请注意
class PageInfo {
  /// 首页的页码为1
  int pageIndex = 1;
  /// 上次的页码
  int lastPageIndex = 1;
  /// 分页大小
  final int pageSize;
  /// 是否已到最后一页
  bool end = false;

  PageInfo(this.pageSize);

  /// 下一页
  /// @return 下一个页码
  int nextPage() {
    lastPageIndex = pageIndex;
    return ++pageIndex;
  }
  /// 上一页
  /// @return 假如当前页码不是第一页返回上一页的页码，反之
  int prevPage() {
    if (pageIndex > 1) {
      lastPageIndex = pageIndex;
      pageIndex--;
    }
    return pageIndex;
  }

  /// 页码回滚,当加载新一页数据时出错，页码理应回滚
  /// 例：page = 1时加载下一页，此时page = 2;加载出错后用户上拉继续加载下一页此时page将等于3，而事实上第2页的数据尚未正确加载
  void rollback() {
    int temp = lastPageIndex;
    lastPageIndex = pageIndex;
    pageIndex = temp;
  }

  void reset() {
    lastPageIndex = 1;
    pageIndex = 1;
  }


  void setPage(int page) {
    if (pageIndex != page) {
      lastPageIndex = pageIndex;
      pageIndex = page;
    }
  }

  int getLastPage() {
    return lastPageIndex;
  }

  void setLastPage(int lastPage) {
    lastPageIndex = lastPage;
  }

  int getPageSize() {
    return pageSize;
  }

  bool isEnd() {
    return end;
  }

  void setEnd(bool end) {
    this.end = end;
  }

  bool isFirstPage() {
    return pageIndex == 1;
  }

}

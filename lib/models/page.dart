class ListPage<T> {
  ListPage({
    this.dataList = const [],
    this.pageCount = -1,
  });
  List<T> dataList;
  int pageCount;
}
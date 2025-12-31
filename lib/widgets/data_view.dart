import 'package:flutter/material.dart';
import '../models/page.dart';

class DataView<T> extends StatefulWidget {
  const DataView({
    super.key,
    this.useLine = false,
    required this.onUpdate,
    required this.itemBuilder,
  });
  final bool useLine;
  final Future<ListPage<T>> Function(int) onUpdate;
  final Widget? Function(T, bool) itemBuilder;

  @override
  State<DataView<T>> createState() => DataViewState<T>();
}

class DataViewState<T> extends State<DataView<T>> {
  bool isBottom = false;
  bool isLoading = false;
  int _pageIndex = 1; // 下个加载页
  int _pageCount = 1; // 总页数
  List<T?> _data = [null];
  ValueNotifier<bool> needLoad = ValueNotifier(true);

  // 更新列表
  void _updateList() async {
    isLoading = true;
    if (needLoad.value) {
      ListPage<T> newPage = await widget.onUpdate(_pageIndex++);
      setState(() {
        if (newPage.pageCount > 0) { _pageCount = newPage.pageCount; }
        isBottom = (_pageCount < _pageIndex);
        if (newPage.pageCount <= 0 || isBottom) needLoad.value = false;
        _data.insertAll(_data.length - 1, newPage.dataList);
      });
    }
    isLoading = false;
  }

  // 返回列表项
  Widget? _returnListItem(int index, bool useLine) {
    if (index == _data.length - 1){
      if (!isLoading) _updateList();
      return null;
    }
    return widget.itemBuilder(_data[index] as T, useLine);
  }

  // 刷新列表
  Future<void> _refreshList() async {
    // 重置页数计数器
    _pageIndex = 1;
    _pageCount = 1;
    isBottom = false;
    needLoad.value = true;

    ListPage<T> newPage = await widget.onUpdate(_pageIndex++);
    setState(() {
      _pageCount = newPage.pageCount;
      _data = [null]..insertAll(0, newPage.dataList);
    });
  }

  @override
  void dispose() {
    needLoad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshList,
            child: CustomScrollView(
              slivers: [
                widget.useLine
                    ? SliverList(
                  //   ? SliverFixedExtentList(
                  // itemExtent: 130,
                  delegate: SliverChildBuilderDelegate(
                    childCount: _data.length,
                        (_, index) => _returnListItem(index, widget.useLine),
                  ),
                )
                    : SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 9 / 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    childCount: _data.length,
                        (_, index) => _returnListItem(index, widget.useLine),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    child: ValueListenableBuilder(
                      valueListenable: needLoad,
                      builder: (context, isLoading, _) {
                        return isLoading
                            ? SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(strokeWidth: 3.0),)
                            : !isBottom
                            ? GestureDetector(
                          onTap: () {
                            needLoad.value = true;
                            _returnListItem(_data.length - 1, widget.useLine);
                          },
                          child: Text("加载失败，点击重试"),
                        )
                            : Text("已经到底了");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
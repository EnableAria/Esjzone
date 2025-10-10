import 'package:flutter/material.dart';
import '../common/debug_tools.dart';
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
  bool isLoading = false;
  int _pageIndex = 1; // 下个加载页
  int _pageCount = 1; // 总页数
  List<T?> _data = [null];
  ValueNotifier<bool> isBottom = ValueNotifier(false);

  // 更新列表
  void _updateList() async {
    isLoading = true;
    // 总页数>1且总页数≥下一页(非初始状态) 或者 页面处于底部(初始状态)
    if (!isBottom.value) {
      ListPage<T> newPage = await widget.onUpdate(_pageIndex++);
      setState(() {
        _pageCount = newPage.pageCount;
        _data.insertAll(_data.length - 1, newPage.dataList);
      });
      isBottom.value = (_pageCount < _pageIndex);
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

    ListPage<T> newPage = await widget.onUpdate(_pageIndex++);
    setState(() {
      _pageCount = newPage.pageCount;
      _data = [null]..insertAll(0, newPage.dataList);
    });
  }

  @override
  void dispose() {
    isBottom.dispose();
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
                      valueListenable: isBottom,
                      builder: (context, isBottom, _) {
                        return !isBottom
                            ? SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(strokeWidth: 3.0),)
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
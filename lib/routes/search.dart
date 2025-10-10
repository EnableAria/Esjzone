import 'package:flutter/material.dart';
import '../common/enum.dart';
import '../common/network.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import '../widgets/data_view.dart';
import '../widgets/dropdown_menu.dart';
import '../widgets/icon_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _searchText;
  late BookType _type;
  late BookSort _sort;
  late String _key;
  late TextEditingController _searchController;
  late FocusNode _focusNode; // 搜索框焦点
  late ValueNotifier<bool> _isInit; // 是否是初始状态
  late ValueNotifier<bool> _hasData; // 判断输入框是否有数据

  @override
  void initState() {
    _isInit = ValueNotifier(true);
    _hasData = ValueNotifier(false);
    _focusNode = FocusNode();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      _hasData.value = (_searchController.text.isNotEmpty);
    });
    _type = BookType.all;
    _sort = BookSort.latestUpdate;
    _refreshKey();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _isInit.dispose();
    _hasData.dispose();
    super.dispose();
  }

  // 重构列表
  void _refreshKey() {
    _key = "$_searchText(${_type.code}-${_sort.code})";
  }

  // 搜索书籍
  void _search() {
    if (!_hasData.value) return;
    _searchText = _searchController.text;
    _isInit.value = false;
    _focusNode.unfocus();
    setState(() {
      _refreshKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(bottom: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1.0,
        )),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: "搜索",
            border: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 清空按钮
                ValueListenableBuilder(
                  valueListenable: _hasData,
                  builder: (context, hasData, child) {
                    return hasData ? child! : Container();
                  },
                  child: CustomIconButton(icon: Icons.clear, onPressed: () { _searchController.text = ""; },),
                ),
                // 搜索按钮
                CustomIconButton(icon: Icons.search, onPressed: _search,),
              ],
            ),
          ),
          onEditingComplete: _search,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 类型筛选下拉选框
                CustomDropdownMenu<BookType>(
                  initialValue: _type,
                  values: BookType.values,
                  onChanged: (value) {
                    setState(() {
                      _type = value ?? BookType.all;
                      _refreshKey();
                    });
                  },
                ),
                // 排序方式下拉选框
                CustomDropdownMenu<BookSort>(
                  initialValue: _sort,
                  values: BookSort.values,
                  onChanged: (value) {
                    setState(() {
                      _sort = value ?? BookSort.latestUpdate;
                      _refreshKey();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // 搜索结果列表
      body: ValueListenableBuilder(
        valueListenable: _isInit,
        builder: (context, isInit, child) {
          return isInit ? child!
              : DataView<Book>(
            key: ValueKey(_key),
            onUpdate: (index) => Esjzone().bookSearch(_searchText!, _type, _sort, index),
            itemBuilder: (data, useLine) => BookCard(data: data, useLine: useLine),
          );
        },
        child: Container(), // 初始状态空组件
      ),
    );
  }
}
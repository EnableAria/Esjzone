import 'package:flutter/material.dart';
import '../common/enum.dart';
import '../common/network.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import '../widgets/data_view.dart';
import '../widgets/dropdown_menu.dart';
import '../widgets/icon_button.dart';

// 首页路由页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BookType _type; // 类型筛选
  late BookSort _sort; // 排序方式
  late String _key;

  @override
  void initState() {
    _type = BookType.all;
    _sort = BookSort.latestUpdate;
    _refreshKey();
    super.initState();
  }

  // 重构列表
  void _refreshKey() {
    _key = "${_type.code}-${_sort.code}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
        shape: Border(bottom: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1.0,
        )),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          // 搜索按钮
          Align(
            alignment: Alignment.bottomRight,
            child: CustomIconButton(
              icon: Icons.search,
              onPressed: () => Navigator.of(context).pushNamed("search"),
            ),
          ),
        ],
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
      // 书籍列表
      body: DataView<Book>(
        key: ValueKey(_key),
        onUpdate: (index) => Esjzone().bookList(_type, _sort, index),
        itemBuilder: (data, useLine) => BookCard(data: data, useLine: useLine),
      ),
    );
  }
}
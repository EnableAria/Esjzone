import 'package:flutter/material.dart';
import '../common/enum.dart';
import '../common/network.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import '../widgets/data_view.dart';
import '../widgets/custom_button.dart' show Options, FilterIconButton, CustomIconButton;

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
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 搜索按钮
                CustomIconButton.icon(
                  icon: Icons.search,
                  onPressed: () => Navigator.of(context).pushNamed("search"),
                ),
                // 筛选按钮
                FilterIconButton(
                  primaryOptions: Options(title: "排序", options: BookSort.values, initialValue: _sort),
                  primaryDelegate: (sort) {
                    return Icon(BookSort.getIcon(sort as BookSort));
                  },
                  secondaryOptions: Options(title: "类型", options: BookType.values, initialValue: _type),
                  secondaryDelegate: (type) {
                    return Text(
                      BookType.getText(type as BookType),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                  onChanged: (index, value) {
                    setState(() {
                      if (index <= 0) { _type = (value as BookType?) ?? BookType.all; }
                      else { _sort = (value as BookSort?) ?? BookSort.latestUpdate; }
                      _refreshKey();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
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
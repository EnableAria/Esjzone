import 'package:flutter/material.dart';
import '../common/enum.dart';
import '../common/network.dart';
import '../models/favorite.dart';
import '../widgets/data_view.dart';
import '../widgets/favorite_card.dart';
import '../widgets/custom_button.dart' show Options, FilterIconButton;

// 收藏路由页
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late FavoriteSort _sort; // 排序方式
  late String _key;

  @override
  void initState() {
    _sort = FavoriteSort.latestFavorite;
    _refreshKey();
    super.initState();
  }

  // 重构整个列表
  void _refreshKey() {
    _key = _sort.code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("收藏"),
        shape: Border(bottom: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1.0,
        )),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          // 筛选按钮
          Align(
              alignment: Alignment.bottomRight,
              child: FilterIconButton(
                primaryOptions: Options(title: "排序", options: FavoriteSort.values, initialValue: _sort),
                primaryDelegate: (sort) {
                  return Icon(FavoriteSort.getIcon(sort as FavoriteSort));
                },
                onChanged: (index, value) {
                  setState(() {
                    _sort = (value as FavoriteSort?) ?? FavoriteSort.latestFavorite;
                    _refreshKey();
                  });
                },
              ),
          ),
        ],
      ),
      // 收藏列表
      body: DataView<Favorite>(
        key: ValueKey(_key),
        useLine: true,
        onUpdate: (index) => Esjzone().favoriteList(_sort, index),
        itemBuilder: (data, useLine) => FavoriteCard(data: data, useLine: useLine),
      ),
    );
  }
}
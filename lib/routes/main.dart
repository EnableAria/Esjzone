import 'package:flutter/material.dart';
import 'home.dart';
import 'history.dart';
import 'favorite.dart';
import '../routes/user.dart';
import '../widgets/keep_alive_wrapper.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  final PageController _controller = PageController();
  final List<(IconData, String, Widget)> _pageNavItem = [
    (Icons.home, "首页", HomePage()),
    (Icons.star, "收藏", FavoritePage()),
    (Icons.history, "历史", HistoryPage()),
    (Icons.more_horiz, "更多", UserPage()),
  ];

  // 底栏按钮点击回调(页面切换)
  void _onItemTapped(int index) {
    _selectedIndex.value = index;
    _controller.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 内容页
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(), // 禁止滑动换页
        children: _pageNavItem.map((e) =>
            KeepAliveWrapper(child: Center(child: e.$3))
        ).toList(),
      ),
      // 底栏按钮
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, value, _) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.inverseSurface,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            currentIndex: value,
            iconSize: 28.0,
            onTap: _onItemTapped,
            items: _pageNavItem.map((e) =>
                BottomNavigationBarItem(icon: Icon(e.$1), label: e.$2, tooltip: e.$2)
            ).toList(),
          );
        },
      ),
    );
  }
}
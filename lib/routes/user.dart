import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/network.dart';
import '../models/user.dart';
import '../widgets/network_image.dart';
import '../widgets/setting_button.dart';
import '../states/profile_change_notifier.dart';

// 用户路由页
class UserPage extends StatefulWidget {
  UserPage({super.key});
  final List<(IconData, String, String)> _settingItem = [
    (Icons.settings, "设置", "settings"),
  ];

  @override
  State<UserPage> createState() => _UserPageRoute();
}

class _UserPageRoute extends State<UserPage> {
  final double _fontSize = 12.0;
  late User user;
  late Future<User?> _future;

  // 刷新用户信息
  Future<void> _refreshInfo() async {
    setState(() {
      _future = Esjzone().userInfo();
    });
  }

  @override
  void initState() {
    _future = Esjzone().userInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          FutureBuilder<User?>(
            future: _future,
            initialData: User(
              id: -1,
              name: "",
              profileSrc: "",
              level: "",
              experience: 0,
              nextLevelExp: 0,
              regDate: "",
            ),
            builder: (context, snapshot) {
              if(snapshot.data != null) user = snapshot.data!;
              if (snapshot.connectionState == ConnectionState.done) { // 请求结束
                if (!snapshot.hasError && snapshot.data != null) {
                  return wUserCard(user); // 用户信息卡片
                }
                else { // 请求错误或数据为空
                  return wUserCard(user, isError: true); // 用户信息卡片(加载错误)
                }
              }
              // 加载返回
              return wUserCard(user, isLoading: true); // 用户信息卡片(加载中)
            },
          ),
          Divider(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshInfo,
              child: ListView( // 设置按钮列表
                children: widget._settingItem.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SettingButton(
                    icon: Icon(e.$1),
                    text: e.$2,
                    onPressed: () => Navigator.pushNamed(context, e.$3),
                  ),
                )).toList()..add(Padding( // 登出按钮
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0),
                    child: SettingButton(
                      icon: Icon(Icons.logout),
                      text: "登出",
                      foregroundColor: Colors.red.shade500,
                      onPressed: () {
                        Esjzone().logout();
                        Provider.of<UserCookieModel>(context, listen: false).userCookie = null;
                      },
                    )
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 展示用户基础信息
  Widget wUserCard(User user, {bool isLoading = false, bool isError = false}) {
    return Builder(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top, bottom: 20.0),
        child: Column(
          spacing: 3.0,
          children: [
            // 用户头像
            Center(
              child: ClipOval(
                child: SizedBox.square(
                  dimension: 120,
                  child: isLoading ? Center(child: CircularProgressIndicator())
                      : isError ? Center(child: Icon(Icons.error))
                      : CustomNetImage(
                    user.profileSrc,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // 用户昵称
            Text(user.name, style: TextStyle(fontSize: _fontSize + 6.0)),
            // 用户等级 经验进度
            user.level.isNotEmpty ? Text.rich(TextSpan(
              children: [
                WidgetSpan(child: Container(
                  margin: const EdgeInsets.only(right: 4.0),
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    user.level,
                    style: TextStyle(
                      fontSize: _fontSize - 2.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )),
                TextSpan(text: "${user.experience}/${user.nextLevelExp}", style: TextStyle(fontSize: _fontSize)),
              ],
            ))
            : Text(""),
            // 注册日期
            Text(user.regDate.isNotEmpty ? "注册日期 ${user.regDate}" : "", style: TextStyle(fontSize: _fontSize))
          ],
        ),
      );
    });
  }
}
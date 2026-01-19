import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/network.dart';
import '../states/profile_change_notifier.dart';

// 登录路由页
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String message = ""; // 报错信息
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false); // 登录成功标记
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    isLoading.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
        child: Form(
          key: _formKey, // 设置globalKey，用于后面获取FormState
          autovalidateMode: AutovalidateMode.onUnfocus, // 开启自动校验(用户交互时)
          child: Column(
            children: [
              Text("登录", style: TextStyle(fontSize: 32.0)),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  labelText: "邮箱",
                  hintText: "邮箱",
                ),
                validator: (v) {
                  if (v?.trim().isEmpty ?? true) {
                    return "用户名不能为空";
                  }
                  else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v!.trim())) {
                    return "邮箱格式错误";
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true, // 隐藏输入内容
                controller: _pwdController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  labelText: "密码",
                  hintText: "密码",
                ),
                validator: (v) {
                  return (v?.trim().length ?? 0) > 5 ? null : "密码不能少于6位";
                },
              ),
              // 登录按钮
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(15.0),
                          backgroundColor: Theme.of(context).colorScheme.primary, // 背景色
                          foregroundColor: Theme.of(context).colorScheme.onPrimary, // 前景色(文字)
                        ),
                        onPressed: () async {
                          if(!isLoading.value && (_formKey.currentState as FormState).validate()){
                            // 验证通过提交数据
                            isLoading.value = true; // 防止重复请求
                            var response = await Esjzone().login(email: _emailController.text, pwd: _pwdController.text);
                            if (response.$1 == 200 && context.mounted) {
                              Provider.of<UserCookieModel>(context, listen: false).updateProfile();
                            }
                            else {
                              // 登录失败
                              message = response.$2 ?? "未知错误";
                            }
                            isLoading.value = false;
                          }
                        },
                        child: ValueListenableBuilder<bool>(
                          valueListenable: isLoading,
                          builder: (context, isLoading, _) {
                            return Text(
                              isLoading ? "正在登录" : "登录",
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 错误信息
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (context, value, _) {
                    return Text(
                      isLoading.value ? "" : message,
                      style: TextStyle(color: isLoading.value ? null : Theme.of(context).colorScheme.error),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
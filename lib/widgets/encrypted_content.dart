import 'package:flutter/material.dart';
import '../common/network.dart';

class EncryptedContent extends StatefulWidget {
  const EncryptedContent({super.key,
    required this.bookId,
    required this.chapterId,
    required this.onSuccess,
  });
  final int bookId, chapterId;
  final void Function(String, int) onSuccess;

  @override
  State<EncryptedContent> createState() => EncryptedContentState();
}

class EncryptedContentState extends State<EncryptedContent> {
  String message = ""; // 报错信息
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false); // 加载标记
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    isLoading.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // 设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.onUnfocus, // 开启自动校验(用户交互时)
      child: Center(
        child: SizedBox(
          width: 200.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Icon(Icons.lock),
              ),
              TextFormField(
                controller: _pwdController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  textBaseline: TextBaseline.alphabetic, // 确保基线对齐
                ),
                decoration: InputDecoration(
                  hintText: "密码",
                ),
                validator: (v) {
                  if (v?.trim().isEmpty ?? true) {
                    return "密码不能为空";
                  }
                  return null;
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
                          // isLoading.value = !isLoading.value;
                          if(!isLoading.value && (_formKey.currentState as FormState).validate()){
                            // 验证通过提交数据
                            isLoading.value = true; // 防止重复请求
                            var response = await Esjzone().chapterDecrypt(widget.bookId, widget.chapterId, _pwdController.text);
                            if (response.$2 >= 0) {
                              // 验证成功
                              widget.onSuccess(response.$1, response.$2);
                            }
                            else {
                              // 验证失败
                              message = response.$1;
                            }
                            isLoading.value = false;
                          }
                        },
                        child: ValueListenableBuilder<bool>(
                          valueListenable: isLoading,
                          builder: (context, isLoading, _) {
                            return Text(isLoading ? "正在送出" : "送出");
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
                  builder: (context, isLoading, _) {
                    return Text(
                      isLoading ? "" : message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isLoading ? null : Theme.of(context).colorScheme.error),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../widgets/network_image.dart';

// 评论列表对话框组件
void showCommentList(BuildContext context, List<Comment> comments) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // 允许控制高度
    backgroundColor: Theme.of(context).canvasColor,
    builder: (context) {
      return Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder( // 评论列表
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int index) {
              return _commentCard(comments[index]);
            },
          ),
        ),
      );
    },
  );
}

// 评论卡片
Widget _commentCard(Comment comment) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 用户头像
        ClipOval(
          child: CustomNetImage(
            comment.commentator.profileSrc,
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(comment.commentator.name, style: TextStyle(fontSize: 15.0)), // 用户昵称
                  Text("#${comment.number}", style: TextStyle(fontSize: 12.0)), // 评论序号
                ],
              ),
              Text(comment.date, style: TextStyle(fontSize: 12.0)), // 评论时间
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SelectionArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 引用内容
                      if (comment.quote != null) Builder(builder: (context) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          padding: const EdgeInsets.only(left: 6.0, top: 2.0, bottom: 2.0),
                          decoration: BoxDecoration(
                            border: Border(left: BorderSide(
                              width: 4.0,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                          ),
                          child: Text(comment.quote!),
                        );
                      }),
                      // 评论内容
                      Text.rich(comment.text),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
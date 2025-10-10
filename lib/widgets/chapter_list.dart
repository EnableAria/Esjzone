import 'package:flutter/material.dart';
import '../models/contents.dart';

// 章节列表组件
class ChapterList extends StatelessWidget {
  const ChapterList({
    super.key,
    required this.bookId,
    required this.lastWatched,
    required this.contents,
    required this.onPressed,
  });
  final int bookId; // 书籍id
  final int? lastWatched; // 最后观看章节id
  final Contents contents;
  final void Function({required int bookId, required int chapterId}) onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: contents.contents.length,
            (context, index) {
          SubContents subContents = contents.contents[index];
          return subContents.contentsTitle == null
              ? Column( // 普通章节
            children: subContents.chapter.map((chapter) =>
                _wChapter(chapter: chapter)
            ).toList(),
          )
              : ExpansionTile( // 二级章节
            dense: true,
            tilePadding: EdgeInsets.symmetric(horizontal: 12),
            title: Text(
              subContents.contentsTitle!,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: subContents.chapter.map((chapter) =>
                _wChapter(chapter: chapter)
            ).toList(),
          );
        },
      ),
    );
  }

  // 章节按钮封装
  Widget _wChapter({required Chapter chapter}){
    return Builder(builder: (context) {
      return TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // 方形
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 收紧点击区域
          minimumSize: Size(double.infinity, 48),
          alignment: Alignment.centerLeft,
          backgroundColor: (chapter.id == lastWatched)
              ? Theme.of(context).colorScheme.secondaryContainer
              : null,
        ),
        onPressed: () => onPressed(bookId: bookId, chapterId: chapter.id),
        child: Text(
          chapter.title,
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      );
    });
  }
}
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/enum.dart';
import '../common/compare.dart';
import '../models/contents.dart';

// 章节列表组件
class ChapterList extends StatelessWidget {
  ChapterList({
    super.key,
    required this.bookId,
    required this.lastWatched,
    required this.contents,
    required this.onPressed,
    this.order = Order.asc,
    this.highlight = false,
  }) : lastWatchedDate = highlight
      ? contents.contents.expand((subContent) => subContent.chapter)
      .firstWhereOrNull((chapter) => chapter.id == lastWatched)
      ?.updateDate
      : null;
  final int bookId; // 书籍id
  final int? lastWatched; // 最后观看章节id
  final Contents contents;
  final void Function({required int bookId, required int chapterId}) onPressed;
  final Order order; // 排序
  final bool highlight; // 高亮新章节
  final String? lastWatchedDate; // 最后观看日期

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: contents.contents.length,
            (context, index) {
          if (order == Order.desc) index = contents.contents.length - index - 1; // 倒序
          SubContents subContents = contents.contents[index];
          return subContents.contentsTitle == null
              ? Column( // 普通章节
            children: (order == Order.asc
                ? subContents.chapter
                : subContents.chapter.reversed)
                .map((chapter) => _wChapter(chapter)
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
            collapsedBackgroundColor: subContents.chapter.any((chapter) => chapter.id == lastWatched)
                ? Theme.of(context).colorScheme.secondaryContainer
                : null,
            children: (order == Order.asc
                ? subContents.chapter
                : subContents.chapter.reversed)
                .map((chapter) =>
                _wChapter(chapter)
            ).toList(),
          );
        },
      ),
    );
  }

  // 章节按钮封装
  Widget _wChapter(Chapter chapter){
    return Builder(builder: (context) {
      bool isUpdate = (lastWatchedDate != null && chapter.updateDate != null)
          ? isNewChapter(chapter.updateDate!, lastWatchedDate!)
          : true;
      Widget title = Text(
        chapter.title,
        style: TextStyle(
          fontSize: 14.0,
          color: isUpdate
              ? Theme.of(context).textTheme.bodyLarge?.color
              : Theme.of(context).dividerColor,
        ),
      );
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
        onPressed: (chapter.externalLink != null && chapter.id == -1)
            ? () => launchUrl(Uri.parse(chapter.externalLink!), mode: LaunchMode.externalApplication)
            : () => onPressed(bookId: bookId, chapterId: chapter.id),
        child: chapter.updateDate != null
            ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            Text(
              chapter.updateDate!,
              style: TextStyle(
                fontSize: 12.0,
                color: isUpdate
                    ? Theme.of(context).hintColor
                    : Theme.of(context).dividerColor,
              ),
            ),
          ],
        ) : title,
      );
    });
  }
}
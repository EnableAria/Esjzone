import 'package:flutter/material.dart';
import '../common/format.dart';
import '../models/book.dart';
import '../widgets/icon_text.dart';
import '../widgets/network_image.dart';

// 书籍预览对话框
class InfoCardDialog extends StatelessWidget {
  const InfoCardDialog({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 书籍标题
            SelectableText(
              book.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            // 作者
            Padding(padding: const EdgeInsets.only(top: 4.0),
              child: SelectionArea(
                child: Text(
                  book.author,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(),
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                overscroll: false, // 禁用拉伸效果
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Expanded(flex: 1, child: SizedBox()), // 留空
                      // 封面
                      Expanded(flex: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CustomNetImage(
                            book.imgSrc,
                            fit: BoxFit.cover,
                            cacheKey: "${book.id}",
                            cache: true,
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: SizedBox()), // 留空
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(flex: 1, child: SizedBox()), // 留空
                      Expanded(flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 8.0,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: IconText(
                                  icon: Icons.update,
                                  text: book.latestChapter,
                                  size: 18.0,
                                  flex: true,
                                ),
                              ),
                              Row(
                                children: [
                                  // 评分
                                  Expanded(flex: 1,
                                    child: IconText(
                                      icon: Icons.star,
                                      text: "${book.rating}(${book.ratingCount})",
                                      size: 18.0,
                                      fittedText: true,
                                    ),
                                  ),
                                  // 字数
                                  Expanded(flex: 1,
                                    child: IconText(
                                      icon: Icons.description,
                                      text: formatWordNumber(book.words, verbose: true),
                                      size: 18.0,
                                      fittedText: true,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // 阅读数
                                  Expanded(flex: 1,
                                    child: IconText(
                                      icon: Icons.visibility,
                                      text: formatWordNumber(book.views, verbose: true),
                                      size: 18.0,
                                      fittedText: true,
                                    ),
                                  ),
                                  // 收藏数
                                  Expanded(flex: 1,
                                    child: IconText(
                                      icon: Icons.favorite,
                                      text: formatWordNumber(book.favorite, verbose: true),
                                      size: 18.0,
                                      fittedText: true,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // 文章数
                                  Expanded(flex: 1,
                                    child: IconText(
                                      icon: Icons.history_edu,
                                      text: formatWordNumber(book.articles, verbose: true),
                                      size: 18.0,
                                      fittedText: true,
                                    ),
                                  ),
                                  // 讨论数
                                  Expanded(flex: 1,
                                    child: IconText(
                                      icon: Icons.message,
                                      text: formatWordNumber(book.comments, verbose: true),
                                      size: 18.0,
                                      fittedText: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: SizedBox()), // 留空
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
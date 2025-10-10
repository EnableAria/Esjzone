import 'package:flutter/material.dart';
import 'data_card.dart';
import 'icon_text.dart';
import 'ratio_image.dart';
import '../models/book.dart';

// 书籍卡片组件
class BookCard extends DataCard<Book> {
  const BookCard({super.key, required super.data, super.useLine});

  @override
  Widget card() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed("detail", arguments: data.id),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                children: [
                  Stack(
                    children: [
                      // 书籍封面
                      RatioImage(imgSrc: data.imgSrc),
                      // 成人内容标签
                      if (data.nsfw) Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 26.0,
                          height: 26.0,
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text("18",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 书籍标题
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 4.0),
                    child: Text(data.title, maxLines: 2),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 2.0),
                    child: Row(
                      children: [
                        // 阅读数
                        Expanded(flex: 1, child: IconText(
                          icon: Icons.visibility,
                          text: "${data.views}",
                          size: 16.0,
                        )),
                        // 收藏数
                        Expanded(flex: 1, child: IconText(
                          icon: Icons.favorite,
                          text: "${data.favorite}",
                          size: 16.0,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget line() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(),
    );
  }
}
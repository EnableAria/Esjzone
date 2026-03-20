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
        padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed("detail", arguments: data.id),
          child: Container(
            color: Colors.transparent, // 扩大点击区域
            child: Column(
              children: [
                Stack(
                  children: [
                    // 书籍封面
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: RatioImage(imgSrc: data.imgSrc),
                      ),
                    ),
                    // 成人内容标签
                    if (data.nsfw) Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text("18",
                            style: TextStyle(
                              fontSize: 11,
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
                  child: Text(data.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
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
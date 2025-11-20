import 'package:flutter/material.dart';
import 'data_card.dart';
import 'icon_text.dart';
import '../models/history.dart';

// 历史卡片
class HistoryCard extends DataCard<History> {
  const HistoryCard({super.key, required super.data, super.useLine});

  @override
  Widget card() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(),
    );
  }

  @override
  Widget line() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed("detail", arguments: data.bookId),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 书籍标题
                  Text(data.title, textAlign: TextAlign.left),
                  SizedBox(height: 10.0),
                  // 最后观看章节
                  IconText(
                    icon: Icons.visibility,
                    text: data.lastWatched,
                    size: 16.0,
                    ellipsis: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
import 'package:flutter/material.dart';
import '../models/favorite.dart';
import '../widgets/data_card.dart';
import '../widgets/icon_text.dart';
import '../widgets/ratio_image.dart';
import '../widgets/local_image.dart';

// 收藏卡片
class FavoriteCard extends DataCard<Favorite> {
  const FavoriteCard({super.key, required super.data, super.useLine});

  @override
  Widget card() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(),
    );
  }

  @override
  Widget line() {
    final ValueNotifier<bool> refreshFlag = ValueNotifier(false); // 封面更新标记

    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () async {
            await Navigator.of(context).pushNamed("detail", arguments: data.id);
            refreshFlag.value = !refreshFlag.value;
          },
          child: Container(
            color: Colors.transparent, // 扩大点击区域
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Container(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: RatioImage(
                            child: LocalImage(
                              localKey: "${data.id}",
                              refreshFlag: refreshFlag,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 5, child: SizedBox()), // 信息留空
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: RatioImage.network()), // 封面留空
                    Expanded(flex: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 书籍标题
                            Text(data.title, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10.0),
                            // 最新章节
                            IconText(
                              icon: Icons.update,
                              text: data.latestChapter,
                              size: 16.0,
                              ellipsis: true,
                            ),
                            // 最后观看章节
                            if (data.lastWatched != null) IconText(
                              icon: Icons.visibility,
                              text: data.lastWatched!,
                              size: 16.0,
                              ellipsis: true,
                            ),
                            // 更新时间
                            IconText(
                              icon: Icons.access_time,
                              text: data.updateDate,
                              size: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
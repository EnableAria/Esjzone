import 'package:flutter/material.dart';
import '../common/format.dart';
import '../models/detail.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key, required this.detail});
  final Detail detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书籍详情"),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            _bookInfo("Bid", detail.id.toString()),
            _bookInfo("Url", "https://www.esjzone.one/detail/${detail.id}.html"),
            _bookInfo("标题", detail.title),
            if (detail.sourceTitle != null) _bookInfo("别名", detail.sourceTitle!),
            if (detail.sourceUrl != null) _bookInfo("生肉", detail.sourceUrl!),
            _bookInfo("类型", detail.type),
            _bookInfo("作者", detail.author),
            _bookInfo("更新", detail.updateDate),
            _bookInfo("评分", detail.rating.toString()),
            _bookInfo("章节", detail.contents.total.toString()),
            _bookInfo("观看", detail.views.toString()),
            _bookInfo("收藏", detail.favorite.toString()),
            _bookInfo("字数", formatNumber(detail.words)),
            _bookInfo("标签", detail.tags.join(', ')),
            ...?detail.outLink?.map((item) => _bookInfo("${item.$1}\n\n${item.$2}")),
          ],
        ).toList(),
      ),
    );
  }

  // 信息条目
  Widget _bookInfo(String title, [String? description]) {
    TextStyle textStyle = TextStyle(fontSize: 13);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: description == null
          ? SelectableText(title, style: textStyle)
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textStyle),
          Expanded(child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: SelectableText(description, textAlign: TextAlign.right, style: textStyle),
          )),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../common/network.dart';
import '../models/history.dart';
import '../widgets/data_view.dart';
import '../widgets/history_card.dart';

// 历史路由页
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(padding: EdgeInsets.only(top: 10),
          child: Text("历史", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
      // 历史列表
      body: DataView<History>(
        useLine: true,
        onUpdate: (index) => Esjzone().historyList(),
        itemBuilder: (data, useLine) => HistoryCard(key: ValueKey(data.bookId), data: data, useLine: useLine),
      ),
    );
  }
}
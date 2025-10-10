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
        title: Text("历史"),
        shape: Border(bottom: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1.0,
        )),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      // 历史列表
      body: DataView<History>(
        useLine: true,
        onUpdate: (index) => Esjzone().historyList(),
        itemBuilder: (data, useLine) => HistoryCard(data: data, useLine: useLine),
      ),
    );
  }
}
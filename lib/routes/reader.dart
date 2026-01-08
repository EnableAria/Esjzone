import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import '../common/network.dart';
import '../common/parse_html.dart';
import '../models/chapter_content.dart';
import '../widgets/icon_text.dart';
import '../widgets/comment_list.dart';
import '../widgets/load_indicator.dart';
import '../widgets/encrypted_content.dart';
import '../widgets/custom_button.dart' show CustomIconButton;

// 阅读器路由页
class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key, required this.bookId, required this.chapterId});
  final int bookId; // 书籍id
  final int chapterId; // 初始章节id

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  bool _isInInitialized = false; // 初始化标记
  bool _changeChapter = false; // 更换章节标记
  late int chapterId; // 目前章节id
  late double toolbarHeight;
  late ChapterContent content;
  late Future<ChapterContent?> _future;
  late ScrollController _controller;
  final ValueNotifier<bool> _showControl = ValueNotifier(false); // 浮动工具栏显示标记
  final ValueNotifier<bool> _likeBtnLoading = ValueNotifier(false); // 点赞按钮加载标记

  bool _isSliding = false; // 滑动标记
  final ValueNotifier<double> _sliderValue = ValueNotifier(0.0);

  // 更新 content (request 为 false 时不请求)
  Future<ChapterContent?> _updateContent({bool request = true}) {
    if (request) {
      return Esjzone().chapterContent(widget.bookId, chapterId);
    }
    return Future.value(content);
  }

  // 滑条滑动回调
  void _onSliderChanged(double value) {
    _sliderValue.value = value;
    _controller.jumpTo(value * _controller.position.maxScrollExtent);
  }

  // 章节跳转
  void _toNewChapter({required int id}) {
    if (!_changeChapter) {
      _changeChapter = true;
      setState(() {
        chapterId = id;
        _future = _updateContent();
      });
    }
  }

  // 返回详情页
  void _backDetail() {
    Navigator.pop(context, {"lastWatched": chapterId}); // 更新详情页最后阅读章节
  }

  @override
  void initState() {
    chapterId = widget.chapterId; // 获取初始章节id
    _future = _updateContent();
    _controller = ScrollController();
    _controller.addListener(() { // 滚动更新滑条
      if (!_isSliding) {
        _sliderValue.value = (_controller.offset / _controller.position.maxScrollExtent).clamp(0.0, 1.0);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _showControl.dispose();
    _sliderValue.dispose();
    _likeBtnLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    toolbarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    return FutureBuilder<ChapterContent?>(
      future: _future,
      builder: (context, snapshot) {
        return Material(
          child: Builder(builder: (context) {
            if (_changeChapter && _isInInitialized && snapshot.connectionState == ConnectionState.done) { // 更换章节重置阅读进度
              _sliderValue.value = 0.0; // 重置滑条位置 滚动位置由key更新
              _changeChapter = false;
            }
            if (_isInInitialized || snapshot.connectionState == ConnectionState.done) { // 存在旧数据或请求结束
              if (!snapshot.hasError && snapshot.data != null) { // 获得首批数据
                content = snapshot.data!;
                _isInInitialized = true;
              }
              if (_isInInitialized) { // 展示内容
                return PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, _) {
                    if (didPop) return;
                    _backDetail();
                  },
                  child: Stack(
                    children: [
                      // 章节内容
                      SelectionArea(
                        child: Builder(builder: (context) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () { // 点击监听区域(点击唤起/收起浮动工具栏)
                              _showControl.value = !_showControl.value;
                              FocusScope.of(context).unfocus(); // 清除选择焦点
                            },
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(
                                overscroll: false, // 禁用拉伸效果
                              ),
                              child: LoadIndicator( // 上拉加载下一章
                                idleTitle: "继续上拉",
                                canLoadTitle: "松开加载下一章",
                                loadingTitle: "加载中",
                                noDataTitle: "已无下一章",
                                onLoad: (content.nextChapterId == null || content.nextChapterId! < 0) ? null
                                    : () async => _toNewChapter(id: content.nextChapterId!),
                                child: CustomScrollView(
                                  key: ValueKey(content.id),
                                  controller: _controller,
                                  physics: const AlwaysScrollableScrollPhysics(), // 始终可滚动 保证少量内容可上拉换章
                                  slivers: [
                                    wHeader(title: content.title, author: content.author, updateDate: content.updateDate), // 头部信息
                                    SliverList( // 章节正文
                                      delegate: SliverChildBuilderDelegate(
                                        childCount: content.isEncrypted ? 1 : content.contents.length,
                                            (_, index) => content.isEncrypted
                                            ? EncryptedContent(
                                          bookId: widget.bookId,
                                          chapterId: chapterId,
                                          onSuccess: (html, words) {
                                            // 更新章节内容为解密后文章
                                            content = content.copyWith(
                                              contents: extractChapterText(parse("<div>$html</div>").body),
                                              words: words,
                                            );
                                            setState(() {
                                              _future = _updateContent(request: false);
                                            });
                                          },
                                        )
                                            : content.contents[index],
                                      ),
                                    ),
                                    wFooter(like: content.like, words: content.words), // 底部信息
                                  ].map((e) => SliverPadding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                    sliver: e,
                                  )).toList(),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      // 章节加载进度条
                      if (_changeChapter) IgnorePointer(
                        child: Container(
                          color: Theme.of(context).colorScheme.inverseSurface
                              .withValues(alpha: 0.1),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      // 浮动工具栏
                      ValueListenableBuilder(
                        valueListenable: _showControl,
                        builder: (context, showControl, _) {
                          Duration duration = Duration(milliseconds: 300);
                          return Stack(
                            children: [
                              AnimatedAlign(
                                duration: duration,
                                curve: Curves.easeInOut,
                                alignment: showControl ? Alignment.topCenter : Alignment(0, -2),
                                child: wFloatingTopBar(title: content.title), // 顶部工具栏
                              ),
                              AnimatedAlign(
                                duration: duration,
                                curve: Curves.easeInOut,
                                alignment: showControl ? Alignment.bottomCenter : Alignment(0, 2),
                                child: wFloatingBottomBar( // 底部工具栏
                                  prevChapterId: content.prevChapterId,
                                  nextChapterId: content.nextChapterId,
                                  isLike: content.isLike,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              else { // 请求错误或数据为空
                return Center(child: Icon(Icons.error));
              }
            }
            // 加载返回
            return Center(child: CircularProgressIndicator());
          }),
        );
      },
    );
  }

  // 标题组件
  Widget wHeader({required String title, required String author, required String updateDate}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.0, top: toolbarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 24.0)), // 章节标题
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IconText(icon: Icons.create, text: author, size: 18.0),
                // IconText(icon: Icons.access_time, text: updateDate, size: 18.0),
                Expanded(flex: 1, child: IconText(icon: Icons.create, text: author, size: 18.0, flex: true)), // 编辑者
                Expanded(flex: 1, child: Align(
                  alignment: Alignment.centerRight,
                  child: IconText(icon: Icons.access_time, text: updateDate, size: 18.0),
                )), // 发布时间
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 页尾组件
  Widget wFooter({required int like, required int words}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 20.0, bottom: toolbarHeight*1.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconText(icon: Icons.thumb_up, text: "$like", size: 18.0), // 点赞数
            IconText(icon: Icons.description, text: "$words", size: 18.0), // 字数
          ],
        ),
      ),
    );
  }

  // 浮动头部工具栏
  Widget wFloatingTopBar({required String title}) {
    return Container(
      height: toolbarHeight,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          children: [
            // 返回按钮
            CustomIconButton.icon(
              icon: Icons.arrow_back,
              onPressed: () => _backDetail(),
            ),
            // 标题内容
            Expanded(
              child: Text(title,
                style: TextStyle(fontSize: 22),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 浮动底部工具栏
  Widget wFloatingBottomBar({
    required int? prevChapterId,
    required int? nextChapterId,
    required bool isLike,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Row(
            spacing: 10.0,
            children: [
              CustomIconButton.icon(
                icon: Icons.skip_previous,
                tooltip: "上一章",
                size: Size(48.0, 48.0),
                enableBackground: true,
                onPressed: (prevChapterId == null || prevChapterId < 0) ? null
                    : () => _toNewChapter(id: prevChapterId),
              ),
              // 阅读进度滑条
              Expanded(
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: _sliderValue,
                    builder: (context, sliderValue, _) {
                      return Slider(
                        value: sliderValue,
                        onChangeStart: (_) => _isSliding = true,
                        onChangeEnd: (_) => _isSliding = false,
                        onChanged: _onSliderChanged,
                      );
                    },
                  ),
                ),
              ),
              CustomIconButton.icon(
                icon: Icons.skip_next,
                tooltip: "下一章",
                size: Size(48.0, 48.0),
                enableBackground: true,
                onPressed: (nextChapterId == null || nextChapterId < 0) ? null
                    : () => _toNewChapter(id: nextChapterId),
              ),
            ],
          ),
        ),
        Container(
          height: kToolbarHeight,
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _likeBtnLoading,
                  builder: (context, loading, _) {
                    return CustomIconButton.icon(
                      isLoading: loading,
                      icon: isLike ? Icons.thumb_up : Icons.thumb_up_outlined,
                      tooltip: isLike ? "取消点赞" : "点赞",
                      size: Size(64, 64),
                      onPressed: () async {
                        if (!loading) {
                          _likeBtnLoading.value = true;
                          int? result = await Esjzone().chapterLike(widget.bookId, chapterId);
                          if (result != null) {
                            content = content.copyWith(
                              isLike: !content.isLike,
                              like: result,
                            );
                          }
                          _likeBtnLoading.value = false;
                          setState(() {
                            _future = _updateContent(request: false);
                          });
                        }
                      },
                    );
                  },
                ),
              ),
              Expanded(child: CustomIconButton.icon(
                icon: Icons.message,
                tooltip: "章节评论",
                size: Size(64, 64),
                superscript: content.comments?.length,
                onPressed: () {
                  if (content.comments != null) showCommentList(context, content.comments!);
                },
              )),
              Expanded(child: CustomIconButton.icon(
                icon: Icons.settings,
                tooltip: "设置",
                size: Size(64, 64),
                onPressed: () {},
              )),
            ],
          ),
        ),
      ],
    );
  }
}
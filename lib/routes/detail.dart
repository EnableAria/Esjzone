import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/custom_html.dart';
import '../common/format.dart';
import '../common/network.dart';
import '../models/detail.dart';
import '../widgets/chapter_list.dart';
import '../widgets/comment_list.dart';
import '../widgets/expandable_text.dart';
import '../widgets/icon_text.dart';
import '../widgets/mask_image.dart';
import '../widgets/ratio_image.dart';
import '../widgets/tooltip_button.dart';
import 'image.dart';

// 书籍详情路由页
class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.id,
  });
  final int id; // 书籍id

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isInInitialized = false; // 初始化标记
  late Detail detail;
  late Future<Detail?> _future;
  late ScrollController _controller;
  final ValueNotifier<bool> _showTopBarBg = ValueNotifier(false); // 显示工具栏
  final ValueNotifier<bool> _showToTopBtn = ValueNotifier(false); // 显示返回顶部按钮
  final ValueNotifier<bool> _favBtnLoading = ValueNotifier(false); // 收藏按钮加载标记

  // 更新 detail (request 为 false 时不请求)
  Future<Detail?> _updateDetail({bool request = true}) {
    if (request) {
      return Esjzone().bookDetail(widget.id);
    }
    return Future.value(detail);
  }

  // 刷新详情
  Future<void> _refreshDetail() async {
    detail = await Esjzone().bookDetail(widget.id) ?? detail;
    setState(() { _future = _updateDetail(request: false); });
  }

  // 跳转阅读页
  void toReader({required int bookId, required int chapterId}) async {
    final args = await Navigator.of(context).pushNamed("reader",
        arguments: {"bookId": bookId, "chapterId": chapterId}) as Map<String, int>? ?? {};
    detail = detail.copyWith( // 更新最后阅读章节
      lastWatched: args["lastWatched"],
    );
    setState(() { _future = _updateDetail(request: false); });
  }

  @override
  void initState() {
    _future = _updateDetail();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.offset > 1000 && !_showToTopBtn.value) {
        _showToTopBtn.value = true; // 显示返回至顶部按钮
      }
      else if (_controller.offset < 1000 && _showToTopBtn.value) {
        _showToTopBtn.value = false; // 不显示返回至顶部按钮
      }
    });
    _controller.addListener(() {
      if (_controller.offset > 0) {
        _showTopBarBg.value = true;
      }
      else{
        _showTopBarBg.value = false; // 不显示返回至顶部按钮
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _showTopBarBg.dispose();
    _showToTopBtn.dispose();
    _favBtnLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Detail?>(
      future: _future,
      builder: (context, snapshot) {
        return Material(
          child: Builder(builder: (context) {
            if (_isInInitialized || snapshot.connectionState == ConnectionState.done) { // 请求结束
              if (!snapshot.hasError && snapshot.data != null) { // 获得首批数据
                detail = snapshot.data!;
                _isInInitialized = true;
              }
              if (_isInInitialized) { // 展示内容
                return Stack(
                  children: [
                    NestedScrollView(
                      // 标题栏
                      headerSliverBuilder: (context, _) {
                        return [
                          SliverOverlapAbsorber(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                            sliver: ValueListenableBuilder(
                              valueListenable: _showTopBarBg,
                              builder: (context, showHeaderBg, _) {
                                return SliverAppBar( // 自适应透明标题栏
                                  title: showHeaderBg ? Text(detail.title) : null,
                                  pinned: true,
                                  backgroundColor: Colors.transparent,
                                  flexibleSpace: AnimatedOpacity(
                                    duration: Duration(milliseconds: 300),
                                    opacity: showHeaderBg ? 1 : 0,
                                    child: Container(color: Theme.of(context).colorScheme.secondaryContainer),
                                  ),
                                  systemOverlayStyle: SystemUiOverlayStyle(
                                    systemStatusBarContrastEnforced: false, // 禁用自动调整状态栏颜色
                                  ),
                                );
                              },
                            ),
                          ),
                        ];
                      },
                      body: RefreshIndicator( // 下拉刷新组件
                        onRefresh: _refreshDetail,
                        // 可滚动主要内容
                        child: CustomScrollView(
                          controller: _controller,
                          slivers: [
                            wBasicCard(), // 书籍基础信息
                            wPadding(),
                            wDescription(detail.description), // 书籍简介
                            wPadding(),
                            wTags(detail.tags), // 书籍标签
                            wPadding(),
                            wTotal(detail.contents.total), // 章节数
                            ChapterList( // 章节列表
                              bookId: detail.id,
                              lastWatched: detail.lastWatched,
                              contents: detail.contents,
                              onPressed: toReader,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align( // 浮动按钮控件
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          spacing: 12.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 返回顶部按钮
                            ValueListenableBuilder(
                              valueListenable: _showToTopBtn,
                              builder: (context, showToTopBtn, _) {
                                return showToTopBtn
                                    ? TooltipButton(
                                  onPressed: () {
                                    _controller.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.ease);
                                  },
                                  tooltip: "回到顶部",
                                  child: Icon(Icons.arrow_upward),
                                ) : SizedBox.shrink();
                              },
                            ),
                            // 收藏按钮
                            ValueListenableBuilder(
                              valueListenable: _favBtnLoading,
                              builder: (context, loading, _) {
                                return TooltipButton(
                                  onPressed: () async {
                                    if (!loading) {
                                      _favBtnLoading.value = true;
                                      int? result = await Esjzone().bookFavorite(detail.id);
                                      if (result != null) {
                                        detail = detail.copyWith(
                                          isFavorite: !detail.isFavorite,
                                          favorite: result,
                                        );
                                      }
                                      _favBtnLoading.value = false;
                                      setState(() => _future = _updateDetail(request: false));
                                    }
                                  },
                                  tooltip: detail.isFavorite ? "取消收藏" : "收藏",
                                  child: loading
                                      ? SizedBox.square(
                                    dimension: 20.0,
                                    child: CircularProgressIndicator(strokeWidth: 3.0),
                                  )
                                      : (Icon(detail.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border)
                                  ),
                                );
                              },
                            ),
                            // 评论按钮
                            if (detail.comments != null) TooltipButton(
                              onPressed: () {
                                showCommentList(context, detail.comments!);
                              },
                              tooltip: "书籍评论",
                              child: Icon(Icons.message),
                            ),
                            // 继续阅读按钮
                            if (detail.lastWatched != null && detail.lastWatched! >= 0) TooltipButton(
                              onPressed: () {
                                if (detail.lastWatched != null && detail.lastWatched! > -1) {
                                  toReader(bookId: detail.id, chapterId: detail.lastWatched!);
                                }
                              },
                              tooltip: "继续阅读",
                              child: Icon(Icons.play_arrow),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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

  // 组件间距封装
  Widget wPadding() {
    return SliverPadding(padding: const EdgeInsets.only(top: 20.0));
  }

  // 通用包装
  Widget sliverWidget({required Widget child}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: child,
      ),
    );
  }

  // 基础卡片 展示书籍基础信息
  Widget wBasicCard() {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          MaskImage( // 渐变背景图片
            imgSrc: detail.imgSrc,
            width: double.infinity,
            height: 200,
          ),
          Padding(
            padding: EdgeInsets.only( // 间距(空出标题栏高度)
              top: kToolbarHeight + MediaQuery.of(context).padding.top,
              left: 8.0,
              right: 8.0,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 书籍封面
                  Expanded(flex: 1,
                    child: HeroImagePage(
                      child: RatioImage(imgSrc: detail.imgSrc),
                    ),
                  ),
                  Expanded(flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          // 书籍标题
                          Expanded(flex: 6,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                detail.title,
                                maxLines: 4,
                                style: TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(flex: 1,
                            child: Row(
                              children: [
                                // 作者
                                Expanded(flex: 2,
                                  child: IconText(
                                    icon: Icons.create,
                                    text: detail.author,
                                    size: 18.0,
                                    ellipsis: true,
                                  ),
                                ),
                                // 标签
                                Expanded(flex: 1,
                                  child: IconText(
                                    icon: !detail.nsfw ? Icons.local_offer : Icons.eighteen_up_rating,
                                    text: detail.type,
                                    size: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(flex: 1,
                            child: Row(
                              children: [
                                // 阅读数
                                Expanded(flex: 1,
                                  child: IconText(
                                    icon: Icons.visibility,
                                    text: "${detail.views}",
                                    size: 18.0,
                                    fittedText: true,
                                  ),
                                ),
                                // 收藏数
                                Expanded(flex: 1,
                                  child: IconText(
                                    icon: Icons.favorite,
                                    text: "${detail.favorite}",
                                    size: 18.0,
                                    fittedText: true,
                                  ),
                                ),
                                // 字数
                                Expanded(flex: 1,
                                  child: IconText(
                                    icon: Icons.description,
                                    text: formatNumber(detail.words),
                                    size: 18.0,
                                    fittedText: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 简介组件
  Widget wDescription(CustomHtml description) {
    return sliverWidget(child: ExpandableText(html: description));
  }

  // 章节统计组件
  Widget wTotal(int total) {
    return sliverWidget(
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(
          "共 $total 章",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  // 标签组件
  Widget wTags(List<String> tags) {
    return sliverWidget(
      child: Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        children: tags.map((e) =>
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: StadiumBorder(), // 胶囊状
              ),
              child: Text(e, style: TextStyle(fontSize: 13.0, height: 1.0)),
            )
        ).toList(),
      ),
    );
  }
}
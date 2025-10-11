import 'package:html/dom.dart' hide Comment;
import 'package:html/parser.dart' as html_parser;
import 'package:flutter/material.dart' hide Element;
import '../common/network.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/page.dart';
import '../models/detail.dart';
import '../models/comment.dart';
import '../models/history.dart';
import '../models/contents.dart';
import '../models/favorite.dart';
import '../models/chapter_content.dart';
import '../widgets/network_image.dart';
import 'custom_html.dart';
import 'global.dart';
String _unknown = "<unknown>";

/// 解析 书籍列表Html 为 ListPage\<Book>
ListPage<Book> parseHTMLFormList(String htmlStr) {
  ListPage<Book> result = ListPage<Book>(dataList: []);

  Document document = html_parser.parse(htmlStr);
  List<Element> books = document.querySelectorAll(".offcanvas-wrapper .row .row>div");
  result.pageCount = _extractPageCount(document.querySelectorAll("script:not([src])").last.innerHtml);
  for (Element element in books) {
    if (Global.profile.showNSFW == false && element.querySelector(".product-badge") != null) continue; // 不展示R18时跳过
    List<Element> columns = element.querySelectorAll(".card-other>.column");
    (double, int) ratingData = _extractRating(columns[0].text);
    result.dataList.add(Book(
      id: _extractHref(element.querySelector(".card-title>a")?.attributes["href"]),
      title: (element.querySelector(".card-title")?.text ?? _unknown).trim(),
      author: (element.querySelector(".card-author")?.text ?? _unknown).trim(),
      latestChapter: element.querySelector(".card-ep")?.text ?? _unknown,
      rating: ratingData.$1,
      ratingCount: ratingData.$2,
      words: int.tryParse(columns[1].text.replaceAll(',', '')) ?? 0,
      views: int.tryParse(columns[2].text) ?? 0,
      favorite: int.tryParse(columns[3].text) ?? 0,
      articles: int.tryParse(columns[4].text) ?? 0,
      comments: int.tryParse(columns[5].text) ?? 0,
      imgSrc: _extractSrc(element.querySelector(".lazyload")?.attributes["data-src"]),
      nsfw: element.querySelector(".product-badge") != null,
    ));
  }
  return result;
}

/// 解析 收藏列表Html 为 ListPage\<Favorite>
ListPage<Favorite> parseHTMLFormFavorite(String htmlStr) {
  ListPage<Favorite> result = ListPage<Favorite>(dataList: []);

  Document document = html_parser.parse(htmlStr);
  List<Element> favorites = document.querySelectorAll(".table-responsive .product-info");
  result.pageCount = _extractPageCount(document.querySelectorAll("script:not([src])").last.innerHtml);
  for (Element element in favorites) {
    List<Element> latestItem = element.querySelectorAll(".book-ep>div");
    result.dataList.add(Favorite(
      id: _extractHref(element.querySelector(".product-title>a")?.attributes["href"]),
      title: (element.querySelector(".product-title")?.text ?? _unknown).trim(),
      latestChapter: _extractColon(latestItem[0].text) ?? _unknown,
      updateDate: _extractColon(element.querySelector(".book-update")?.text) ?? _unknown,
      lastWatched: _extractColon(latestItem[1].text),
    ));
  }
  return result;
}

/// 解析 历史列表Html 为 ListPage\<History>
ListPage<History> parseHTMLFormHistory(String htmlStr) {
  ListPage<History> result = ListPage<History>(dataList: []);

  Document document = html_parser.parse(htmlStr);
  List<Element> views = document.querySelectorAll(".table-responsive tr");
  result.pageCount = 1;
  for (Element element in views) {
    result.dataList.add(History(
      bookId: _extractHref(element.querySelector(".product-title>a")?.attributes["href"]),
      viewId: _extractLine(element.id),
      lastWatchedId: _extractHref(element.querySelector(".book-ep a")?.attributes["href"]),
      title: (element.querySelector(".product-title")?.text ?? _unknown).trim(),
      lastWatched: (element.querySelector(".book-ep a")?.text ?? _unknown).trim(),
    ));
  }
  return result;
}

/// 解析 评论列表Html 为 ListPage\<Comment>
List<Comment> parseHTMLFormComment(List<Element> comments) {
  List<Comment> result = [];

  for (Element element in comments) {
    List<Element> metas = element.querySelectorAll(".comment-header .text-right>span");
    result.add(Comment(
      id: _extractLine(element.id),
      number: int.tryParse(metas[0].text.substring(1, metas[0].text.length)) ?? -1,
      date: metas[1].text,
      commentator: Commentator(
        id: _extractUserId(element.querySelector(".comment-title>a")?.attributes["href"]),
        name: (element.querySelector(".comment-title")?.text ?? _unknown).trim(),
        profileSrc: _extractSrc(element.querySelector(".lazyload-author-ava")?.attributes["data-src"]),
      ),
      text: _extractCommentText(element.querySelector(".comment-text")),
      quote: element.querySelector("blockquote>p")?.text,
    ));
  }
  return result;
}

/// 解析 用户信息Html 为 User
User parseHTMLFormUser(String htmlStr) {
  User result;

  Document document = html_parser.parse(htmlStr);
  Element content = document.querySelector(".member-info")!;
  (String, int, int) levelInfo = _extractLevel(content.querySelector(".info-label")?.attributes["data-original-title"]);
  result = User(
    id: _extractUserId(content.querySelector(".url")?.text),
    name: (content.querySelector("h4")?.text ?? _unknown).trim(),
    profileSrc: _extractSrc(content.querySelector(".avatar-photo")?.attributes["src"]),
    level: levelInfo.$1,
    experience: levelInfo.$2,
    nextLevelExp: levelInfo.$3,
    regDate: _extractSpace(content.querySelector(".user-data>span")?.text) ?? _unknown,
  );
  return result;
}

/// 解析 书籍详情Html 为 Detail
Detail parseHTMLFormDetail(String htmlStr, int id) {
  Detail result;

  Document document = html_parser.parse(htmlStr);
  Element content = document.querySelector(".container>.row")!;
  List<Element> listItem = content.querySelectorAll("ul.book-detail li");
  List<Element> label = content.querySelectorAll(".book-detail label");
  result = Detail(
    id: id,
    title: (content.querySelector("h2")?.text ?? _unknown).trim(),
    type: _extractColon(listItem[0].text) ?? _unknown,
    author: content.querySelector("ul.book-detail li>a")?.text ?? _unknown,
    updateDate: _extractColon(listItem.last.text) ?? _unknown,
    rating: double.parse(content.querySelector(".text-center>div")?.text ?? "0"),
    words: int.tryParse(label[2].text.replaceAll(',', '')) ?? 0,
    views: int.tryParse(label[0].text) ?? 0,
    favorite: int.tryParse(label[1].text) ?? 0,
    imgSrc: _extractSrc(content.querySelector(".product-gallery img")?.attributes["src"]),
    nsfw: document.querySelector("#ticrf") != null,
    tags: (content.querySelector(".widget-tags")?.querySelectorAll("a") ?? []).map((e) => e.text.trim()).toList(),
    description: CustomHtml(data: content.querySelector(".description")?.innerHtml),
    contents: _extractContents(content.querySelector("#chapterList")),
    isFavorite: content.querySelector(".btn-favorite")?.text.trim() == "已收藏",
    lastWatched: _extractHref(content.querySelector("p.active")?.parent?.attributes["href"]),
    comments: document.querySelector("#comments") == null ? null
        : parseHTMLFormComment(document.querySelectorAll("#comments>.comment")),
  );
  return result;
}

/// 解析 章节内容Html 为 Html
ChapterContent parseHTMLFormChapter(String htmlStr, int id) {
  ChapterContent result;

  Document document = html_parser.parse(htmlStr);
  Element content = document.querySelector(".container>.row>div")!;
  List<Element> info = content.querySelectorAll(".single-post-meta .column");
  List<Element> contents = content.querySelector(".forum-content")?.children ?? [];
  result = ChapterContent(
    id: id,
    title: (content.querySelector("h2")?.text ?? _unknown).trim(),
    contents: contents.map((e) =>
      CustomHtml(data: e.innerHtml, fontSize: 18.0)
    ).toList(),
    author: (info[0].querySelector("a")?.text ?? _unknown).trim(),
    updateDate: info[1].text.trim(),
    like: int.tryParse(content.querySelector(".btn-likes")?.text ?? "0") ?? 0,
    words: int.tryParse(info[3].text.trim()) ?? 0,
    prevChapterId: _extractHref(content.querySelector(".btn-prev")?.attributes["href"]),
    nextChapterId: _extractHref(content.querySelector(".btn-next")?.attributes["href"]),
    isLike: content.querySelector(".btn-likes.btn-warning") != null,
    comments: document.querySelector("#comments") == null ? null
        : parseHTMLFormComment(document.querySelectorAll("#comments>.comment")),
  );

  return result;
}

/// 解析最大页码
int _extractPageCount(String script) {
  return int.parse(RegExp(r'total: (\d+),').firstMatch(script)?.group(1) ?? "0");
}

/// 解析 书籍id | 跳转链接
int _extractHref(String? href) {
  if (href == null || href.isEmpty) return -1;
  return int.parse(RegExp(r'/(\d*?)\.html').firstMatch(href)?.group(1) ?? "-1");
}

/// 解析[横线] 历史记录id | 评论id
int _extractLine(String str) {
  int index = str.indexOf(r'[_-]');
  if (index < 0) return -1;
  return int.parse(str.substring(index + 1, str.length));
}

/// 解析[等号] 用户id
int _extractUserId(String? str) {
  if (str == null) return -1;
  int index = str.indexOf('=');
  if (index < 0) return -1;
  return int.parse(str.substring(index + 1, str.length));
}

/// 解析[左括号] 书籍评分
(double, int) _extractRating(String str) {
  int index = str.indexOf('(');
  if (index < 0) return (0.0, 0);
  return (double.parse(str.substring(0, index)),
  int.parse(str.substring(index + 1, str.length - 1)));
}

/// 解析[冒号] 书籍类型 | 更新日期
String? _extractColon(String? str) {
  if (str == null || str.isEmpty) return null;
  int index = str.indexOf(RegExp(r'[：:]'));
  if (index < 0) return null;
  return str.substring(index + 1, str.length).trim();
}

/// 解析[空格] 注册日期
String? _extractSpace(String? str) {
  if (str == null || str.isEmpty) return null;
  int index = str.indexOf(RegExp(' '));
  if (index < 0) return null;
  return str.substring(index + 1, str.length).trim();
}

/// 解析图片路径
String _extractSrc(String? src) {
  if (src == null || src.isEmpty) return "";
  if (src.isNotEmpty && src[0] == '/') { // 相对路径
    return "${Esjzone.dio.options.baseUrl}$src";
  }
  else { // 绝对路径
    return src;
  }
}

/// 解析用户等级
(String, int, int) _extractLevel(String? str) {
  (String, int, int) errorResult = (_unknown, 0, 0);
  if (str == null || str.isEmpty) return errorResult;
  int colonIndex = str.indexOf('：');
  int slashIndex = str.indexOf('/');
  if (colonIndex < 0 || slashIndex < 0) return errorResult;
  return (
  str.substring(0, colonIndex),
  int.parse(str.substring(colonIndex + 1, slashIndex)),
  int.parse(str.substring(slashIndex + 1, str.length)));
}

/// 解析章节目录
Contents _extractContents(Element? contents) {
  int total = 0;
  Contents result = Contents(contents: []);
  SubContents tempOuter = SubContents(chapter: []); // 外层章节临时存储
  if (contents != null) {
    // 遍历子节点
    for (Element element in contents.children) {
      if (element.localName == "a") {
        // a 标签
        total++;
        tempOuter.chapter.add(Chapter(
          id: _extractHref(element.attributes["href"]),
          title: element.attributes["data-title"] ?? _unknown,
        ));
      }
      else if (element.localName == "details") {
        // 若 tempOuter 不为空
        if (tempOuter.chapter.isNotEmpty) {
          result.contents.add(tempOuter); // 添加 tempOuter 至 result 中
          tempOuter = SubContents(chapter: []); // 清空 tempOuter
        }

        // 内层章节临时存储
        SubContents tempInner = SubContents(
          contentsTitle: element.querySelector("summary")?.text.trim(),
          chapter: [],
        );

        // for 循环处理内层章节
        for (Element a in element.querySelectorAll("a")) {
          total++;
          tempInner.chapter.add(Chapter(
            id: _extractHref(a.attributes["href"]),
            title: a.attributes["data-title"] ?? _unknown,
          ));
        }

        result.contents.add(tempInner); // 添加 tempInner 至 result 中
      }
    }
  }
  result.total = total; // 更新总章节数
  if (tempOuter.chapter.isNotEmpty) result.contents.add(tempOuter);
  return result;
}

/// 解析评论
TextSpan _extractCommentText(Element? commentText) {
  List<InlineSpan> children = [];
  if (commentText != null) {
    for (Node node in commentText.nodes) {
      // 文本节点
      if (node.nodeType == Node.TEXT_NODE) {
        children.add(TextSpan(
          text: node.text,
        ));
      }
      // 元素节点
      else if (node.nodeType == Node.ELEMENT_NODE) {
        Element element = node as Element;
        if (element.localName == "span") {
          children.add(WidgetSpan(
            child: CustomNetImage(_extractCommentSrc(element.attributes["style"])),
          ));
        }
      }
    }
  }
  return TextSpan(children: children);
}

/// 解析评论图片
String _extractCommentSrc(String? style) {
  if (style == null) return "";
  return _extractSrc(RegExp(r'url\((.*?)\);').firstMatch(style)?.group(1));
}
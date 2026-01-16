import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import '../common/enum.dart';
import '../common/cookie.dart';
import '../common/global.dart';
import '../common/parse_html.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/page.dart';
import '../models/detail.dart';
import '../models/history.dart';
import '../models/favorite.dart';
import '../models/user_cookie.dart';
import '../models/like_response.dart';
import '../models/login_response.dart';
import '../models/chapter_content.dart';
import '../models/decrypt_response.dart';
import '../models/favorite_response.dart';

// 网络请求封装
class Esjzone {
  Esjzone([this.context]) {
    _options = Options(extra: {"context": context});
  }
  BuildContext? context;
  late Options _options;
  static Dio dio = Dio(BaseOptions(
    baseUrl: "https://www.esjzone.one",
    headers: {
      HttpHeaders.acceptHeader: "",
    },
    sendTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    connectTimeout: Duration(seconds: 30),
  ))..interceptors.add(InterceptorsWrapper(
    onResponse: (response, handler) { // 响应拦截器
      Map<String, String> cookie = cookieDecode(response.headers["set-cookie"] ?? []);
      if (cookie["ews_key"] != null && cookie["ews_token"] != null) {
        String ewsKey = cookie["ews_key"]!;
        String ewsToken = cookie["ews_token"]!;
        Global.profile = Global.profile.copyWith(
          userCookie: Optional.fromNullable(UserCookie(
            ewsKey: ewsKey,
            ewsToken: ewsToken,
          )),
        );
        dio.options.headers["Cookie"] = "ews_key=$ewsKey; ews_token=$ewsToken";
      }
      return handler.next(response);
    },
  ));

  static void init() {
    // 如果存有 userCookie 则获取并设置该 userCookie
    if (Global.profile.userCookie != null) {
      UserCookie userCookie = Global.profile.userCookie!;
      dio.options.headers["Cookie"] = "ews_key=${userCookie.ewsKey}; ews_token=${userCookie.ewsToken}";
    }
  }

  /// 获取 AuthToken
  Future<String?> getToken({required String path}) async {
    String? result;
    FormData formData = FormData.fromMap({
      "plxf": "getAuthToken"
    });
    try {
      var response = await dio.post(
        path,
        data: formData,
      );
      if (response.statusCode == 200) {
        result = RegExp(r'<JinJing>(.*?)</JinJing>').firstMatch(response.data)?.group(1);
      }
    }
    on DioException catch (_) {
      result = "超时";
    }
    return result;
  }

  /// 登录
  Future<(int, String?)> login({
    required String email,
    required String pwd,
    bool rememberMe = true,
  }) async {
    int statusCode = 0;
    String? message;

    String? token = await getToken(path: "/my/login"); // 获取 token
    if (token != null) {
      try {
        var response = await dio.post(
          "/inc/mem_login.php",
          options: Options(
            headers: {
              "Authorization": token,
            },
          ),
          data: FormData.fromMap({
            "email": email,
            "pwd": pwd,
            "remember_me": rememberMe ? "on" : null,
          }),
        );
        if (response.statusCode == 200) {
          LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(response.data));
          statusCode = loginResponse.status;
          message = loginResponse.msg;
        }
      }
      on DioException catch (_) {
        message = "超时";
      }
    }
    else { message = token; }
    return (statusCode, message);
  }

  /// 登出
  Future<void> logout() async {
    await dio.get("/my/logout");
    dio.options.headers.remove("Cookie");
  }

  /// 获取书籍列表
  Future<ListPage<Book>> bookList(BookType type, BookSort sort, int index) async {
    ListPage<Book> result = ListPage<Book>();
    try {
      var response = await dio.get(
        "/list-${type.code}${sort.code}/$index.html",
      );
      if (response.statusCode == 200) {
        result = parseHTMLFormList(response.data);
      }
    }
    on DioException catch (_) {}
    return result;
  }

  /// 搜索书籍
  Future<ListPage<Book>> bookSearch(String searchText, BookType type, BookSort sort, int index) async {
    ListPage<Book> result = ListPage<Book>();
    try {
      var response = await dio.get(
        "/tags-${type.code}${sort.code}/$searchText/$index.html",
      );
      if (response.statusCode == 200) {
        result = parseHTMLFormList(response.data);
      }
    }
    on DioException catch (_) {}
    return result;
  }

  /// 获取收藏列表
  Future<ListPage<Favorite>> favoriteList(FavoriteSort sort, int index) async {
    ListPage<Favorite> result = ListPage<Favorite>();
    try {
      var response = await dio.get(
        "/my/favorite/${sort.code}/$index",
      );
      if (response.statusCode == 200) {
        result = parseHTMLFormFavorite(response.data);
      }
    }
    on DioException catch (_) {}
    return result;
  }

  /// 获取观看记录(仅一页)
  Future<ListPage<History>> historyList() async {
    ListPage<History> result = ListPage<History>();
    try {
      var response = await dio.get(
        "/my/view",
      );
      if (response.statusCode == 200) {
        result = parseHTMLFormHistory(response.data);
      }
    }
    on DioException catch (_) {}
    return result;
  }

  /// 获取用户信息
  Future<User?> userInfo([int? id]) async {
    User? result;
    try {
      var response = await dio.get(
        (id == null)
            ? "/my/profile.html"
            : "/my/profile.html?uid=$id",
      );
      if (response.statusCode == 200) {
        result = parseHTMLFormUser(response.data);
      }
    }
    on DioException catch (_) {}
    return result;
  }

  /// 获取书籍详情
  Future<Detail?> bookDetail(int id) async {
    Detail? result;
    try {
      var response = await dio.get(
        "/detail/$id.html",
      );
      if (response.statusCode == 200) {
        result = parseHTMLFormDetail(response.data, id);
      }
    }
    on DioException catch (_) {}
    return result;
  }

  /// 获取章节内容
  Future<ChapterContent?> chapterContent(int bookId, int chapterId) async {
    ChapterContent? result;
    try {
      var response = await dio.get(
        "/forum/$bookId/$chapterId.html",
      );
      if (response.statusCode == 200) {
        result = parseHTMLFormChapter(response.data, chapterId);
      }
    }
    on DioException catch (_) {}
    return result;
  }

  /// 收藏书籍
  Future<int?> bookFavorite(int bookId) async {
    int? result;

    String? token = await getToken(path: "/detail/$bookId"); // 获取 token
    if (token != null) {
      try {
        var response = await dio.post(
          "/inc/mem_favorite.php",
          options: Options(
            headers: {
              "Authorization": token,
            },
          ),
        );
        if (response.statusCode == 200) {
          FavoriteResponse favorite = FavoriteResponse.fromJson(jsonDecode(response.data));

          // 收藏成功
          if (favorite.status == 200) {
            result = favorite.favorite;
          }
        }
      }
      on DioException catch (_) {}
    }
    return result;
  }

  /// 点赞章节
  Future<int?> chapterLike(int bookId, int chapterId) async {
    int? result;

    String? token = await getToken(path: "/forum/$bookId/$chapterId.html"); // 获取 token
    if (token != null) {
      try {
        var response = await dio.post(
          "/inc/forum_likes.php",
          options: Options(
            headers: {
              "Authorization": token,
            },
          ),
          data: FormData.fromMap({
            "code": bookId,
            "id": chapterId,
          }),
        );
        if (response.statusCode == 200) {
          LikeResponse like = LikeResponse.fromJson(jsonDecode(response.data));

          // 点赞成功
          if (like.status == 200) {
            result = like.likes;
          }
        }
      }
      on DioException catch (_) {}
    }
    return result;
  }

  /// 解密章节
  Future<(String, int)> chapterDecrypt(int bookId, int chapterId, String password) async {
    String html = ""; // 章节内容或报错信息
    int text = -1; // 章节字数

    html = "该功能开发中！\n前往网页解锁章节后即可在软件内正常阅读";

    return (html, text);
  }
}
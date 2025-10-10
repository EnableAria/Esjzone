enum BookType {
  all(0, "全部"),
  japan(1, "日轻"),
  original(2, "原创"),
  korea(3, "韩轻");

  final int code;
  final String description;

  const BookType(this.code, this.description);
}

enum BookSort {
  latestUpdate(1, "最新更新"),
  latestRelease(2, "最新上架"),
  highestRating(3, "最高评分"),
  mostViews(4, "最多观看"),
  mostArticles(5, "最多文章"),
  mostDiscussions(6, "最多讨论"),
  mostFavorites(7, "最多收藏"),
  mostWords(8, "最多字数");

  final int code;
  final String description;

  const BookSort(this.code, this.description);
}

enum FavoriteSort {
  latestFavorite("new", "最新收藏"),
  latestUpdate("udate", "最新更新");

  final String code;
  final String description;

  const FavoriteSort(this.code, this.description);
}
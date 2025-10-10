class User {
  User({
    required this.id,
    required this.name,
    required this.profileSrc,
    required this.level,
    required this.experience,
    required this.nextLevelExp,
    required this.regDate,
  });
  final int id; // 用户id
  final String name; // 用户昵称
  final String profileSrc; // 用户头像
  final String level; // 用户等级
  final int experience; // 当前经验
  final int nextLevelExp; // 下一级所需经验
  final String regDate; // 注册日期
}
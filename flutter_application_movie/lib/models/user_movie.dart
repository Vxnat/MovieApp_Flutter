class UserMovie {
  UserMovie({
    required this.avatar,
    required this.id,
    required this.email,
    required this.name,
    required this.dateJoin,
    required this.password,
  });
  late final String avatar;
  late final String id;
  late final String email;
  late final String name;
  late final String dateJoin;
  late final String password;

  UserMovie.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    name = json['name'] ?? '';
    dateJoin = json['date_join'] ?? '';
    password = json['password'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['date_join'] = dateJoin;
    data['password'] = password;
    return data;
  }
}

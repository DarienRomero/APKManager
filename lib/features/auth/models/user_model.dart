
class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.enabled,
    required this.appsEnabled,
  });

  final String id;
  final String email;
  final String username;
  final bool enabled;
  final List<String> appsEnabled;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? "",
    email: json["email"] ?? "",
    username: json["username"] ?? "",
    enabled: json["enabled"] ?? false,
    appsEnabled: json["apps_enabled"] != null ? List<String>.from(json["apps_enabled"]) : []
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "enabled": enabled,
    "apps_enabled": appsEnabled
  };


  static UserModel get empty => UserModel(
    id: "",
    email: "",
    username: "",
    enabled: false,
    appsEnabled: []
  );
  
  UserModel copyWith ({
    String? id,
    String? email,
    String? username,
    bool? enabled,
    List<String>? appsEnabled
  }) => UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
    username: username ?? this.username,
    enabled: enabled ?? this.enabled,
    appsEnabled: appsEnabled ?? this.appsEnabled,
  );
}

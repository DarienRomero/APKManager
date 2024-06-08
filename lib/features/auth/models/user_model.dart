
class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.enabled,
    required this.appsEnabled,
    required this.isAdmin,
    required this.company
  });

  final String id;
  final String email;
  final String username;
  final bool enabled;
  final List<String> appsEnabled;
  final bool isAdmin;
  final String company;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? "",
    email: json["email"] ?? "",
    username: json["username"] ?? "",
    enabled: json["enabled"] ?? false,
    appsEnabled: json["apps_enabled"] != null ? List<String>.from(json["apps_enabled"]) : [],
    isAdmin: json["is_admin"] ?? false,
    company: json["company"] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "enabled": enabled,
    "apps_enabled": appsEnabled,
    "is_admin": isAdmin,
    "company": company,
  };


  static UserModel get empty => UserModel(
    id: "",
    email: "",
    username: "",
    enabled: false,
    appsEnabled: [],
    isAdmin: false,
    company: ""
  );
  
  UserModel copyWith ({
    String? id,
    String? email,
    String? username,
    bool? enabled,
    List<String>? appsEnabled,
    bool? isAdmin,
    String? company
  }) => UserModel(
    id: id ?? this.id,
    email: email ?? this.email,
    username: username ?? this.username,
    enabled: enabled ?? this.enabled,
    appsEnabled: appsEnabled ?? this.appsEnabled,
    isAdmin: isAdmin ?? this.isAdmin,
    company: company ?? this.company
  );
}

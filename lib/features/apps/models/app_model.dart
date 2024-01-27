class AppModel {
  final String id;
  final String lastVersionLink;
  final int lastVersionNumber;
  final String lastVersionString;
  final String logo;
  final String name;
  final String packageName;
  final DateTime? updatedAt;

  AppModel({
    required this.id,
    required this.lastVersionLink,
    required this.lastVersionNumber,
    required this.lastVersionString,
    required this.logo,
    required this.name,
    required this.packageName,
    required this.updatedAt,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) => AppModel(
    id: json["id"] ?? "",
    lastVersionLink: json["last_version_link"] ?? "",
    lastVersionNumber: json["last_version_number"] ?? -1,
    lastVersionString: json["last_version_string"] ?? "",
    logo: json["logo"] ?? "",
    name: json["name"] ?? "",
    packageName: json["package_name"] ?? "",
    updatedAt: json["updated_at"]?.toDate()
  );
}
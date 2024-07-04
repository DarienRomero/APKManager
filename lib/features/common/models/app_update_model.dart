AppUpdateModel appUpdateModelFromJson(dynamic json) => AppUpdateModel.fromJson(json);

class AppUpdateModel {
  final int versionNumber;
  final String title;
  final String description;
  final bool forced;

  AppUpdateModel({
    required this.versionNumber,
    required this.title,
    required this.description,
    required this.forced,
  });

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) => AppUpdateModel(
    versionNumber: json["version_number"] ?? 0,
    title: json["title"] ?? "",
    description: json["description"] ?? "",
    forced: json["forced"] ?? false,
  );
  Map<String, dynamic> toJson() => {
    "version_number": versionNumber,
    "title": title,
    "description": description,
    "forced": forced,
  };

  static AppUpdateModel get empty => AppUpdateModel(
    versionNumber: 0,
    title: "",
    description: "",
    forced: false,
  );

  AppUpdateModel copyWith({
    int? versionNumber,
    String? title,
    String? description,
    bool? forced,
  }) => AppUpdateModel(
    versionNumber: versionNumber?? this.versionNumber,
    title: title?? this.title,
    description: description?? this.description,
    forced: forced?? this.forced,
  );
}

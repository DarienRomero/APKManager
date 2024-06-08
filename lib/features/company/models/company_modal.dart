class CompanyModel {
  final String id;
  final String name;
  final bool enabled;

  CompanyModel({
    required this.id,
    required this.name,
    required this.enabled,
  });

  static get empty => CompanyModel(
    id: "",
    name: "",
    enabled: false,
  );

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    enabled: json["enabled"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "enabled": enabled,
  };
}
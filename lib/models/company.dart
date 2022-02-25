class Company {
  final int id;
  final String country;
  final String name;
  final String logo;

  Company(this.id, this.country, this.name, this.logo);

  Company.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        logo = json["logo_path"] ?? "",
        name = json["name"],
        country = json["origin_country"];
}

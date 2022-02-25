class Video {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;

  const Video(this.id, this.key, this.name, this.site, this.type);
  Video.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        site = json["site"],
        key = json["key"],
        type = json["type"];
}

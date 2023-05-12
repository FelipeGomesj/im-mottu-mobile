class Character {
  Character({
    this.id,
    this.name,
    this.description,
    this.thumbnailUrl,
    this.thumbnailPath,
  });

  int? id;
  String? name;
  String? description;
  String? thumbnailUrl;
  String? thumbnailPath;

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnailUrl: json['thumbnail']['path'] + '.' + json['thumbnail']['extension'],
      thumbnailPath: '${json['thumbnail']['path']}/portrait_uncanny.${json['thumbnail']['extension']}',
    );
  }
}


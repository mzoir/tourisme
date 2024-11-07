class Video {
  final String name;
  final String url;
  final String description;

  Video({required this.name, required this.url, required this.description});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['name'],
      url: json['url'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'description': description,
    };
  }
}

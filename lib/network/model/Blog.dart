class Blog {
  final String id;
  final String? imageUrl;
  final String? description;
  final String? title;
  final String createdBy;
  final String createdAt;

  Blog(
      {required this.id,
      required this.imageUrl,
      required this.description,
      required this.title,
      required this.createdBy,
      required this.createdAt});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
        id: json['id'],
        imageUrl: json['imageUrl'],
        description: json['description'],
        title: json['title'],
        createdBy: json['createdBy'],
        createdAt: json['createdAt']);
  }
}

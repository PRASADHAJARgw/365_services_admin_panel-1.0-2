class SectionImageModel {
  String? id;
  String name;
  String? imageUrl;
  DateTime? createdAt;

  SectionImageModel({
    this.id,
    this.imageUrl,
    this.createdAt,
    required this.name,
  });

  factory SectionImageModel.fromMap(Map<String, dynamic> map) {
    return SectionImageModel(
      id: map['id'],
      name: map['name'] ?? '',
      createdAt: map['createdAt'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
    };
  }
}

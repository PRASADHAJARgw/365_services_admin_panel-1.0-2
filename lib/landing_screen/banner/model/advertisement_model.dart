class AdvertisementModel {
  String? id;
  String name;
  String? imageUrl;
  DateTime? createdAt;

  AdvertisementModel({
    this.id,
    this.imageUrl,
    this.createdAt,
    required this.name,
  });

  factory AdvertisementModel.fromMap(Map<String, dynamic> map) {
    return AdvertisementModel(
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

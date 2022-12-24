class ServiceModel {
  String? id;
  String? imageUrl;
  String serviceName;
  ServiceModel({
    this.id,
    this.imageUrl,
    required this.serviceName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'serviceName': serviceName,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      imageUrl: map['imageUrl'],
      serviceName: map['serviceName'] ?? '',
    );
  }
}

class ServiceCheckListModel {
  final ServiceModel service;
  bool isChecked;
  ServiceCheckListModel({
    required this.service,
    this.isChecked = false,
  });
}

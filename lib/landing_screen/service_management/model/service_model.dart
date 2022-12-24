class ServiceModel {
  String? id;
  String? imageUrl;
  String serviceName;
  String servicePrice1;
  ServiceModel({
    this.id,
    this.imageUrl,
    required this.serviceName,
    required this.servicePrice1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'serviceName': serviceName,
      'servicePrice': servicePrice1,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      imageUrl: map['imageUrl'],
      serviceName: map['serviceName'] ?? '',
      servicePrice1: map['servicePrice1'] ?? '',
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

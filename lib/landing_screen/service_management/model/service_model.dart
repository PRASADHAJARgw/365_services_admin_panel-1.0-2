class ServiceModel {
  String? id;
  String? imageUrl;
  String serviceName;
  String servicePrice1;
  String servicePrice2;
  String servicePrice3;
  String servicePrice4;
  String servicePrice5;
  String servicePrice6;
  String servicePrice7;
  String servicePrice8;
  String servicePrice9;
  String servicePrice10;

  ServiceModel({
    this.id,
    this.imageUrl,
    required this.serviceName,
    required this.servicePrice1,
    required this.servicePrice2,
    required this.servicePrice3,
    required this.servicePrice4,
    required this.servicePrice5,
    required this.servicePrice6,
    required this.servicePrice7,
    required this.servicePrice8,
    required this.servicePrice9,
    required this.servicePrice10,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'serviceName': serviceName,
      'servicePrice1': servicePrice1,
      'servicePrice2': servicePrice2,
      'servicePrice3': servicePrice3,
      'servicePrice4': servicePrice4,
      'servicePrice5': servicePrice5,
      'servicePrice6': servicePrice6,
      'servicePrice7': servicePrice7,
      'servicePrice8': servicePrice8,
      'servicePrice9': servicePrice9,
      'servicePrice10': servicePrice10,

    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      imageUrl: map['imageUrl'],
      serviceName: map['serviceName'] ?? '',
      servicePrice1: map['servicePrice1'] ?? '',
      servicePrice2: map['servicePrice2'] ?? '',
      servicePrice3: map['servicePrice3'] ?? '',
      servicePrice4: map['servicePrice4'] ?? '',
      servicePrice5: map['servicePrice5'] ?? '',
      servicePrice6: map['servicePrice6'] ?? '',
      servicePrice7: map['servicePrice7'] ?? '',
      servicePrice8: map['servicePrice8'] ?? '',
      servicePrice9: map['servicePrice9'] ?? '',
      servicePrice10: map['servicePrice10'] ?? '',

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

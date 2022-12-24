import 'package:service365_admin_panel/landing_screen/service_management/model/service_model.dart';

class CityModel {
  final String? id;
  String cityName;
  final List<ServiceModel> availableServices;
  CityModel({
    this.id,
    required this.cityName,
    required this.availableServices,
  });

  Map<String, dynamic> toMap({required String cityId}) {
    return {
      'id': cityId,
      'cityName': cityName,
      'availableServices': availableServices.map((x) => x.toMap()).toList(),
    };
  }

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'],
      cityName: map['cityName'] ?? '',
      availableServices: List<ServiceModel>.from(
          map['availableServices']?.map((x) => ServiceModel.fromMap(x)) ??
              const []),
    );
  }
}

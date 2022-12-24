import 'package:service365_admin_panel/landing_screen/customer/model/address_model.dart';

class UserModel {
  String uid;
  String? name;
  String? profileImageUrl;
  final String phone;
  List<AddressModel>? addressList;

  UserModel({
    required this.uid,
    this.name,
    this.profileImageUrl,
    required this.phone,
    this.addressList,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'phone': phone,
      'addressList': addressList?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'],
      profileImageUrl: map['profileImageUrl'],
      phone: map['phone'] ?? '',
      addressList: List<AddressModel>.from(
        map['userAddressList']?.map((x) => AddressModel.fromMap(x)) ?? const [],
      ),
    );
  }
  factory UserModel.fromJson(dynamic source) => UserModel.fromMap(source);
}

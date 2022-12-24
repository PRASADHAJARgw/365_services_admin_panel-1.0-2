class AddressModel {
  String? city;
  String? name;
  String? phoneNumber;
  String? address;
  String? landmark;
  String? state;
  String? pinCode;
  String? country;
  AddressModel({
    this.city,
    this.name,
    this.phoneNumber,
    this.address,
    this.landmark,
    this.state,
    this.pinCode,
    this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'landmark': landmark,
      'state': state,
      'pinCode': pinCode,
      'country': country,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      city: map['city'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      landmark: map['landmark'],
      state: map['state'],
      pinCode: map['pinCode'],
      country: map['country'],
    );
  }
}

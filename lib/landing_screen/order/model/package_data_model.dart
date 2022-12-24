class PackageDetailsModel {
  final String packageId;
  final String packagePrice;
  final String packageImage;
  final String packageName;
  final String packageStars;
  final String packageTotalRatings;
  bool isAddedToCart;

  PackageDetailsModel({
    required this.packageId,
    required this.packagePrice,
    required this.packageImage,
    required this.packageName,
    required this.packageStars,
    required this.packageTotalRatings,
    this.isAddedToCart = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'packageId': packageId,
      'packagePrice': packagePrice,
      'packageImage': packageImage,
      'packageName': packageName,
      'packageStars': packageStars,
      'packageTotalRatings': packageTotalRatings,
    };
  }

  factory PackageDetailsModel.fromMap(Map<String, dynamic> map) {
    return PackageDetailsModel(
      packageId: map['packageId'] ?? '',
      packagePrice: map['packagePrice'] ?? '',
      packageImage: map['packageImage'] ?? '',
      packageName: map['packageName'] ?? '',
      packageStars: map['packageStars'] ?? '',
      packageTotalRatings: map['packageTotalRatings'] ?? '',
    );
  }
}

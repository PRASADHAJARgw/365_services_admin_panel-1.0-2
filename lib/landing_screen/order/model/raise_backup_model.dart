class RaisedBackupModel {
  final String selectedDate;
  final String description;
  RaisedBackupModel({
    required this.selectedDate,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'selectedDate': selectedDate,
      'description': description,
    };
  }

  factory RaisedBackupModel.fromMap(Map<String, dynamic> map) {
    return RaisedBackupModel(
      selectedDate: map['selectedDate'],
      description: map['description'],
    );
  }
}

class DocumentModel {
  String? documentName;
  String? documentUrl;
  DocumentModel({
    this.documentName,
    this.documentUrl,
  });

  Map<String, dynamic> toMap({String? documentUrl}) {
    return {
      'documentName': documentName,
      'documentUrl': documentUrl,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      documentName: map['documentName'] ?? '',
      documentUrl: map['documentUrl'] ?? '',
    );
  }
}

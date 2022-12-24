class InvoiceModel {
  String? invoiceName;
  String? invoiceUrl;
  bool? isInvoiceAvailable;
  InvoiceModel({
    this.invoiceName,
    this.invoiceUrl,
    this.isInvoiceAvailable,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceName': invoiceName,
      'invoiceUrl': invoiceUrl,
      'isInvoiceAvailable': isInvoiceAvailable,
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) => InvoiceModel(
        invoiceName: map['invoiceName'] ?? '',
        invoiceUrl: map['invoiceUrl'] ?? '',
        isInvoiceAvailable: map['isInvoiceAvailable'] ?? false,
      );
}

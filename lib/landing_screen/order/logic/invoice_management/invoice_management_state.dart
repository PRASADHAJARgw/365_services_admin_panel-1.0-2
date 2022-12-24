part of 'invoice_management_cubit.dart';

abstract class InvoiceManagementState extends Equatable {
  const InvoiceManagementState();

  @override
  List<Object> get props => [];
}

class InvoiceManagementInitial extends InvoiceManagementState {}

class InvoiceUploading extends InvoiceManagementState {
  final int orderIndex;
  const InvoiceUploading({required this.orderIndex});
}

class InvoicePicked extends InvoiceManagementState {
  final PickedDocumentModel pickedInvoice;
  final int orderIndex;
  const InvoicePicked({
    required this.orderIndex,
    required this.pickedInvoice,
  });
}

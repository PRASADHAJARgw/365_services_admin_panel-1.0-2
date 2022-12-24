import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service365_admin_panel/landing_screen/order/model/order_model.dart';
import 'package:service365_admin_panel/landing_screen/order/repository/order_management_repository.dart';
import 'package:service365_admin_panel/utility/document_picker.dart';
import 'package:service365_admin_panel/utility/show_snak_bar.dart';
part 'invoice_management_state.dart';

class InvoiceManagementCubit extends Cubit<InvoiceManagementState> {
  InvoiceManagementCubit() : super(InvoiceManagementInitial());

  Future<void> pickInvoice(
      {required BuildContext context, required int orderIndex}) async {
    try {
      final _invoice = await PickDocument().pickDocument();
      if (_invoice.selectedFile == null) {
        emit(InvoiceManagementInitial());
        ShowSnackBar.showSnackBar(context, 'No file selected');
      } else {
        emit(InvoiceManagementInitial());
        emit(InvoicePicked(
          pickedInvoice: _invoice,
          orderIndex: orderIndex,
        ));
      }
      return;
    } catch (error) {
      emit(InvoiceManagementInitial());
      if (error is PlatformException) {
        ShowSnackBar.showSnackBar(context, error.message ?? '');
      } else {
        ShowSnackBar.showSnackBar(context, error.toString());
      }
    }
  }

  Future<void> uploadInvoice({
    required BuildContext context,
    required PickedDocumentModel pickedInvoice,
    required OrderModel orderModel,
    required int orderIndex,
  }) async {
    try {
      emit(InvoiceUploading(orderIndex: orderIndex));
      await OrderManagementRepository().uploadInvoice(
        pickedInvoice: pickedInvoice,
        orderModel: orderModel,
      );
      emit(InvoiceManagementInitial());
      return;
    } catch (error) {
      emit(InvoiceManagementInitial());
      if (error is PlatformException) {
        ShowSnackBar.showSnackBar(context, error.message ?? '');
      } else {
        ShowSnackBar.showSnackBar(context, error.toString());
      }
      return;
    }
  }

  Future<void> resetDocs() async {
    emit(InvoiceManagementInitial());
  }
}

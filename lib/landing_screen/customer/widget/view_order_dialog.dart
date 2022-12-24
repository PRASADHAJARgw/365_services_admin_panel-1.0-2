import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/landing_screen/customer/logic/fetch_customer_data/fetchcustomerdata_cubit.dart';
import 'package:service365_admin_panel/landing_screen/order/model/order_model.dart';
import 'package:service365_admin_panel/landing_screen/order/widgets/order_details_card.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';

class ViewOrderDialogWidget extends StatelessWidget {
  final String uid;
  const ViewOrderDialogWidget({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textStyle = GoogleFonts.poppins(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
      ),
    );
    return StreamBuilder<List<OrderModel?>>(
        stream: BlocProvider.of<FetchcustomerdataCubit>(context)
            .fetchCustomerOrdersLog(uid: uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 60.h,
              width: 60.w,
              child: const Center(
                child: SpinLoadingIndicator(),
              ),
            );
          } else {
            final _logs = snapshot.data ?? [];

            if (_logs.isEmpty) {
              return Text(
                'No order available!',
                textAlign: TextAlign.center,
                style: _textStyle,
              );
            } else {
              return Container(
                color: Colors.black,
                child: SizedBox(
                  height: 500.h,
                  width: 500.w,
                  child: ListView.builder(
                      controller: ScrollController(),
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        return OrderDetailsCard(
                          allowChangeStatus: false,
                          orderModel: _logs[index]!,
                          orderIndex: index,
                        );
                      }),
                ),
              );
            }
          }
        });
  }
}

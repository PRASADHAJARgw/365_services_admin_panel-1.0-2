import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/header.dart';
import 'package:service365_admin_panel/landing_screen/order/logic/fetch_order/fetchorder_cubit.dart';
import 'package:service365_admin_panel/landing_screen/order/model/order_model.dart';
import 'package:service365_admin_panel/landing_screen/order/widgets/order_details_card.dart';
import 'package:service365_admin_panel/tools/responsive_handler.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';

class OrderManagementWidget extends StatelessWidget {
  const OrderManagementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: Column(children: const [
        RaisedBackupOrder(),
        PendingOrder(),
        PaidOrder(),
        OnHoldOrder(),
        CancelledOrder(),
      ]),
      desktop: Column(
        children: [
          const RaisedBackupOrder(),
          Row(
            children: const [
              Spacer(),
              PendingOrder(),
              PaidOrder(),
              Spacer(),
            ],
          ),
          Row(
            children: const [
              Spacer(),
              OnHoldOrder(),
              CancelledOrder(),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class PendingOrder extends StatelessWidget {
  const PendingOrder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: OrderContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            children: [
              const Header(
                title: 'PENDING ORDER',
              ),
              StreamBuilder<List<OrderModel?>>(
                stream: BlocProvider.of<FetchorderCubit>(context)
                    .fetchPendingOrder(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const OrderLoadingSpinner();
                  } else {
                    final _logs = snapshot.data ?? [];
                    if (_logs.isEmpty) {
                      return const NoOrderAvailable();
                    } else {
                      return LogBuilder(logs: _logs);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaidOrder extends StatelessWidget {
  const PaidOrder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: OrderContainer(
        child: Column(
          children: [
            const Header(
              title: 'PAID ORDER',
            ),
            StreamBuilder<List<OrderModel?>>(
              stream:
                  BlocProvider.of<FetchorderCubit>(context).fetchPaidOrder(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const OrderLoadingSpinner();
                } else {
                  final _logs = snapshot.data ?? [];

                  if (_logs.isEmpty) {
                    return const NoOrderAvailable();
                  } else {
                    return LogBuilder(logs: _logs);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OnHoldOrder extends StatelessWidget {
  const OnHoldOrder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: OrderContainer(
        child: Column(
          children: [
            const Header(
              title: 'ON HOLD ORDER',
            ),
            StreamBuilder<List<OrderModel?>>(
              stream:
                  BlocProvider.of<FetchorderCubit>(context).fetchOnHoldOrder(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const OrderLoadingSpinner();
                } else {
                  final _logs = snapshot.data ?? [];
                  if (_logs.isEmpty) {
                    return const NoOrderAvailable();
                  } else {
                    return LogBuilder(logs: _logs);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CancelledOrder extends StatelessWidget {
  const CancelledOrder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: OrderContainer(
        child: Column(
          children: [
            const Header(
              title: 'CANCELLED ORDER',
            ),
            StreamBuilder<List<OrderModel?>>(
              stream: BlocProvider.of<FetchorderCubit>(context)
                  .fetchCancelledOrder(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const OrderLoadingSpinner();
                } else {
                  final _logs = snapshot.data ?? [];
                  if (_logs.isEmpty) {
                    return const NoOrderAvailable();
                  } else {
                    return LogBuilder(logs: _logs);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RaisedBackupOrder extends StatelessWidget {
  const RaisedBackupOrder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: OrderContainer(
        child: Column(
          children: [
            const Header(
              title: 'RAISED BACKUP ORDER',
            ),
            StreamBuilder<List<OrderModel?>>(
              stream: BlocProvider.of<FetchorderCubit>(context)
                  .fetchRaisedBackupOrder(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const OrderLoadingSpinner();
                } else {
                  final _logs = snapshot.data ?? [];
                  if (_logs.isEmpty) {
                    return const NoOrderAvailable();
                  } else {
                    return LogBuilder(logs: _logs);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderLoadingSpinner extends StatelessWidget {
  const OrderLoadingSpinner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: SpinLoadingIndicator(),
      ),
    );
  }
}

class NoOrderAvailable extends StatelessWidget {
  const NoOrderAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          'No order available!',
          style: TextStyle(
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}

class OrderContainer extends StatelessWidget {
  final Widget child;
  const OrderContainer({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      width: 500.w,
      height: 500.h,
      child: child,
    );
  }
}

class LogBuilder extends StatelessWidget {
  const LogBuilder({
    Key? key,
    required List<OrderModel?> logs,
  })  : _logs = logs,
        super(key: key);

  final List<OrderModel?> _logs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          controller: ScrollController(),
          itemCount: _logs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: OrderDetailsCard(
                orderModel: _logs[index]!,
                orderIndex: index,
              ),
            );
          }),
    );
  }
}

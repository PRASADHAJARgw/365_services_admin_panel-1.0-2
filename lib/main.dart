import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/authentication/logic/authentication/authentication_bloc.dart';
import 'package:service365_admin_panel/authentication/logic/login/login_bloc.dart';
import 'package:service365_admin_panel/authentication/screen/authscreen.dart';
import 'package:service365_admin_panel/config/routes/application_page_routes.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/firebase_options.dart';
import 'package:service365_admin_panel/landing_screen/banner/logic/banner_image_picker/banner_image_picker_cubit.dart';
import 'package:service365_admin_panel/landing_screen/banner/logic/bannermanagement/bannermanagement_cubit.dart';
import 'package:service365_admin_panel/landing_screen/customer/logic/fetch_customer_data/fetchcustomerdata_cubit.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/logic/dash_board_management/dashboardmanagement_bloc.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/logic/fetch_dashboard_data/fetchdashboarddata_cubit.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/screens/dashboard_screen.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/TermsAndCondiiton/termsandcondition_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/document_manager/documentmanager_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/pick_aboutus_document/pickaboutusdocument_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/pick_privacypolicy/pickprivacypolicy_cubit.dart';
import 'package:service365_admin_panel/landing_screen/order/logic/fetch_order/fetchorder_cubit.dart';
import 'package:service365_admin_panel/landing_screen/order/logic/invoice_management/invoice_management_cubit.dart';
import 'package:service365_admin_panel/landing_screen/order/logic/order_management/ordermanagement_cubit.dart';
import 'package:service365_admin_panel/landing_screen/section/logic/section_image_management/section_image_management_cubit.dart';
import 'package:service365_admin_panel/landing_screen/section/logic/section_image_picker/section_imagepicker_cubit.dart';
import 'package:service365_admin_panel/landing_screen/section/logic/section_management/section_management_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/city_manager/city_manager_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/pick_service_image/pick_service_image_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/service_manager/service_cubit.dart';
import 'package:service365_admin_panel/utility/loading_screen.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'abcdefghijklmnopqrstuvwxy-1234567890abcd',
  );
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authenticationBloc = AuthenticationBloc();

  @override
  void initState() {
    _authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authenticationBloc),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          ),
        ),
        BlocProvider<DashboardmanagementBloc>(
          create: (context) => DashboardmanagementBloc(),
        ),
        BlocProvider<ServiceCubit>(
          create: (context) => ServiceCubit(),
        ),
        BlocProvider<CityManagerCubit>(
          create: (context) => CityManagerCubit(),
        ),
        BlocProvider<PickServiceImageCubit>(
          create: (context) => PickServiceImageCubit(),
        ),
        BlocProvider<BannerManagementCubit>(
          create: (context) => BannerManagementCubit(),
        ),
        BlocProvider<BannerImagePickerCubit>(
          create: (context) => BannerImagePickerCubit(),
        ),
        BlocProvider<FetchorderCubit>(
          create: (context) => FetchorderCubit(),
        ),
        BlocProvider<OrdermanagementCubit>(
          create: (context) => OrdermanagementCubit(),
        ),
        BlocProvider<FetchdashboarddataCubit>(
          create: (context) => FetchdashboarddataCubit(),
        ),
        BlocProvider<DocumentmanagerCubit>(
          create: (context) => DocumentmanagerCubit(),
        ),
        BlocProvider<PickaboutusdocumentCubit>(
          create: (context) => PickaboutusdocumentCubit(),
        ),
        BlocProvider<PickprivacypolicyCubit>(
          create: (context) => PickprivacypolicyCubit(),
        ),
        BlocProvider<TermsandconditionCubit>(
          create: (context) => TermsandconditionCubit(),
        ),
        BlocProvider<FetchcustomerdataCubit>(
          create: (context) => FetchcustomerdataCubit(),
        ),
        BlocProvider<InvoiceManagementCubit>(
          create: (context) => InvoiceManagementCubit(),
        ),
        BlocProvider<SectionImagePickerCubit>(
          create: (context) => SectionImagePickerCubit(),
        ),
        BlocProvider<SectionManagementCubit>(
          create: (context) => SectionManagementCubit(),
        ),
        BlocProvider<SectionImageManagementCubit>(
          create: (context) => SectionImageManagementCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(
          WidgetsBinding.instance.window.physicalSize.width /
              WidgetsBinding.instance.window.devicePixelRatio,
          WidgetsBinding.instance.window.physicalSize.height /
              WidgetsBinding.instance.window.devicePixelRatio,
        ),
        builder: () => MaterialApp(
          title: '365 Services Admin Panel',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: BaseScreenColor.bgColor,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.white),
            primaryColor: Service365ThemeColor.theme365,
            canvasColor: BaseScreenColor.secondaryColor,
          ),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            bloc: _authenticationBloc,
            builder: (buildContext, state) {
              if (state is AuthenticationUninitialized) {
                return const LoadingScreen();
              } else if (state is AuthenticationAuthenticated) {
                return const DashBoardScreen();
              } else if (state is AuthenticationUnauthenticated) {
                return const AuthScreen();
                // return const DashBoardScreen();
              } else {
                return const LoadingScreen();
              }
            },
          ),
          onGenerateRoute: ScreenRouter().onGeneratedRouter,
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/city_manager/city_manager_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/service_manager/service_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/city_model.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/service_model.dart';
import 'package:service365_admin_panel/tools/responsive_handler.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';
import 'package:service365_admin_panel/utility/text_field_widget.dart';
import 'package:service365_admin_panel/utility/ui_color.dart';

class AddCityDialogWidget extends StatefulWidget {
  final CityModel? cityModel;
  const AddCityDialogWidget({
    Key? key,
    this.cityModel,
  }) : super(key: key);

  @override
  State<AddCityDialogWidget> createState() => _AddCityDialogWidgetState();
}

class _AddCityDialogWidgetState extends State<AddCityDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _cityNameController = TextEditingController();
  bool _isNameChanged = false;
  CityModel? _cityModel;
  @override
  void initState() {
    if (widget.cityModel != null) {
      _cityModel = widget.cityModel!;
      _cityNameController.text = _cityModel!.cityName;
    }
    super.initState();
  }

  Future<void> _submit() async {
    if (!kIsWeb) {
      //to vibrate the phone
      await HapticFeedback.lightImpact();
      //close the softkeyboard when _sumbit() is called
      FocusScope.of(context).unfocus();
    }

    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    } else {
      if (widget.cityModel != null &&
          _cityNameController.text != _cityModel!.cityName) {
        _isNameChanged = true;
        _cityModel!.cityName = _cityNameController.text;
      }
      _formKey.currentState!.save();
      if (widget.cityModel == null) {
        await BlocProvider.of<CityManagerCubit>(context).addCity(
          context: context,
          cityName: _cityNameController.text,
        );
      } else {
        await BlocProvider.of<CityManagerCubit>(context).editCity(
          context: context,
          cityModel: _cityModel!,
          isNameChanged: _isNameChanged,
        );
      }

      Navigator.of(context).pop();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _cityManagerCubit = BlocProvider.of<CityManagerCubit>(context);
    final _deviceSize = MediaQuery.of(context).size;
    final _addButton = ElevatedButton(
        child: Text((widget.cityModel == null) ? 'Add' : 'Update'),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            horizontal: _deviceSize.width *
                (ResponsiveWidget.isMobile(context) ? 0.1 : 0.05),
            vertical: _deviceSize.height * 0.02,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(UiColors.themeColor),
          foregroundColor:
              MaterialStateProperty.all(UiColors.logInButtonForeground),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveWidget.isMobile(context) ? 12 : 14,
              ),
            ),
          ),
        ),
        onPressed: () async {
          await _submit();
        });
    final _cityNameTextField = TextFieldWidget(
      controller: _cityNameController,
      text: 'City Name',
      hintText: 'City Name',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return "Field can't be empty";
        }
        return null;
      },
    );
    final _serviceTextFontStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      color: BaseScreenColor.pageTitleTextfontColor,
      fontSize: ((ResponsiveWidget.isDesktop(context) ? 14 : 12)),
      fontWeight: FontWeight.w600,
    ));
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _cityNameTextField,
          SizedBox(height: _deviceSize.height * 0.05),
          if (widget.cityModel != null &&
              _cityModel!.availableServices.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Selected services',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_cityModel != null && _cityModel!.availableServices.isNotEmpty)
            StreamBuilder<List<CityModel?>>(
              stream: BlocProvider.of<CityManagerCubit>(context)
                  .fetchCity(context: context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: _deviceSize.height * 0.6,
                    width: _deviceSize.width *
                        (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.6),
                    child: const Center(
                      child: SpinLoadingIndicator(),
                    ),
                  );
                } else {
                  final _logs = snapshot.data ?? [];

                  //Asign the streamBuilder cityModel to local cityModel variable.
                  _cityModel = _logs.firstWhere(
                      (element) => element!.id == widget.cityModel!.id);
                  if (_cityModel!.availableServices.isEmpty) {
                    return const Center(
                      child: Text(
                        'No service available',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      width: _deviceSize.width *
                          (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.8),
                      height: _deviceSize.height *
                          (_cityModel!.availableServices.length > 2
                              ? 0.18
                              : (_cityModel!.availableServices.length == 1)
                                  ? 0.1
                                  : 0.15),
                      child: ListView.builder(
                        itemCount: _cityModel!.availableServices.length,
                        itemBuilder: (context, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _cityModel!
                                    .availableServices[index].serviceName,
                                style: _serviceTextFontStyle,
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text(
                                        "Are you sure!",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      content: Text(
                                        "You are about to delete the service ${_cityModel!.availableServices[index].serviceName}!",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      actions: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                          ),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await BlocProvider.of<
                                                    CityManagerCubit>(context)
                                                .deleteSelectedService(
                                              context: context,
                                              cityModel: _cityModel!,
                                              serviceIndex: index,
                                            );
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  size: 22,
                                  color: Colors.red,
                                ),
                              ),
                            ]),
                      ),
                    );
                  }
                }
              },
            ),
          if (_cityModel != null && _cityModel!.availableServices.isNotEmpty)
            SizedBox(height: _deviceSize.height * 0.01),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Add services',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder<List<ServiceModel?>>(
              stream: BlocProvider.of<ServiceCubit>(context)
                  .fetchService(context: context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    // height: _deviceSize.height * 0.6,
                    // width: _deviceSize.width *
                    //     (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.6),
                    height: 60.h,
                    width: 60.w,
                    child: const Center(
                      child: SpinLoadingIndicator(),
                    ),
                  );
                } else {
                  final logs = snapshot.data ?? [];
                  //print(logs);
                  if (logs.isEmpty) {
                    return SizedBox(
                      // height: _deviceSize.height * 0.6,
                      // width: _deviceSize.width *
                      //     (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.6),
                      height: 80.h,
                      width: 200.w,
                      child: Center(
                        child: Text(
                          'No service available',
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    );
                  } else {
                    _cityManagerCubit.setServiceListFromStream(
                      availableService: logs,
                    );
                    return SizedBox(
                      // height: _deviceSize.height * 0.2,
                      // width: _deviceSize.width *
                      //     (ResponsiveWidget.isDesktop(context) ? 0.3 : 0.8),
                      height: 150.h,
                      width: 300.w,
                      child: ListView.builder(
                          controller: ScrollController(),
                          itemCount: _cityManagerCubit
                              .availableServiceWithCheckList.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              // const Divider(),
                              StatefulBuilder(
                                builder: (checkListContext, setState) =>
                                    CheckboxListTile(
                                  checkColor: Colors.black,
                                  title: Text(
                                    _cityManagerCubit
                                        .availableServiceWithCheckList[index]
                                        .service
                                        .serviceName,
                                    style: _serviceTextFontStyle,
                                  ),
                                  value: _cityManagerCubit
                                      .availableServiceWithCheckList[index]
                                      .isChecked,
                                  onChanged: (value) async {
                                    await _cityManagerCubit.checkUncheckService(
                                      index: index,
                                      isChecked: value ?? false,
                                    );
                                    setState(() {});
                                    return;
                                  },
                                ),
                              ),
                              // const Divider(),
                            ]);
                          }),
                    );
                  }
                }
              }),
          BlocBuilder<CityManagerCubit, CityManagerState>(
            builder: (context, state) {
              if (state is ShowLoadingSpinnerofCity) {
                return const SpinLoadingIndicator();
              } else {
                return _addButton;
              }
            },
          ),
        ]),
      ),
    );
  }
}

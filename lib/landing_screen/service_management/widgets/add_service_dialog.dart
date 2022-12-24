import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/pick_service_image/pick_service_image_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/logic/service_manager/service_cubit.dart';
import 'package:service365_admin_panel/landing_screen/service_management/model/service_model.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';
import 'package:service365_admin_panel/utility/text_field_widget.dart';
import 'package:service365_admin_panel/utility/ui_color.dart';

class AddServiceDialogWidget extends StatefulWidget {
  final ServiceModel? service;
  const AddServiceDialogWidget({
    Key? key,
    this.service,
  }) : super(key: key);

  @override
  State<AddServiceDialogWidget> createState() => _AddServiceDialogWidgetState();
}

class _AddServiceDialogWidgetState extends State<AddServiceDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _serviceNameController = TextEditingController();
  final _servicePriceController1 = TextEditingController();
  final _servicePriceController2 = TextEditingController();
  final _servicePriceController3 = TextEditingController();
  final _servicePriceController4 = TextEditingController();
  final _servicePriceController5 = TextEditingController();
  final _servicePriceController6 = TextEditingController();
  final _servicePriceController7 = TextEditingController();
  final _servicePriceController8 = TextEditingController();
  final _servicePriceController9 = TextEditingController();
  final _servicePriceController10 = TextEditingController();

  PickedImageModel? _pickedImageModel;
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        (_pickedImageModel == null && widget.service == null)) {
      // Invalid!
      if (_pickedImageModel == null && widget.service == null) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              "Warning!",
              style: TextStyle(fontSize: 15.sp),
            ),
            content: Text(
              'Please select a image.',
              style: TextStyle(fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                // style: TextButton.styleFrom(
                //   primary: Colors.black,
                // ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
        return;
      }
    } else {
      _formKey.currentState!.save();
      if (widget.service == null) {
        await BlocProvider.of<ServiceCubit>(context).addService(
          context: context,
          service: ServiceModel(serviceName: _serviceNameController.text, servicePrice1: _servicePriceController1.text,
              servicePrice2: _servicePriceController2.text, servicePrice3: _servicePriceController3.text,
              servicePrice4: _servicePriceController4.text, servicePrice5: _servicePriceController5.text,
              servicePrice6: _servicePriceController6.text, servicePrice7: _servicePriceController7.text,
              servicePrice8: _servicePriceController8.text, servicePrice9: _servicePriceController9.text,
              servicePrice10: _servicePriceController10.text),

          pickedImage: _pickedImageModel!,
        );
        //Close the dialog box
      } else {
        await BlocProvider.of<ServiceCubit>(context).editService(
          context: context,
          service: ServiceModel(
            serviceName: _serviceNameController.text,
            id: widget.service!.id,
            imageUrl: widget.service!.imageUrl, servicePrice1: _servicePriceController1.text,
              servicePrice2: _servicePriceController2.text, servicePrice3: _servicePriceController3.text,
              servicePrice4: _servicePriceController4.text, servicePrice5: _servicePriceController5.text,
              servicePrice6: _servicePriceController6.text, servicePrice7: _servicePriceController7.text,
              servicePrice8: _servicePriceController8.text, servicePrice9: _servicePriceController9.text,
              servicePrice10: _servicePriceController10.text),
          pickedImage: _pickedImageModel,
        );
      }
      Navigator.of(context).pop();
      return;
    }
  }

  @override
  void initState() {
    if (widget.service != null) {
      _serviceNameController.text = widget.service!.serviceName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final _textStyle = GoogleFonts.poppins(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        // fontSize: ResponsiveWidget.isMobile(context) ? 12 : 14,
        fontSize: 12.sp,
      ),
    );
    final _addButton = ElevatedButton(
      child: Text((widget.service == null) ? 'Add' : 'Update'),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
          // horizontal: _deviceSize.width *
          //     (ResponsiveWidget.isMobile(context) ? 0.1 : 0.05),
          // vertical: _deviceSize.height * 0.02,
          horizontal: 80.w,
          vertical: 10.h,
        )),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(UiColors.themeColor),
        foregroundColor:
            MaterialStateProperty.all(UiColors.logInButtonForeground),
        textStyle: MaterialStateProperty.all(_textStyle),
      ),
      onPressed: () async {
        await _submit();
      },
    );
    _addImagePickButton({required String buttonName}) => OutlinedButton(
          child: Text(buttonName),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              // horizontal: _deviceSize.width *
              //     (ResponsiveWidget.isMobile(context) ? 0.1 : 0.03),
              // vertical: _deviceSize.height * 0.02,
              horizontal: 60.w,
              vertical: 10.h,
            )),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(UiColors.themeColor),
            foregroundColor:
                MaterialStateProperty.all(UiColors.logInButtonForeground),
            textStyle: MaterialStateProperty.all(_textStyle),
          ),
          onPressed: () async {
            await BlocProvider.of<PickServiceImageCubit>(context)
                .pickServiceImage(context: context);
          },
        );
    final _serviceNameTextField = TextFieldWidget(
      controller: _serviceNameController,
      text: 'Service Name',
      hintText: 'Service Name',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return "Field can't be empty";
        }
        return null;
      },
    );
    final _serviceNameTextField1 = TextFieldWidget(
      controller: _servicePriceController1,
      text: 'price 1',
      hintText: 'price 1',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
    final _serviceNameTextField2 = TextFieldWidget(
      controller: _servicePriceController2,
      text: 'price 2',
      hintText: 'price 2',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
    final _serviceNameTextField3 = TextFieldWidget(
      controller: _servicePriceController3,
      text: 'price 3',
      hintText: 'price 3',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
    final _serviceNameTextField4 = TextFieldWidget(
      controller: _servicePriceController4,
      text: 'price 4',
      hintText: 'price 4',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
    final _serviceNameTextField5 = TextFieldWidget(
      controller: _servicePriceController5,
      text: 'price 5',
      hintText: 'price 5',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
    final _serviceNameTextField6 = TextFieldWidget(
      controller: _servicePriceController6,
      text: 'price 6',
      hintText: 'price 6',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
    final _serviceNameTextField7 = TextFieldWidget(
      controller: _servicePriceController7,
      text: 'price 7',
      hintText: 'price 7',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );

    final _serviceNameTextField8 = TextFieldWidget(
      controller: _servicePriceController8,
      text: 'price 8',
      hintText: 'price 8',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
    final _serviceNameTextField9 = TextFieldWidget(
      controller: _servicePriceController9,
      text: 'price 9',
      hintText: 'price 9',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
    final _serviceNameTextField10 = TextFieldWidget(
      controller: _servicePriceController10,
      text: 'price 10',
      hintText: 'price 10',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
    );
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
        _serviceNameTextField,
        SizedBox(height: 10.h),
        _serviceNameTextField1,
        SizedBox(height: 10.h),
        _serviceNameTextField2,
        SizedBox(height: 10.h),
        _serviceNameTextField3,
        SizedBox(height: 10.h),
        _serviceNameTextField4,
        SizedBox(height: 10.h),
        _serviceNameTextField5,
        SizedBox(height: 10.h),
        _serviceNameTextField6,
        SizedBox(height: 10.h),
        _serviceNameTextField7,
        SizedBox(height: 10.h),
        _serviceNameTextField8,
        SizedBox(height: 10.h),
        _serviceNameTextField9,
        SizedBox(height: 10.h),
        _serviceNameTextField10,
        SizedBox(height: 10.h),
        BlocBuilder<PickServiceImageCubit, PickServiceImageState>(
          builder: (context, state) {
            if (state is ServiceImagepicked) {
              _pickedImageModel = state.pickedImageModel;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Image.file(
                    //   state.pickedImageModel.selectedImage!,
                    //   fit: BoxFit.fitWidth,
                    //   height: 150.h,
                    //   width: 150.w,
                    // ),
                    Text(
                      state.pickedImageModel.selectedImage?.path ?? '',
                      style: _textStyle,
                    ),
                    SizedBox(height: 10.h),
                    _addImagePickButton(buttonName: 'Change Image')
                  ]);
            } else if (state is ShowSpinnerDuringImagePick) {
              return const SpinLoadingIndicator();
            } else {
              if (widget.service != null) {
                return Column(children: [
                  CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      height: 150.h,
                      width: 150.w,
                      imageUrl: widget.service!.imageUrl ?? '',
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.grey),
                                ),
                              ),
                      errorWidget: (context, url, error) {
                        return const Icon(Icons.error);
                      }),
                  SizedBox(height: 10.h),
                  _addImagePickButton(buttonName: 'Change Image')
                ]);
              } else {
                return _addImagePickButton(buttonName: 'Pick Image');
              }
            }
          },
        ),
        SizedBox(height: _deviceSize.height * 0.02),
        BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            if (state is ShowLoadingSpinner) {
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



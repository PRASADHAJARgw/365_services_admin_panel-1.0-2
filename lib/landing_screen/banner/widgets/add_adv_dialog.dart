import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/landing_screen/banner/logic/banner_image_picker/banner_image_picker_cubit.dart';
import 'package:service365_admin_panel/landing_screen/banner/logic/bannermanagement/bannermanagement_cubit.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';
import 'package:service365_admin_panel/utility/text_field_widget.dart';
import 'package:service365_admin_panel/utility/ui_color.dart';

class AddAdvDialogWidget extends StatefulWidget {
  const AddAdvDialogWidget({Key? key}) : super(key: key);

  @override
  State<AddAdvDialogWidget> createState() => _AddAdvDialogWidgetState();
}

class _AddAdvDialogWidgetState extends State<AddAdvDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _advNameController = TextEditingController();
  PickedImageModel? _pickedImageModel;

  // @override
  // void initState() {
  //   if (widget.cityModel != null) {
  //     _cityModel = widget.cityModel!;
  //     _advNameController.text = _cityModel!.cityName;
  //   }
  //   super.initState();
  // }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _pickedImageModel == null) {
      // Invalid!
      if (_pickedImageModel == null) {
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
      return;
    } else {
      await BlocProvider.of<BannerManagementCubit>(context).addAdv(
        context: context,
        advertisementModel: AdvertisementModel(name: _advNameController.text),
        pickedImage: _pickedImageModel!,
      );
      Navigator.of(context).pop();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _deviceSize = MediaQuery.of(context).size;
    final _addButton = ElevatedButton(
        child: const Text('Add'),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            horizontal: 40.w,
            vertical: 10.h,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(UiColors.themeColor),
          foregroundColor:
              MaterialStateProperty.all(UiColors.logInButtonForeground),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
        onPressed: () async {
          await _submit();
        });
    final _nameTextField = TextFieldWidget(
      controller: _advNameController,
      text: 'Adv Name',
      hintText: 'Adv Name',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return "Field can't be empty";
        }
        return null;
      },
    );
    final _textStyle = GoogleFonts.poppins(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        // fontSize: ResponsiveWidget.isMobile(context) ? 12 : 14,
        fontSize: 12.sp,
      ),
    );
    _addImagePickButton({required String buttonName}) => OutlinedButton(
          child: Text(buttonName),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              horizontal: 40.w,
              vertical: 10.h,
            )),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(UiColors.themeColor),
            foregroundColor:
                MaterialStateProperty.all(UiColors.logInButtonForeground),
            textStyle: MaterialStateProperty.all(_textStyle),
          ),
          onPressed: () async {
            await BlocProvider.of<BannerImagePickerCubit>(context)
                .pickBannerImage(context: context);
          },
        );

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _nameTextField,
          SizedBox(height: 10.h),
          BlocBuilder<BannerImagePickerCubit, BannerImagePickerState>(
            builder: (context, state) {
              if (state is BannerImagepicked) {
                _pickedImageModel = state.pickedImageModel;
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        state.pickedImageModel.selectedImage?.path ?? '',
                        style: _textStyle,
                      ),
                      SizedBox(height: 5.h),
                      _addImagePickButton(buttonName: 'Change Image')
                    ]);
              } else if (state is ShowSpinnerDuringImagePick) {
                return const SpinLoadingIndicator();
              } else {
                return _addImagePickButton(buttonName: 'Pick Image');
              }
            },
          ),
          SizedBox(height: 10.h),
          BlocBuilder<BannerManagementCubit, BannerManagementState>(
            builder: (context, state) {
              if (state is ShowBannerLoadingSpinner) {
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

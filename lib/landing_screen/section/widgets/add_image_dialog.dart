import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/landing_screen/section/logic/section_image_management/section_image_management_cubit.dart';
import 'package:service365_admin_panel/landing_screen/section/logic/section_image_picker/section_imagepicker_cubit.dart';
import 'package:service365_admin_panel/utility/image_picker.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';
import 'package:service365_admin_panel/utility/text_field_widget.dart';
import 'package:service365_admin_panel/utility/ui_color.dart';

class AddImageDialogWidget extends StatefulWidget {
  final AdvertisementModel advertisementModel;
  const AddImageDialogWidget({
    Key? key,
    required this.advertisementModel,
  }) : super(key: key);

  @override
  State<AddImageDialogWidget> createState() => _AddImageDialogWidgetState();
}

class _AddImageDialogWidgetState extends State<AddImageDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _nameController = TextEditingController();
  PickedImageModel? _pickedImageModel;

  // @override
  // void initState() {
  //   if (widget.cityModel != null) {
  //     _cityModel = widget.cityModel!;
  //     _nameController.text = _cityModel!.cityName;
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
      await BlocProvider.of<SectionImageManagementCubit>(context)
          .addSectionImageToFirebase(
        context: context,
        advertisementModel: widget.advertisementModel,
        pickedImage: _pickedImageModel!,
        imageName: _nameController.text,
      );
      Navigator.of(context).pop();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      controller: _nameController,
      text: 'Image Name',
      hintText: 'Image Name',
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
        fontSize: 12.sp,
      ),
    );
    _addImagePickButton({required String buttonName}) => OutlinedButton(
          child: Text(buttonName),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: 40.w,
                vertical: 10.h,
              ),
            ),
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
            await BlocProvider.of<SectionImagePickerCubit>(context)
                .pickSectionImage(context: context);
          },
        );

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _nameTextField,
          SizedBox(height: 10.h),
          BlocBuilder<SectionImagePickerCubit, SectionImagePickerState>(
            builder: (context, state) {
              if (state is SectionImagepicked) {
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
              } else if (state is ShowSpinnerDuringSelectionImagePick) {
                return const SpinLoadingIndicator();
              } else {
                return _addImagePickButton(buttonName: 'Pick Image');
              }
            },
          ),
          SizedBox(height: 10.h),
          BlocBuilder<SectionImageManagementCubit, SectionImageManagementState>(
            builder: (context, state) {
              if (state is SectionImageLoading) {
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

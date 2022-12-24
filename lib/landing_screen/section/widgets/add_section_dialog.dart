import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/landing_screen/banner/model/advertisement_model.dart';
import 'package:service365_admin_panel/landing_screen/section/logic/section_management/section_management_cubit.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';
import 'package:service365_admin_panel/utility/text_field_widget.dart';
import 'package:service365_admin_panel/utility/ui_color.dart';

class AddSectionDialogWidget extends StatefulWidget {
  const AddSectionDialogWidget({Key? key}) : super(key: key);

  @override
  State<AddSectionDialogWidget> createState() => _AddSectionDialogWidgetState();
}

class _AddSectionDialogWidgetState extends State<AddSectionDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _sectionNameController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!

      return;
    } else {
      await BlocProvider.of<SectionManagementCubit>(context).addSection(
        context: context,
        advertisementModel:
            AdvertisementModel(name: _sectionNameController.text),
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
    final _sectionNameTextField = TextFieldWidget(
      controller: _sectionNameController,
      text: 'Section Name',
      hintText: 'Section Name',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return "Field can't be empty";
        }
        return null;
      },
    );

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _sectionNameTextField,
          SizedBox(height: 20.h),
          BlocBuilder<SectionManagementCubit, SectionmanagementState>(
            builder: (context, state) {
              if (state is ShowSectionLoadingSpinner) {
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

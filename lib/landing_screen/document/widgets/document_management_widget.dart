import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:service365_admin_panel/config/firebase_table_name.dart';
import 'package:service365_admin_panel/constant/colors/base_screen_color.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/widgets/header.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/TermsAndCondiiton/termsandcondition_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/document_manager/documentmanager_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/pick_aboutus_document/pickaboutusdocument_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/logic/pick_privacypolicy/pickprivacypolicy_cubit.dart';
import 'package:service365_admin_panel/landing_screen/document/model/document_model.dart';
import 'package:service365_admin_panel/utility/document_picker.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';

class DocumentManagementWidget extends StatelessWidget {
  const DocumentManagementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(width: _deviceSize.height * 0.01),
        const AboutUsDocsManagement(),
        SizedBox(height: _deviceSize.height * 0.02),
        const PrivacyPolicyDocsManagement(),
        SizedBox(height: _deviceSize.height * 0.02),
        const TermsAndConditionDocsManagement(),
        SizedBox(height: _deviceSize.height * 0.02),
      ],
    );
  }
}

class AboutUsDocsManagement extends StatefulWidget {
  const AboutUsDocsManagement({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutUsDocsManagement> createState() => _AboutUsDocsManagementState();
}

class _AboutUsDocsManagementState extends State<AboutUsDocsManagement> {
  PickedDocumentModel? _pickedDocsModel;

  Future<void> _submit() async {
    if (_pickedDocsModel == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Warning!",
            style: TextStyle(fontSize: 15.sp),
          ),
          content: Text(
            'Please select a document.',
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
    } else {
      await BlocProvider.of<DocumentmanagerCubit>(context).addDocument(
        context: context,
        documentModel:
            DocumentModel(documentName: _pickedDocsModel!.selectedFile!.path),
        pickedDocumentModel: _pickedDocsModel!,
        firebaseDocumentPath: FirebasePath.aboutUs,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      width: 540.w,
      child: Column(
        children: [
          const Header(title: 'ABOUT US DOCUMENT'),
          BlocBuilder<PickaboutusdocumentCubit, PickaboutusdocumentState>(
            builder: (context, state) {
              if (state is AboutUsDocsPicked) {
                _pickedDocsModel = state.pickedDocumentModel;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.pickedDocumentModel.selectedFile?.path ??
                            'N/A'),
                        SizedBox(width: 10.w),
                        DocHandleButton(
                          buttonName: 'Change',
                          onPressed: () async {
                            await BlocProvider.of<PickaboutusdocumentCubit>(
                                    context)
                                .pickAboutUsDocument(context: context);
                          },
                        ),
                      ],
                    ),
                    if (_pickedDocsModel != null) SizedBox(height: 10.h),
                    if (_pickedDocsModel != null)
                      BlocBuilder<DocumentmanagerCubit, DocumentmanagerState>(
                        builder: (context, state) {
                          if (state is ShowDocsLoadingSpinner) {
                            return const SpinLoadingIndicator();
                          } else {
                            return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DocHandleButton(
                                    buttonName: 'Upload',
                                    onPressed: () async {
                                      await _submit();
                                    },
                                  ),
                                  DocHandleButton(
                                    buttonName: 'Cancel',
                                    onPressed: () async {
                                      await BlocProvider.of<
                                              PickaboutusdocumentCubit>(context)
                                          .resetDocs();
                                    },
                                  ),
                                ]);
                          }
                        },
                      ),
                    if (_pickedDocsModel != null) SizedBox(height: 10.h),
                  ],
                );
              } else {
                return StreamBuilder<DocumentModel?>(
                  stream: BlocProvider.of<DocumentmanagerCubit>(context)
                      .fetchAboutUsDocs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 100.h,
                        width: 100.w,
                        child: const Center(
                          child: SpinLoadingIndicator(),
                        ),
                      );
                    } else {
                      final _logs = snapshot.data;

                      if (_logs == null) {
                        return DocHandleButton(
                          buttonName: 'Add',
                          onPressed: () async {
                            await BlocProvider.of<PickaboutusdocumentCubit>(
                                    context)
                                .pickAboutUsDocument(context: context);
                          },
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_logs.documentName ?? 'N/A'),
                              SizedBox(width: 10.w),
                              DocHandleButton(
                                buttonName: 'Change',
                                onPressed: () async {
                                  await BlocProvider.of<
                                          PickaboutusdocumentCubit>(context)
                                      .pickAboutUsDocument(context: context);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class PrivacyPolicyDocsManagement extends StatefulWidget {
  const PrivacyPolicyDocsManagement({
    Key? key,
  }) : super(key: key);

  @override
  State<PrivacyPolicyDocsManagement> createState() =>
      _PrivacyPolicyDocsManagementState();
}

class _PrivacyPolicyDocsManagementState
    extends State<PrivacyPolicyDocsManagement> {
  PickedDocumentModel? _pickedDocsModel;

  Future<void> _submit() async {
    if (_pickedDocsModel == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Warning!",
            style: TextStyle(fontSize: 15.sp),
          ),
          content: Text(
            'Please select a document.',
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
    } else {
      await BlocProvider.of<DocumentmanagerCubit>(context).addDocument(
        context: context,
        documentModel:
            DocumentModel(documentName: _pickedDocsModel!.selectedFile!.path),
        pickedDocumentModel: _pickedDocsModel!,
        firebaseDocumentPath: FirebasePath.privacyPolicy,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      width: 540.w,
      child: Column(
        children: [
          const Header(title: 'PRIVACY POLICY DOCUMENT'),
          BlocBuilder<PickprivacypolicyCubit, PickprivacypolicyState>(
            builder: (context, state) {
              if (state is PrivacyPolicyPicked) {
                _pickedDocsModel = state.pickedDocumentModel;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.pickedDocumentModel.selectedFile?.path ??
                            'N/A'),
                        SizedBox(width: 10.w),
                        DocHandleButton(
                          buttonName: 'Change',
                          onPressed: () async {
                            await BlocProvider.of<PickprivacypolicyCubit>(
                                    context)
                                .pickPrivacyPolicyDocument(context: context);
                          },
                        ),
                      ],
                    ),
                    if (_pickedDocsModel != null) SizedBox(height: 10.h),
                    if (_pickedDocsModel != null)
                      BlocBuilder<DocumentmanagerCubit, DocumentmanagerState>(
                        builder: (context, state) {
                          if (state is ShowDocsLoadingSpinner) {
                            return const SpinLoadingIndicator();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DocHandleButton(
                                  buttonName: 'Upload',
                                  onPressed: () async {
                                    await _submit();
                                  },
                                ),
                                DocHandleButton(
                                  buttonName: 'Cancel',
                                  onPressed: () async {
                                    await BlocProvider.of<
                                            PickprivacypolicyCubit>(context)
                                        .resetDocs();
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    if (_pickedDocsModel != null) SizedBox(height: 10.h),
                  ],
                );
              } else {
                return StreamBuilder<DocumentModel?>(
                  stream: BlocProvider.of<DocumentmanagerCubit>(context)
                      .fetchPrivacyPolicyDocs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 100.h,
                        width: 100.w,
                        child: const Center(
                          child: SpinLoadingIndicator(),
                        ),
                      );
                    } else {
                      final _logs = snapshot.data;

                      if (_logs == null) {
                        return DocHandleButton(
                          buttonName: 'Add',
                          onPressed: () async {
                            await BlocProvider.of<PickprivacypolicyCubit>(
                                    context)
                                .pickPrivacyPolicyDocument(context: context);
                          },
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_logs.documentName ?? 'N/A'),
                              SizedBox(width: 10.w),
                              DocHandleButton(
                                buttonName: 'Change',
                                onPressed: () async {
                                  await BlocProvider.of<PickprivacypolicyCubit>(
                                          context)
                                      .pickPrivacyPolicyDocument(
                                          context: context);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class TermsAndConditionDocsManagement extends StatefulWidget {
  const TermsAndConditionDocsManagement({
    Key? key,
  }) : super(key: key);

  @override
  State<TermsAndConditionDocsManagement> createState() =>
      _TermsAndConditionDocsManagementState();
}

class _TermsAndConditionDocsManagementState
    extends State<TermsAndConditionDocsManagement> {
  PickedDocumentModel? _pickedDocsModel;

  Future<void> _submit() async {
    if (_pickedDocsModel == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Warning!",
            style: TextStyle(fontSize: 15.sp),
          ),
          content: Text(
            'Please select a document.',
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
    } else {
      await BlocProvider.of<DocumentmanagerCubit>(context).addDocument(
        context: context,
        documentModel:
            DocumentModel(documentName: _pickedDocsModel!.selectedFile!.path),
        pickedDocumentModel: _pickedDocsModel!,
        firebaseDocumentPath: FirebasePath.termsAndCondition,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      width: 540.w,
      child: Column(
        children: [
          const Header(title: 'TERMS AND CONDITION DOCUMENT'),
          BlocBuilder<TermsandconditionCubit, TermsandconditionState>(
            builder: (context, state) {
              if (state is TermsAndConditionPicked) {
                _pickedDocsModel = state.pickedDocumentModel;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.pickedDocumentModel.selectedFile?.path ??
                            'N/A'),
                        SizedBox(width: 10.w),
                        DocHandleButton(
                          buttonName: 'Change',
                          onPressed: () async {
                            await BlocProvider.of<TermsandconditionCubit>(
                                    context)
                                .pickTermsAndConditionDocument(
                                    context: context);
                          },
                        ),
                      ],
                    ),
                    if (_pickedDocsModel != null) SizedBox(height: 10.h),
                    if (_pickedDocsModel != null)
                      BlocBuilder<DocumentmanagerCubit, DocumentmanagerState>(
                        builder: (context, state) {
                          if (state is ShowDocsLoadingSpinner) {
                            return const SpinLoadingIndicator();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DocHandleButton(
                                  buttonName: 'Upload',
                                  onPressed: () async {
                                    await _submit();
                                  },
                                ),
                                SizedBox(width: 10.w),
                                DocHandleButton(
                                  buttonName: 'Cancel',
                                  onPressed: () async {
                                    await BlocProvider.of<
                                            TermsandconditionCubit>(context)
                                        .resetDocs();
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    if (_pickedDocsModel != null) SizedBox(height: 10.h),
                  ],
                );
              } else {
                return StreamBuilder<DocumentModel?>(
                  stream: BlocProvider.of<DocumentmanagerCubit>(context)
                      .fetchTermsAndConditionDocs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 100.h,
                        width: 100.w,
                        child: const Center(
                          child: SpinLoadingIndicator(),
                        ),
                      );
                    } else {
                      final _logs = snapshot.data;

                      if (_logs == null) {
                        return DocHandleButton(
                          buttonName: 'Add',
                          onPressed: () async {
                            await BlocProvider.of<TermsandconditionCubit>(
                                    context)
                                .pickTermsAndConditionDocument(
                                    context: context);
                          },
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_logs.documentName ?? 'N/A'),
                              SizedBox(width: 10.w),
                              DocHandleButton(
                                buttonName: 'Change',
                                onPressed: () async {
                                  await BlocProvider.of<TermsandconditionCubit>(
                                          context)
                                      .pickTermsAndConditionDocument(
                                          context: context);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
class DocHandleButton extends StatelessWidget {
  final String buttonName;
  final void Function()? onPressed;

  const DocHandleButton({
    Key? key,
    required this.buttonName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: ElevatedButton(
        child: Text(buttonName),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 5.h,
          )),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor:
              MaterialStateProperty.all(BaseScreenColor.themeColor),
          foregroundColor:
              MaterialStateProperty.all(BaseScreenColor.buttonTextColor),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service365_admin_panel/authentication/logic/login/login_bloc.dart';
import 'package:service365_admin_panel/utility/text_field_widget.dart';
import 'package:service365_admin_panel/constant/enums.dart';
import 'package:service365_admin_panel/utility/spinloading_indicator.dart';
import 'package:service365_admin_panel/utility/ui_color.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  AuthMode _authMode = AuthMode.login;
  var _showPassword = false;
  var _showConfirmPassword = false;
  LoginBloc get _loginBloc => BlocProvider.of<LoginBloc>(context);

  bool showPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
    return _showPassword;
  }

  bool showConfirmPassword() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
    return _showConfirmPassword;
  }

  @override
  void dispose() {
    _userEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
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
      _formKey.currentState!.save();
      if (_authMode == AuthMode.login) {
        _loginBloc.add(
          LoginButtonPressed(
            userEmail: _userEmailController.text,
            password: _passwordController.text,
            isLogin: true,
          ),
        );
      } else {
        _loginBloc.add(
          LoginButtonPressed(
            userEmail: _userEmailController.text,
            password: _passwordController.text,
            phoneNumber: _phoneNumberController.text,
            isLogin: false,
          ),
        );
      }
      return;
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
    return;
  }

  String? emailErrorMessage;
  String? phoneErrorMessage;
  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    final _phoneNumber = TextFieldWidget(
      controller: _phoneNumberController,
      autofillHints: const [AutofillHints.telephoneNumber],
      text: 'Phone',
      hintText: 'Phone',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      validator: (value) {
        phoneErrorMessage = null;
        if (value!.isEmpty) {
          return "Field can't be empty.";
        } else if (!value.contains(RegExp(r'[0-9]'))) {
          return 'Invalid phone number!';
        }
        return null;
      },
    );

    final _userEmail = TextFieldWidget(
      controller: _userEmailController,
      autofillHints: const [AutofillHints.email],
      text: 'Email',
      hintText: 'Email',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        emailErrorMessage = null;
        if (value!.isEmpty) {
          return "Field can't be empty";
        } else if (!value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
    );

    final _password = TextFieldWidget(
      controller: _passwordController,
      autofillHints: const [AutofillHints.password],
      text: 'Password',
      hintText: 'Password',
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _showPassword ? false : true,
      suffixIcon: IconButton(
        color: Colors.white,
        onPressed: showPassword,
        icon: _showPassword
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Field can't be empty";
        } else {
          return null;
        }
      },
    );

    final _confirmPassword = TextFieldWidget(
      controller: _confirmPasswordController,
      text: 'Confirm password',
      hintText: 'Confirm password',
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _showConfirmPassword ? false : true,
      suffixIcon: IconButton(
        color: Colors.white,
        onPressed: showConfirmPassword,
        icon: _showConfirmPassword
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
      ),
      validator: _authMode == AuthMode.signup
          ? (value) {
              if (value!.isEmpty) {
                return 'Re-enter your password';
              } else if (value != _passwordController.text) {
                return 'Passwords do not match!';
              } else {
                return null;
              }
            }
          : null,
    );

    final _submitButton = ElevatedButton(
        child: Text(_authMode == AuthMode.login ? 'Log in' : 'Sign up'),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            // horizontal: _deviceSize.width *
            //     (ResponsiveWidget.isMobile(context) ? 0.15 : 0.1),
            // vertical: _deviceSize.height * 0.03,
            horizontal: 100.w,
            vertical: 18.h,
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
                // fontSize: ResponsiveWidget.isMobile(context) ? 11 : 13,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
        onPressed: () async {
          await _submit();
        });

    final _authSwtich = TextButton(
      child: Text(
        _authMode == AuthMode.login
            ? 'New user? Sign up here'
            : 'I have already an account',
      ),
      onPressed: _switchAuthMode,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(UiColors.foregroundColor),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
          // horizontal: _deviceSize.width * 0.03,
          horizontal: 30.w,
          // vertical: 6,
        )),
        textStyle: MaterialStateProperty.all(GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            // fontSize: ResponsiveWidget.isMobile(context) ? 10 : 12,
            fontSize: 11.sp,
          ),
        )),
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: _deviceSize.height * 0.02),
          _userEmail,
          SizedBox(height: _deviceSize.height * 0.02),
          _password,
          SizedBox(height: _deviceSize.height * 0.02),
          if (_authMode == AuthMode.signup) _confirmPassword,
          SizedBox(height: _deviceSize.height * 0.02),
          if (_authMode == AuthMode.signup)
            BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginFailureByPhone) {
                  setState(() {
                    phoneErrorMessage = state.rawError;
                  });
                }
              },
              child: _phoneNumber,
            ),
          if (_authMode == AuthMode.signup)
            SizedBox(height: _deviceSize.height * 0.02),
          if (_authMode == AuthMode.signup)
            SizedBox(height: _deviceSize.height * 0.02),
          BlocConsumer<LoginBloc, LoginState>(
            bloc: _loginBloc,
            listener: (context, state) {
              if (state is LoginFailure) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      "Error while authenticate!",
                      style: TextStyle(fontSize: 18),
                    ),
                    content: Text(state.rawError),
                    actions: [
                      TextButton(
                        // style: TextButton.styleFrom(
                        //   primary: Colors.black,
                        // ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is LoginLoading) {
                return Column(children: [
                  (_authMode == AuthMode.signup)
                      ? SizedBox(height: _deviceSize.height * 0.04)
                      : SizedBox(height: _deviceSize.height * 0.0),
                  const SpinLoadingIndicator()
                ]);
              } else {
                return Column(children: [
                  _submitButton,
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: _authSwtich,
                  ),
                ]);
              }
            },
          ),
        ],
      ),
    );
  }
}

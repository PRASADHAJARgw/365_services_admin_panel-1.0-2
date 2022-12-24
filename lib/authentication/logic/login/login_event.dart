part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String? phoneNumber;
  final String userEmail;
  final String password;
  final bool isLogin;

  const LoginButtonPressed({
    this.phoneNumber,
    required this.userEmail,
    required this.password,
    required this.isLogin,
  });

  @override
  List<Object> get props => [userEmail, password, isLogin];
}

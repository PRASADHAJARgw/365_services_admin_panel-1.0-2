import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:service365_admin_panel/authentication/logic/authentication/authentication_bloc.dart';
import 'package:service365_admin_panel/authentication/model/token_data_model.dart';
import 'package:service365_admin_panel/authentication/repository/auth_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.authenticationBloc}) : super(LoginInitial()) {
    on<LoginEvent>(
      (event, emit) async {
        final userRepository = AuthenticationRepository();
        if (event is LoginButtonPressed) {
          emit(LoginLoading());

          try {
            final _userCredential = await userRepository.authenticate(
              phoneNumber: event.phoneNumber,
              userEmail: event.userEmail,
              password: event.password,
              isLogin: event.isLogin,
            );
            authenticationBloc.add(
              LoggedIn(
                tokenData: TokenData(token: _userCredential.user!.refreshToken),
              ),
            );
            emit(LoginInitial());
            return;
          } catch (error) {
            if (error is FirebaseException) {
              emit(LoginFailure(rawError: error.message ?? 'Server error'));
            } else {
              emit(const LoginFailure(rawError: 'Something went wrong'));
            }
          }
        }
      },
    );
  }
}

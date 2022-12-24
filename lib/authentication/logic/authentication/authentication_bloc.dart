import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:service365_admin_panel/authentication/model/token_data_model.dart';
import 'package:service365_admin_panel/authentication/service/token_shared_pref.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  bool isLogoutClicked = false;

  AuthenticationBloc() : super(AuthenticationUninitialized()) {
    final _tokenHandler = TokenSharedPref();

    on<AuthenticationEvent>(
      (event, emit) async {
        if (event is AppStarted) {
          await _tokenHandler.hasToken().then((value) async {
            if (value) {
              emit(AuthenticationAuthenticated());
            } else {
              try {
                emit(AuthenticationUnauthenticated());
              } catch (e) {
                emit(AuthenticationUnauthenticated());
              }
            }
          });
        } else if (event is LoggedIn) {
          emit(AuthenticationLoading());
          await _tokenHandler
              .storeToken(event.tokenData)
              .then((value) => emit(AuthenticationAuthenticated()));
        } else if (event is LoggedOut) {
          isLogoutClicked = true;
          emit(AuthenticationLoading());
          await _tokenHandler.deleteToken().whenComplete(
            () async {
              await FirebaseAuth.instance.signOut();
              emit(AuthenticationUnauthenticated());
            },
          );
          emit(AuthenticationUnauthenticated());
        } else if (event is AnonymousLogin) {
          emit(AuthenticationLoading());
          emit(AuthenticatedAnonymously());
        }
      },
    );
  }
}

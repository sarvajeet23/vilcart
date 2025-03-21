import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilcart/view/auth/repository/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.login(
          event.mobileNo,
          event.password,
          rememberMe: event.rememberMe,
        );
        if (success) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure("Invalid credentials"));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(AuthLoggedOut());
    });

    on<CheckLoginStatus>((event, emit) async {
      bool loggedIn = await authRepository.isUserLoggedIn();
      if (loggedIn) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Session expired. Please log in again."));
      }
    });
  }
}

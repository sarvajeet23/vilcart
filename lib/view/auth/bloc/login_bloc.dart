import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilcart/repository/auth_repository.dart';
import 'package:vilcart/view/auth/bloc/login_event.dart';
import 'package:vilcart/view/auth/bloc/login_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.login(
          event.mobileNo,
          event.password,
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
  }
}

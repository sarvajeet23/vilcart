abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String mobileNo;
  final String password;
  final bool rememberMe;

  LoginRequested(this.mobileNo, this.password, this.rememberMe);
}

class CheckLoginStatus extends AuthEvent {} 

class LogoutRequested extends AuthEvent {} 

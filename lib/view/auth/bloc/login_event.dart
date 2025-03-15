abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String mobileNo;
  final String password;
  
  LoginRequested(this.mobileNo, this.password);
}

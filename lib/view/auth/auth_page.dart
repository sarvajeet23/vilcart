import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilcart/view/auth/bloc/login_event.dart'; // make sure this file exports the updated LoginRequested event with 3 parameters
import 'package:vilcart/view/auth/bloc/login_state.dart';
import 'package:vilcart/core/widgets/flex_text_field.dart';
import 'bloc/login_bloc.dart';
import 'package:vilcart/view/auth/repository/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final authRepo = AuthRepository();
    final savedCredentials = await authRepo.getSavedCredentials();
    setState(() {
      mobileController.text = savedCredentials["mobileNo"] ?? "";
      passwordController.text = savedCredentials["password"] ?? "";
      rememberMe = savedCredentials["mobileNo"] != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/bg.png', fit: BoxFit.cover),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Logo
                    Image.asset('assets/logo.png', fit: BoxFit.cover, scale: 2),
                    const SizedBox(height: 30),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/products',
                            );
                          } else if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                FlexTextField(
                                  controller: mobileController,
                                  hintText: "username",
                                  prefixIcon: Icons.person,
                                  color: Colors.black45,
                                  borderColor: Colors.blueGrey.shade100,
                                  iconSize: 20,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Please enter username";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                FlexTextField(
                                  controller: passwordController,
                                  hintText: "Password",
                                  prefixIcon: Icons.lock,
                                  suffixIcon: Icons.visibility,
                                  color: Colors.black45,
                                  borderColor: Colors.blueGrey.shade100,
                                  obscureText: true,
                                  iconSize: 20,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Please enter password";
                                    }
                                    return null;
                                  },
                                ),
                                RememberUser(
                                  onChanged: (val) {
                                    setState(() {
                                      rememberMe = val;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.indigo,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            state is AuthLoading
                                                ? null
                                                : () {
                                                  if (_formKey.currentState
                                                          ?.validate() ??
                                                      false) {
                                                    // Dispatch login event with rememberMe value
                                                    context
                                                        .read<AuthBloc>()
                                                        .add(
                                                          LoginRequested(
                                                            mobileController
                                                                .text,
                                                            passwordController
                                                                .text,
                                                            rememberMe,
                                                          ),
                                                        );
                                                  }
                                                },
                                        child:
                                            state is AuthLoading
                                                ? const CircularProgressIndicator()
                                                : const Text('Login'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RememberUser extends StatefulWidget {
  final Function(bool) onChanged;
  const RememberUser({super.key, required this.onChanged});

  @override
  State<RememberUser> createState() => _RememberUserState();
}

class _RememberUserState extends State<RememberUser> {
  bool checkbox = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checkbox,
          onChanged: (val) {
            setState(() {
              checkbox = val ?? false;
            });
            widget.onChanged(checkbox);
          },
        ),
        const Text('Remember me'),
      ],
    );
  }
}

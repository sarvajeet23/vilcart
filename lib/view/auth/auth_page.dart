import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilcart/view/auth/bloc/login_event.dart';
import 'package:vilcart/view/auth/bloc/login_state.dart';
import 'package:vilcart/widgets/flex_text_field.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/bg.png', fit: BoxFit.cover),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset('assets/logo.png', fit: BoxFit.cover, scale: 2),
                    SizedBox(height: 30),
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
                                SizedBox(height: 15),
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
                                CheckBox(),
                                SizedBox(height: 20),
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
                                                  // Validate the form before login attempt
                                                  if (_formKey.currentState
                                                          ?.validate() ??
                                                      false) {
                                                    context
                                                        .read<AuthBloc>()
                                                        .add(
                                                          LoginRequested(
                                                            mobileController
                                                                .text,
                                                            passwordController
                                                                .text,
                                                          ),
                                                        );
                                                  }
                                                },
                                        child:
                                            state is AuthLoading
                                                ? CircularProgressIndicator()
                                                : Text('Login'),
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

class CheckBox extends StatefulWidget {
  const CheckBox({super.key});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
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
          },
        ),

        Text('Remember me'),
      ],
    );
  }
}

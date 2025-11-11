import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:vietq_hrm/blocs/login/login_bloc.dart';
import 'package:vietq_hrm/blocs/login/login_event.dart';
import 'package:vietq_hrm/blocs/login/login_state.dart';
import 'package:vietq_hrm/configs/apiConfig/auth.api.dart';
import 'package:vietq_hrm/models/loginModels.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _isPasswordVisible = false;
  String _displayText = '';
  String _passwordText = '';

  @override
  void dispose() {
    _controller.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final lift = keyboardHeight > 0 ? 40.0 : 0.0;
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if(state.status.isSuccess){
            CherryToast.success(
                description:  Text("Login successfully", style: TextStyle(color: Colors.black)),
                animationType:  AnimationType.fromTop,
                animationDuration:  Duration(milliseconds:  200),
                autoDismiss:  true

            ).show(context);
            context.go('/');
          }else if(state.status.isFailure){
            print(state.status.isFailure);
            CherryToast.error(
                description:  Text(state.errorMessage as String, style: TextStyle(color: Colors.black)),
                animationType:  AnimationType.fromTop,
                animationDuration:  Duration(milliseconds:  200),
                autoDismiss:  true

            ).show(context);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.only(top: 100, left: 20, right: 10, bottom: 20),
            width: double.infinity,
            // color: Colors.red,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              transform: Matrix4.translationValues(0, -lift, 0),
              curve: Curves.easeOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                    color: Colors.red,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // 👈 cùng bán kính với BoxDecoration
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome Back to', style: textTheme.headlineLarge),
                        Text(
                          'VIET-Q HR Attendee',
                          style: textTheme.headlineLarge?.copyWith(
                            color: Color(0xFFF6C951),
                          ),
                        ),
                        Text(
                          'Hello there, login to continue',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Container(
                        // color: Color(0xFFF6C951),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value) {
                                context.read<LoginBloc>().add(EmailChanged(value));
                              },
                              decoration: InputDecoration(
                                errorText: state.email.displayError != null
                                    ? state.email.error == EmailError.empty
                                    ? 'Email not empty'
                                    : 'Email invalid'
                                    : null,
                                labelText: 'Enter your email address',
                                // hintText: 'e.g., John Doe',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFF6C951),
                                  ), // Border when not focused
                                ),
                                focusColor: Color(0xFFF6C951),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ), // Border when not focused
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // BlocBuilder()
                            TextField(
                              obscureText: !_isPasswordVisible,
                              onChanged: (pass) => context.read<LoginBloc>().add(PasswordChanged(pass)),
                              decoration: InputDecoration(
                                errorText: state.password.displayError != null
                                    ? 'Password must be at least 6 characters'
                                    : null,
                                suffixIcon: IconButton(
                                  icon: _isPasswordVisible
                                      ? SvgPicture.asset('assets/icons/eye.svg')
                                      : SvgPicture.asset('assets/icons/eye_off.svg'),

                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                labelText: 'Enter your password',
                                // hintText: 'e.g., John Doe',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFF6C951),
                                  ), // Border when not focused
                                ),
                                focusColor: Color(0xFFF6C951),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ), // Border when not focused
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state){
                    return Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.zero,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          overlayColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          context.push('/forgot');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: textTheme.bodyLarge?.copyWith(
                            color: Color(0xFFFFBB00),
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    );
                  }),
                  // Trong login_screen.dart
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            overlayColor: Colors.transparent,
                            backgroundColor: Color(0xFFF6C951),
                            foregroundColor: Colors.transparent,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          // onPressed: () {
                          //   AuthApi().login(
                          //     email: _controller.text,
                          //     password: _controllerPassword.text,
                          //   );
                          // },
                          onPressed: state.isValid && !state.status.isInProgress
                              ? () => context.read<LoginBloc>().add(LoginSubmitted())
                              : null,
                          child: state.status.isInProgress
                              ? SizedBox(width: 30, height: 30, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    );
                  })

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

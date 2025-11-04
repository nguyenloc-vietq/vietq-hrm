import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
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

              Container(
                // color: Color(0xFFF6C951),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
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
                      onSubmitted: (value) {
                        setState(() {
                          _displayText = 'Hello, $value!';
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      obscureText: !_isPasswordVisible,
                      controller: _controllerPassword,

                      decoration: InputDecoration(
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
                      onSubmitted: (value) {
                        setState(() {
                          _passwordText = 'Hello, $value!';
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
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
              ),
              Padding(
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
                    onPressed: () {},
                    child: Text(
                      'Login',
                      style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

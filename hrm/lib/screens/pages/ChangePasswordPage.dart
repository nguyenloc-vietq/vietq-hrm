import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:vietq_hrm/blocs/forgot/forgot_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final lift = keyboardHeight > 0 ? 110.0 : 0.0;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            // color: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ).r,
            child: Column(
              children: [
                TextField(
                  style: TextStyle(
                      color: Colors.black // Sets the color of the input text
                  ),
                  obscureText: !_isPasswordVisible,
                  onChanged: (pass) => context
                      .read<ForgotBloc>()
                      .add(PasswordChanged(pass)),
                  decoration: InputDecoration(
                    errorText:
                    true && true != null
                        ? 'Password must be at least 6 characters'
                        : null,
                    suffixIcon: IconButton(
                      icon: _isPasswordVisible
                          ? SvgPicture.asset(
                        'assets/icons/eye.svg',
                      )
                          : SvgPicture.asset(
                        'assets/icons/eye_off.svg',
                      ),

                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                          !_isPasswordVisible;
                        });
                      },
                    ),
                    labelText: 'Enter your old password',
                    // hintText: 'e.g., John Doe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).r,
                      borderSide: BorderSide(
                        width: 2.r,
                        color: Theme.of(context).colorScheme.primary,
                      ), // Border when not focused
                    ),
                    focusColor: Theme.of(context).colorScheme.primary,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).r,
                      borderSide: BorderSide(
                        width: 1.r,
                        color: Colors.grey,
                      ), // Border when not focused
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // BlocBuilder()
                TextField(
                  style: TextStyle(
                      color: Colors.black // Sets the color of the input text
                  ),
                  obscureText: !_isPasswordVisible,
                  onChanged: (pass) => context
                      .read<ForgotBloc>()
                      .add(PasswordChanged(pass)),
                  decoration: InputDecoration(
                    errorText:
                    true && true != null
                        ? 'Password must be at least 6 characters'
                        : null,
                    suffixIcon: IconButton(
                      icon: _isPasswordVisible
                          ? SvgPicture.asset(
                        'assets/icons/eye.svg',
                      )
                          : SvgPicture.asset(
                        'assets/icons/eye_off.svg',
                      ),

                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                          !_isPasswordVisible;
                        });
                      },
                    ),
                    labelText: 'Enter your password',
                    // hintText: 'e.g., John Doe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).r,
                      borderSide: BorderSide(
                        width: 2.r,
                        color: Theme.of(context).colorScheme.primary,
                      ), // Border when not focused
                    ),
                    focusColor: Theme.of(context).colorScheme.primary,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).r,
                      borderSide: BorderSide(
                        width: 1.r,
                        color: Colors.grey,
                      ), // Border when not focused
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  style: TextStyle(
                      color: Colors.black// Sets the color of the input text
                  ),
                  obscureText: !_isPasswordVisible,
                  onChanged: (pass) => {
                    context.read<ForgotBloc>().add(
                      PasswordComfrimChange(pass),
                    ),
                  },
                  decoration: InputDecoration(
                    errorText:
                    true ? true &&
                        true == null
                        ? null : 'Password không khớp'
                        : null,
                    suffixIcon: IconButton(
                      icon: _isPasswordVisible
                          ? SvgPicture.asset(
                        'assets/icons/eye.svg',
                      )
                          : SvgPicture.asset(
                        'assets/icons/eye_off.svg',
                      ),

                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                          !_isPasswordVisible;
                        });
                      },
                    ),
                    labelText: 'Enter your password again',
                    // hintText: 'e.g., John Doe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).r,
                      borderSide: BorderSide(
                        width: 2.r,
                        color: Theme.of(context).colorScheme.primary,
                      ), // Border when not focused
                    ),
                    focusColor: Theme.of(context).colorScheme.primary,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).r,
                      borderSide: BorderSide(
                        width: 1.r,
                        color: Colors.grey,
                      ), // Border when not focused
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ).r,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                true && true
                    ? () => {
                  context.read<ForgotBloc>().add(
                    ChangePasswordSubmitted(),
                  ),
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20).r,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ).r,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: false
                    ? SizedBox(
                  width: 30.w,
                  height: 30.h,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.r,
                  ),
                )
                    : Text(
                  'Change password',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

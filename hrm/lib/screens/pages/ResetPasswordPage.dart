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
import 'package:vietq_hrm/models/forgot.models.dart';
import 'package:vietq_hrm/widgets/components/pinput.widget.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final lift = keyboardHeight > 0 ? 110.0 : 0.0;
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<ForgotBloc, ForgotState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          CherryToast.success(
            description: Text(
              "Change password successfully",
              style: TextStyle(color: Colors.black),
            ),
            animationType: AnimationType.fromTop,
            animationDuration: Duration(milliseconds: 200),
            autoDismiss: true,
          ).show(context);
          context.push('/');
        } else if (state.status.isFailure) {
          CherryToast.error(
            description: Text(
              state.errorMessage.toString(),
              style: TextStyle(color: Colors.black),
            ),
            animationType: AnimationType.fromTop,
            animationDuration: Duration(milliseconds: 200),
            autoDismiss: true,
          ).show(context);
        }
      },
      child: BlocBuilder<ForgotBloc, ForgotState>(
        builder: (context, state) {
          print("#==========> CHECK ${state.passwordComfrim}");
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(0, -lift, 0),
                  curve: Curves.easeInSine,
                  child: Container(
                    padding: EdgeInsets.only(top: 210).r,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          '${dotenv.env['IMAGE_ENDPOINT']}background/background-login.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),

                    // color: Colors.red,
                    child: Container(
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10).r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30).r,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10).r,
                            child: Column(
                              spacing: 10.r,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Change Password',
                                  style: textTheme.headlineLarge,
                                ),
                                Text(
                                  'Enter your new password',
                                  style: textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            width: double.infinity,
                            height: 200.h,
                            child: Center(
                              child: SvgPicture.asset(
                                alignment: Alignment.center,
                                "assets/icons/undraw_enter-password.svg",
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),

                          Container(
                            // color: Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ).r,
                            child: Column(
                              children: [
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
                                        state.password.value.isNotEmpty && state.password.displayError != null
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
                                    state.password.value.isNotEmpty ? state.passwordComfrim.isValid &&
                                            state.passwordComfrim.error == null
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
                                    state.isValid && !state.status.isInProgress
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
                                child: state.status.isInProgress
                                    ? SizedBox(
                                        width: 30.w,
                                        height: 30.h,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.r,
                                        ),
                                      )
                                    : Text(
                                        'Continue',
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
                    ),
                  ),
                ),
                Positioned(
                  top: 50.h,
                  left: 10.w,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(0, -lift, 0),
                    // lift là biến double
                    curve: Curves.easeInSine,
                    child: IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 150.h,
                  left: 10.w,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(0, -lift, 0),
                    // lift là biến double
                    curve: Curves.easeInSine,
                    padding: const EdgeInsets.only(left: 10).r,
                    child: Text(
                      "Password Reset",
                      style: textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 50.r,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

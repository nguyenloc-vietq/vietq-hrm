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
import 'package:vietq_hrm/widgets/components/otpResend.widget.dart';
import 'package:vietq_hrm/widgets/components/pinput.widget.dart';

class ValidateOtpPage extends StatefulWidget {
  const ValidateOtpPage({super.key});

  @override
  State<ValidateOtpPage> createState() => _ValidateOtpPageState();
}

class _ValidateOtpPageState extends State<ValidateOtpPage> {
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
              "Verify OTP successfully",
              style: TextStyle(color: Colors.black),
            ),
            animationType: AnimationType.fromTop,
            animationDuration: Duration(milliseconds: 200),
            autoDismiss: true,
          ).show(context);
          context.push('/reset_password');
        }
        if(state.status.isFailure){
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
                                spacing: 10.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Validate OTP',
                                    style: textTheme.headlineLarge,
                                  ),
                                  Text(
                                    'Please enter the OTP code sent to your email,',
                                    style: textTheme.bodySmall,
                                  ),
                                  Text(
                                    state.email.value,
                                    style: textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary
                                    ),
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
                                  "assets/icons/undraw_forgot_password.svg",
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            PinPutOtp(),

                            OtpResendWidget()
                            // Trong login_screen.dart
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
                        child: IconButton(onPressed: () {
                          context.pop();
                        }, icon: Icon(Icons.arrow_back_ios_new_rounded), color: Colors.white,),
                      )),
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
          }
      ),
    );
  }
}

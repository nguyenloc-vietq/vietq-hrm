import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:vietq_hrm/blocs/forgot/forgot_bloc.dart';

class PinPutOtp extends StatefulWidget {
  const PinPutOtp({super.key});

  @override
  State<PinPutOtp> createState() => _PinPutOtpState();
}

class _PinPutOtpState extends State<PinPutOtp> {
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusedBorderColor = Theme.of(context).colorScheme.primary;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Colors.grey;

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19).r,
        border: Border.all(color: borderColor),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20.h,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              length: 6,
              controller: pinController,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => SizedBox(width: 10.h),
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              onCompleted: (pin) {
                debugPrint('OTP Completed: $pin');
              },
              onChanged: (pin) {
                context.read<ForgotBloc>().add(OtpChanged(pin));
              },
              cursor: Column(
                spacing: 10.h,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9).r,
                    width: 22.w,
                    height: 1.h,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(19).r,
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19).r,
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          BlocBuilder<ForgotBloc, ForgotState>(
            builder: (context, state) {
              final isEnabled = state.otp.isValid && !state.status.isInProgress;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10).r,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isEnabled
                        ? () {
                      context.read<ForgotBloc>().add(VerifyOtpSubmitted());
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
                      'Verify OTP',
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

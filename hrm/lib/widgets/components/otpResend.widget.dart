import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietq_hrm/blocs/forgot/forgot_bloc.dart';

class OtpResendWidget extends StatefulWidget {
  const OtpResendWidget({super.key});

  @override
  State<OtpResendWidget> createState() => _OtpResendWidgetState();
}

class _OtpResendWidgetState extends State<OtpResendWidget> {
  static const int _startTime = 120; // 2 phút
  int _secondsLeft = _startTime;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsLeft = _startTime;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _canResend = true;
          _secondsLeft = 0;
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    String countdownText =
    _canResend ? "" : "($_secondsLeft s)"; // hiển thị countdown

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("You did not receive the code? ", style: textTheme.bodySmall),
        BlocBuilder<ForgotBloc, ForgotState>(
          builder: (context, state) {
            return TextButton(
              onPressed: () {
                if (_canResend) {
                  context.read<ForgotBloc>().add(ForgotResent());
                  print("Resending OTP...");
                  _startTimer(); // reset countdown
                }
              },
              child: Text(
                "Resend $countdownText",
                style: textTheme.bodySmall?.copyWith( fontWeight: FontWeight.w600,
                  color: _canResend ? const Color(0xFFF6C951) : Colors.grey,
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}

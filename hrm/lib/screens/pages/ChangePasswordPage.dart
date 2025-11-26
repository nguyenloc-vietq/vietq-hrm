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
import 'package:vietq_hrm/configs/apiConfig/user.api.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmVisible = false;

  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isSubmitting = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await UserApi().changePassword(
        _oldPasswordController.text,
        _passwordController.text,
      );
      //toast success
      CherryToast.success(
        toastPosition: Position.bottom,
        description: Text(
          "Password changed successfully",
          style: TextStyle(color: Colors.black)
        ),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 200),
        autoDismiss: true,
      ).show(context);
    } catch (error) {
      CherryToast.error(
        toastPosition: Position.bottom,
        description: Text(
          error.toString(),
          style: TextStyle(color: Colors.black),
        ),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 200),
        autoDismiss: true,
      ).show(context);
    }

    setState(() => _isSubmitting = false);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final lift = keyboardHeight > 0 ? 110.0 : 0.0;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode
          ? Theme.of(context).appBarTheme.backgroundColor
          : Colors.white,
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              /// Old password
              TextFormField(
                controller: _oldPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  // hintText: 'Old password',
                  labelText: 'Old password',
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      color: isDarkMode ? Colors.white : Colors.black,
                      _isPasswordVisible
                          ? 'assets/icons/eye.svg'
                          : 'assets/icons/eye_off.svg',
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20).r,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20).r,
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey : Colors.black,
                    ),
                  ),
                  floatingLabelStyle: MaterialStateTextStyle.resolveWith((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.focused)) {
                      return TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      );
                    }
                    return TextStyle(color: Colors.grey);
                  }),
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey : Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.h),

              /// New password
              TextFormField(
                controller: _passwordController,
                obscureText: !_isNewPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'New password',
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      color: isDarkMode ? Colors.white : Colors.black,

                      _isNewPasswordVisible
                          ? 'assets/icons/eye.svg'
                          : 'assets/icons/eye_off.svg',
                    ),
                    onPressed: () => setState(
                      () => _isNewPasswordVisible = !_isNewPasswordVisible,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20).r,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20).r,
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey : Colors.black,
                    ),
                  ),
                  floatingLabelStyle: MaterialStateTextStyle.resolveWith((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.focused)) {
                      return TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      );
                    }
                    return TextStyle(color: Colors.grey);
                  }),
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey : Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  if (!RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
                  ).hasMatch(value)) {
                    return 'Password must be at least 6 characters,\ninclude upper, lower, number and symbol';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.h),

              /// Confirm password
              TextFormField(
                controller: _confirmController,
                obscureText: !_isConfirmVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      color: isDarkMode ? Colors.white : Colors.black,
                      _isConfirmVisible
                          ? 'assets/icons/eye.svg'
                          : 'assets/icons/eye_off.svg',
                    ),
                    onPressed: () =>
                        setState(() => _isConfirmVisible = !_isConfirmVisible),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20).r,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20).r,
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey : Colors.black,
                    ),
                  ),
                  floatingLabelStyle: MaterialStateTextStyle.resolveWith((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.focused)) {
                      return TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      );
                    }
                    return TextStyle(color: Colors.grey);
                  }),
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey : Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              SizedBox(height: 30.h),

              /// Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _submit();
                          }
                        },
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
                  child: _isSubmitting
                      ? SizedBox(
                          width: 25.w,
                          height: 25.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
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
            ],
          ),
        ),
      ),
    );
  }
}

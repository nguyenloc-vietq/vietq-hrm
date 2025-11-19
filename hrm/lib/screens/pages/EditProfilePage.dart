import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vietq_hrm/blocs/user/user_bloc.dart';
import 'package:formz/formz.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isInitialized = false;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, String? errorText, [String? hintText]) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      errorText: errorText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(width: 2, color: Color(0xFFF6C951)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(width: 1, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded && !_isInitialized) {
          _emailController.text = state.user.email ?? '';
          _fullNameController.text = state.user.fullName ?? '';
          _phoneController.text = state.user.phone ?? '';
          _addressController.text = state.user.address ?? '';
          _isInitialized = true;
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0).r,
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email', null, state is UserLoaded ? state.user.email : null),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty ? 'Email not empty' : null,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: _inputDecoration('Full Name', null, state is UserLoaded ? state.user.fullName : null),
                    validator: (value) => value == null || value.isEmpty ? 'Full Name not empty' : null,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration('Phone', null, state is UserLoaded ? state.user.phone : null),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.isEmpty ? 'Phone not empty' : null,
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _addressController,
                    decoration: _inputDecoration('Address', null, state is UserLoaded ? state.user.address : null),
                    validator: (value) => value == null || value.isEmpty ? 'Address not empty' : null,
                  ),
                   SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text;
                          final fullName = _fullNameController.text;
                          final phone = _phoneController.text;
                          final address = _addressController.text;

                          context.read<UserBloc>().add(UpdateUserEvent(email: email, phone: phone, fullName: fullName, address: address));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15).r,
                        backgroundColor: const Color(0xFFF6C951),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20).r),
                      ),
                      child: Text('Update Profile', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

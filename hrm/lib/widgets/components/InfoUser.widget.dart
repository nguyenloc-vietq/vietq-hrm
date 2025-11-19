import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vietq_hrm/blocs/user/user_bloc.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/widgets/components/AvatarPicker.widget.dart';

class InfoUserWidget extends StatefulWidget {
  const InfoUserWidget({super.key});

  @override
  State<InfoUserWidget> createState() => _InfoUserWidgetState();
}

class _InfoUserWidgetState extends State<InfoUserWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return Skeletonizer(
            effect: PulseEffect(),
            enabled: true,
            child: Container(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        padding: const EdgeInsets.all(5).r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF6C951),
                            width: 5.w,
                          ),
                        ),
                        child: Skeleton.unite(child: CircleAvatar(radius: 50.r)),
                      ),
                      Positioned(
                        bottom: -5.h,
                        right: -5.w,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(6).r,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ).r,
                              border: Border.all(color: Colors.white, width: 2.r),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 25.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Name + Job
                  Text("fullName", style: textTheme.headlineMedium),
                  SizedBox(height: 10.h),

                  Text("position", style: textTheme.bodyMedium),

                  SizedBox(height: 20.h),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push("/edit-profile", extra: "Edit profile");
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15).r,
                        backgroundColor: Color(0xFFF6C951),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20).r,
                        ),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is UserLoaded) {
          final fullName = state.user.fullName ?? '';
          final position =
              state.user.userProfessionals?.first.position ?? 'No position';
          final avatarUrl = state.user.avatar ?? '';
          return Container(
            child: Column(
              children: [
                AvatarPicker(
                  avatarUrl: avatarUrl,
                  onImageSelected: (image) async {
                    FormData formData = FormData.fromMap({
                      "avatar": await MultipartFile.fromFile(
                        image.path,
                        filename: "avatar.png",
                      ),
                    });
                    context.read<UserBloc>().add(
                      UpdateAvatarEvent(data: formData),
                    );
                  },
                ),

                SizedBox(height: 16.h),

                // Name + Job
                Text(fullName, style: textTheme.headlineMedium),
                SizedBox(height: 10.h),

                Text(position, style: textTheme.bodyMedium),

                SizedBox(height: 20.h),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push("/edit-profile", extra: "Edit profile");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15).r,
                      backgroundColor: Color(0xFFF6C951),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20).r,
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('User not found...!'));
      },
    );
  }
}

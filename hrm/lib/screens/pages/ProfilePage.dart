import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restart_app/restart_app.dart';
import 'package:vietq_hrm/blocs/blocManager/bloc_manager.dart';
import 'package:vietq_hrm/configs/apiConfig/auth.api.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/main.dart';
import 'package:vietq_hrm/routers/router.config.dart';
import 'package:vietq_hrm/routers/routes.config.dart';
import 'package:vietq_hrm/widgets/components/InfoUser.widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState(){
    super.initState();
    AuthApi().getListShift();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0).r,
            child: Column(
              children: [
                 SizedBox(height: 20.h),
          
                // Avatar + Edit icon
                InfoUserWidget(),
          
                 SizedBox(height: 30.h),
          
                // Menu List
                 ListView.separated(
                   shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ListDetailProfileRouter.length, // Number of items in the list
                    itemBuilder: (BuildContext context, int index) {
                      if(ListDetailProfileRouter[index].route == '/logout') {
                        return ElevatedButton(
                          onPressed: () {
                            SharedPreferencesConfig.delete('users');
                            SharedPreferencesConfig.delete('themeColor');
                            // BlocManager.closeAllBlocs(context);
                            context.go('/login');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            overlayColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10).r,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50.withAlpha(20),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.red.shade50.withAlpha(20)),
                                  ),
                                  width: 50.w,
                                  height: 50.h,
                                  child: Padding(padding: EdgeInsets.all(10).r,
                                    child: ListDetailProfileRouter[index].icon,
                                  ),
                                ),
                                SizedBox(width: 20.w,),
                                Text(ListDetailProfileRouter[index].name,
                                  style: textTheme.bodyLarge?.copyWith(color: Colors.red),),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return ElevatedButton(
                            onPressed: () {
                              print('≠≠≠≠≠≠≠≠≠≠ ${ListDetailProfileRouter[index].route}');
                              context.push('${ListDetailProfileRouter[index].route}', extra: ListDetailProfileRouter[index].name);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              overlayColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10).r,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200.withAlpha(20),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey.shade200.withAlpha(20)),
                                  ),
                                  width: 50.w,
                                  height: 50.h,
                                  child: Padding(padding: EdgeInsets.all(10).r,
                                    child: ListDetailProfileRouter[index].icon,
                                  ),
                                ),
                                SizedBox(width: 20.w,),
                                Text(ListDetailProfileRouter[index].name,
                                  style: textTheme.bodyLarge,),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey,),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Colors.grey.shade200,
                        thickness: 1,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm tiện ích để tạo menu item
  Widget _buildMenuItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey[800]),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {},
        ),
        const Divider(height: 1),
      ],
    );
  }
}




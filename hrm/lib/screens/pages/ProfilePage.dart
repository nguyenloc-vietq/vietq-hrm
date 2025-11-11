import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:vietq_hrm/configs/apiConfig/auth.api.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/routers/router.config.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
          
                // Avatar + Edit icon
                Stack(
                  alignment: Alignment.bottomRight,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        // color: Color(0xFFF6C951),
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFF6C951), width: 5),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          '${dotenv.env['IMAGE_ENDPOINT']}avatar/avatar-1762761355725-290262777.png', // ảnh mẫu
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 16),
          
                // Name + Job
                Text(
                  "Ho Nguyen Loc",
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
          
                Text(
                  "Software Engineer",
                  style: textTheme.bodyMedium ,
          
                ),
          
                const SizedBox(height: 20),
          
                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Color(0xFFF6C951),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
          
                const SizedBox(height: 30),
          
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
                            context.go('/');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            overlayColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.red.shade50),
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: Padding(padding: EdgeInsets.all(10),
                                    child: ListDetailProfileRouter[index].icon,
                                  ),
                                ),
                                SizedBox(width: 20,),
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: Padding(padding: EdgeInsets.all(10),
                                    child: ListDetailProfileRouter[index].icon,
                                  ),
                                ),
                                SizedBox(width: 20,),
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




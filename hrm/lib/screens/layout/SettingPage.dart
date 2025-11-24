import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/services/push_notification/notification.service.dart';
import 'package:vietq_hrm/widgets/components/ChangePassword.widget.dart';
import 'package:vietq_hrm/widgets/customWidgets/ThemePicker.widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  void _loadSetting() async {
    _isEnabled = await SharedPreferencesConfig.allowNotification;
    setState(() {});
  }

  void _onChanged(bool value) async {
    setState(() => _isEnabled = value);
    print("#==========> ${value}");
    SharedPreferencesConfig.allowNotification = value;
    if(!value){
      NotificationService().deleteToken();
    }
    else{
      NotificationService().getToken();
    }
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SwitchListTile(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              activeColor: Colors.transparent,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              inactiveTrackColor: Colors.grey[200],
              title: Text("Push Notifications", style: textTheme.headlineSmall),
              value: _isEnabled,
              onChanged: _onChanged,
            ),
            ChangePasswordWidget(),
            PaletteColorPicker()
          ],
        ),
      ),
    );
  }
}

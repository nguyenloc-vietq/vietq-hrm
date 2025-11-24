import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vietq_hrm/blocs/theme/theme_bloc.dart';

class PaletteColorPicker extends StatelessWidget {
  // Danh sách màu sẵn
  final List<Color> colors = [
    Color(0xFFA1BC98),
    Color(0xFFF6C951),
    Color(0xFF0046FF),
    Color(0xFFFF8040),
    Color(0xFFE9A5F1),
    Color(0xFFFF8080),
    Color(0xFF5D688A),
    Color(0xFF5FC38F),
    Color(0xFFFFB38E),
  ];

  @override
  Widget build(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();

    return Padding(
      padding: const EdgeInsets.all(18),
      child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              elevation: 0,
              overlayColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
                  title: Text('Theme', style: Theme.of(context).textTheme.headlineMedium),
                  content: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: colors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            themeBloc.add(ChangePrimaryColor(color));
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5).r,
                              border: Border.all(
                                color: themeBloc.state.primaryColor == color
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Đóng'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Theme", textAlign: TextAlign.left, style: Theme.of(context).textTheme.headlineSmall),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: themeBloc.state.primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5).r,
                    border: Border.all(
                      color: themeBloc.state.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ],
            )
      ),
    );
  }
}

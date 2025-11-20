import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';

// State
class ThemeState {
  final Color primaryColor;
  final Color progressIndicatorColor;

  ThemeState({required this.primaryColor, required this.progressIndicatorColor});
}

// Event
abstract class ThemeEvent {}

class ChangePrimaryColor extends ThemeEvent {
  final Color color;
  ChangePrimaryColor(this.color);
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {ThemeBloc()
      : super(ThemeState(
    primaryColor: SharedPreferencesConfig.themeColor,
    progressIndicatorColor: SharedPreferencesConfig.themeColor,
  )) {
    on<ChangePrimaryColor>((event, emit) {
      SharedPreferencesConfig.themeColor = event.color;
      emit(ThemeState(
        primaryColor: event.color,
        progressIndicatorColor: event.color,
      ));
    });
  }
}

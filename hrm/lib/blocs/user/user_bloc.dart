import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:vietq_hrm/configs/apiConfig/user.api.dart';
import 'package:vietq_hrm/models/user.models.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_form_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApi _userApi;
  UserModels? _user;
  UserBloc(this._userApi) : super(UserInitial()) {
    on<LoadUserEvent>(_loadUser);
    on<UpdateUserEvent>(_updateUser);
    on<UpdateAvatarEvent>(_updateAvatarEvent);
  }
  Future<void> _loadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final userDataProfile = await _userApi.getProfile();
      _user = userDataProfile;
      emit(UserLoaded(user: _user ?? userDataProfile));
    } catch (e) {
      print(e);
      emit(UserError(message: e.toString()));
    }
  }
  Future<void> _updateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await _userApi.updateProfile(name: event.fullName, email: event.email, phone: event.phone, address: event.address);
      _user?.phone = event.phone;
      _user?.fullName = event.fullName;
      _user?.email = event.email;
      _user?.address = event.address;
      emit(UserLoaded(user: _user as UserModels));
    } catch (e) {
      print(e);
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _updateAvatarEvent(UpdateAvatarEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final data = await _userApi.updateAvatar(event.data);
      _user?.avatar = data['fileName'];
      emit(UserLoaded(user: _user as UserModels));
    } catch (e) {
      print(e);
      emit(UserError(message: e.toString()));
    }
  }
}

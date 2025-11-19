part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUserEvent extends UserEvent {
}

class UpdateUserEvent extends UserEvent {
  final String email;
  final String phone;
  final String fullName;
  final String address;
  const UpdateUserEvent({required this.email, required this.phone, required this.fullName, required this.address});
}

class UpdateAvatarEvent extends UserEvent {
  final FormData data;
  const UpdateAvatarEvent({required this.data});
}

class EmailChangedEvent extends UserEvent {
  final String email;
  const EmailChangedEvent({required this.email});
}

class PhoneChangedEvent extends UserEvent {
  final String phone;
  const PhoneChangedEvent({required this.phone});
}

class FullNameChangedEvent extends UserEvent {
  final String fullName;
  const FullNameChangedEvent({required this.fullName});
}

class AddressChangedEvent extends UserEvent {
  final String address;
  const AddressChangedEvent({required this.address});
}


//  email: string;
//   @IsString()
//   phone: string;
//   @IsString()
//   fullName: string;
//   @IsString()
//   address: string;
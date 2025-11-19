part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModels user;

  const UserLoaded({
    required this.user,
  });

  UserLoaded copyWith({
    final UserModels? user
  }) {
    return UserLoaded(
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}




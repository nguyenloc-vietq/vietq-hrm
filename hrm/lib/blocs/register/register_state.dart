part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, success, failure, actionInProgress, actionSuccess, actionFailure }

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.isAdmin = false,
    this.items = const <dynamic>[],
    this.summary = const <String, dynamic>{},
    this.tabIndex = 0,
    this.errorMessage,
  });

  final RegisterStatus status;
  final bool isAdmin;
  final List<dynamic> items;
  final Map<String, dynamic> summary;
  final int tabIndex;
  final String? errorMessage;

  RegisterState copyWith({
    RegisterStatus? status,
    bool? isAdmin,
    List<dynamic>? items,
    Map<String, dynamic>? summary,
    int? tabIndex,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      isAdmin: isAdmin ?? this.isAdmin,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      tabIndex: tabIndex ?? this.tabIndex,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isAdmin, items, summary, tabIndex, errorMessage];
}

part of 'change_disability_bloc.dart';


abstract class ChangeDisabilityEvent extends Equatable {
  const ChangeDisabilityEvent();

  @override
  List<Object?> get props => [];
}

class UpdateDisabilityEvent extends ChangeDisabilityEvent {
  final String userId;
  final String? disability;

  const UpdateDisabilityEvent({
    required this.userId,
    required this.disability,
  });

  @override
  List<Object?> get props => [userId, disability];
}
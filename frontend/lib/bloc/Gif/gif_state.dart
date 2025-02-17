import 'package:equatable/equatable.dart';

abstract class GifState extends Equatable {
  const GifState();

  @override
  List<Object> get props => [];
}

class GifInitial extends GifState {}

class GifLoading extends GifState {}

class GifLoaded extends GifState {
  final String gifUrl;
  final String phrase;

  const GifLoaded({required this.gifUrl, required this.phrase});

  @override
  List<Object> get props => [gifUrl, phrase];
}

class GifError extends GifState {
  final String message;

  const GifError({required this.message});

  @override
  List<Object> get props => [message];
}

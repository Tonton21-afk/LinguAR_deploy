import 'package:equatable/equatable.dart';

abstract class GifEvent extends Equatable {
  const GifEvent();

  @override
  List<Object> get props => [];
}

class FetchGif extends GifEvent {
  final String phrase;
  final String publicId;

  const FetchGif({required this.phrase, required this.publicId});

  @override
  List<Object> get props => [phrase, publicId];
}

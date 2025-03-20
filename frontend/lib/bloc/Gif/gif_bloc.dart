import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingua_arv1/repositories/Config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:lingua_arv1/bloc/Gif/gif_event.dart';
import 'package:lingua_arv1/bloc/Gif/gif_state.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  final Map<String, String> _gifCache = {};

  GifBloc() : super(GifInitial()) {
    on<FetchGif>(_onFetchGif);
    on<ResetGifState>(_onResetGifState); // Add this handler
  }

  Future<void> _onFetchGif(FetchGif event, Emitter<GifState> emit) async {
    if (_gifCache.containsKey(event.publicId)) {
      print("Loading cached GIF for: ${event.phrase}");
      emit(GifLoaded(gifUrl: _gifCache[event.publicId]!, phrase: event.phrase));
      return;
    }

    emit(GifLoading());

    String url = "${Cloud_url.baseURL}?public_id=${event.publicId}";

    print("Fetching GIF for: ${event.phrase}");
    print("Generated URL: $url");

    try {
      final response = await http.get(Uri.parse(url)).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String gifUrl = jsonResponse['gif_url'];

        _gifCache[event.publicId] = gifUrl; //for caching

        print("Response received: $jsonResponse");
        emit(GifLoaded(gifUrl: gifUrl, phrase: event.phrase));
      } else {
        print("Failed request. Status Code: ${response.statusCode}");
        emit(GifError(message: 'Failed to fetch GIF from server.'));
      }
    } catch (error) {
      print("Error occurred: $error");
      emit(GifError(message: 'Error occurred: $error'));
    }
  }

  void _onResetGifState(ResetGifState event, Emitter<GifState> emit) {
    emit(GifInitial()); // Reset the state to initial
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'guide_event.dart';
import 'guide_state.dart';

class GuideBloc extends Bloc<GuideEvent, GuideState> {
  GuideBloc() : super(GuideInitial()) {
    on<SearchQueryChanged>((event, emit) {
      emit(GuideSearchState(event.query));
    });
  }
}

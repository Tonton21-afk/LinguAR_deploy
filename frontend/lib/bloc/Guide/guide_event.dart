abstract class GuideEvent {}

class SearchQueryChanged extends GuideEvent {
  final String query;
  SearchQueryChanged(this.query);
}

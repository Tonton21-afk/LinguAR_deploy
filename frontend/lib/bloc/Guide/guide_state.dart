abstract class GuideState {}

class GuideInitial extends GuideState {}

class GuideSearchState extends GuideState {
  final String query;
  GuideSearchState(this.query);
}

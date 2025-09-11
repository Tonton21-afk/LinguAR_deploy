import 'package:shared_preferences/shared_preferences.dart';

class ProgressStore {
  static const _kPrefix = 'progress_';

  
  static const fslTranslateTrack = 'fsl_translate_track';

  
  static Future<int> getCurrentIndex(String category) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_kPrefix${category}_currentIndex') ?? 0;
  }

  static Future<void> setCurrentIndex(String category, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_kPrefix${category}_currentIndex', index);
  }

  static Future<void> setCompleted(String category, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_kPrefix${category}_completed', value);
  }

  static Future<bool> isCompleted(String category) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_kPrefix${category}_completed') ?? false;
  }

 
  static Future<int> getTranslateIndex() =>
      getCurrentIndex(fslTranslateTrack);

  static Future<void> setTranslateIndex(int index) =>
      setCurrentIndex(fslTranslateTrack, index);

  static Future<void> bumpTranslateIndexIfHigher(int nextIndex) async {
    final cur = await getTranslateIndex();
    if (nextIndex > cur) {
      await setTranslateIndex(nextIndex);
    }
  }

  static Future<void> resetTranslate() => setTranslateIndex(0);
}

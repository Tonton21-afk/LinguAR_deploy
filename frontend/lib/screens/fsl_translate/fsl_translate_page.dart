import 'package:flutter/material.dart';
import 'package:lingua_arv1/Widgets/ChapterTimelineList.dart';
import 'package:lingua_arv1/Widgets/unitHeader.dart';
import 'package:lingua_arv1/screens/fsl_Quiz/lesson_flow_page.dart';
import 'package:lingua_arv1/services/progress_store.dart';

class FSLTranslatePage extends StatefulWidget {
  @override
  _FSLTranslatePageState createState() => _FSLTranslatePageState();
}

class _FSLTranslatePageState extends State<FSLTranslatePage> {
  static const String _trackKey = 'fsl_translate_track';

  late final ScrollController _scrollController;
  Color _appBarColor = const Color(0xFFFEFFFE);
  bool _isScrolled = false;

  int _currentIndex = 0;

  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Daily Communication',
      'description': 'Essential phrases for everyday conversations.',
      'page':
          const LessonFlowPage(category: "Daily Communication & Basic Phrases"),
    },
    {
      'title': 'Family',
      'description': 'Connect with loved ones.',
      'page': const LessonFlowPage(category: "Family"),
    },
    {
      'title': 'Relationships',
      'description': 'Express feelings.',
      'page': const LessonFlowPage(
          category: "Relationships"), // <-- no leading space
    },
    {
      'title': 'Travel, Food, and Environment',
      'description': 'Essential phrases for Travel',
      'page': const LessonFlowPage(category: "Travel, Food, and Environment"),
    },
    {
      'title': 'Learning, Work, and Technology',
      'description':
          'Communicate in academic, professional, and digital settings.',
      'page': const LessonFlowPage(category: "Learning, Work & Technology"),
    },
    {
      'title': 'Colors, numbers & Alphabet',
      'description': 'Basics of FSL.',
      'page': const LessonFlowPage(category: "Colors, numbers & Alphabet"),
    },
    {
      'title': 'Interactive Learning and Emergency',
      'description':
          'Engage in learning activities and handle urgent situations.',
      'page': const LessonFlowPage(category: "Emergency"),
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final idx = await ProgressStore.getCurrentIndex(_trackKey);
    if (!mounted) return;
    setState(() => _currentIndex = idx.clamp(0, topics.length - 1));
  }

  void _onScroll() {
    final now = _scrollController.hasClients && _scrollController.offset > 50;
    if (now != _isScrolled) setState(() => _isScrolled = now);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _showLockedSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Finish the previous lesson to unlock this one.'),
        duration: Duration(milliseconds: 1400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _appBarColor = _isScrolled
        ? const Color(0xFF4A90E2)
        : (isDark ? const Color(0xFF1D1D1D) : const Color(0xFFFEFFFE));

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF273236) : const Color(0xFFFEFFFE),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: _appBarColor,
            scrolledUnderElevation: 4,
            expandedHeight: kToolbarHeight,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Filipino Sign Language Lessons',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  color: isDark
                      ? Colors.white
                      : (_isScrolled ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        ],
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              UnitHeader(
                title: 'Chapter: Filipino Sign Language Lessons',
                currentIndex: _currentIndex,
                total: topics.length,
                dense: true,
                padding: const EdgeInsets.fromLTRB(
                    32, 8, 16, 10), 
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ChapterTimelineList(
                    topics: topics,
                    currentIndex: _currentIndex,
                    onOpen: (index, topic) async {
                      if (index > _currentIndex) {
                        _showLockedSnack();
                        return;
                      }

                      final bool? completed =
                          await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                            builder: (_) => topic['page'] as Widget),
                      );

                      if (completed == true) {
                        final next = (_currentIndex < topics.length - 1)
                            ? _currentIndex + 1
                            : _currentIndex;
                        if (next != _currentIndex) {
                          await ProgressStore.setCurrentIndex(_trackKey, next);
                          await _loadProgress();
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

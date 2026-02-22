import 'dart:ui';
import 'package:flutter/material.dart';

import '../model_classes/activity_model.dart';
import '../model_classes/quote_model.dart';
import '../model_classes/story_model_class.dart';

class EmotionViewer extends StatefulWidget {
  final List<dynamic> items;

  const EmotionViewer({super.key, required this.items});

  @override
  State<EmotionViewer> createState() => _EmotionViewerState();
}

class _EmotionViewerState extends State<EmotionViewer> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  Widget _tag(String? text) {
    if (text == null || text.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),
      body: Stack(
        children: [
          _background(),

          PageView.builder(
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => currentIndex = i),
            itemBuilder: (_, index) {
              final item = widget.items[index];

              if (item is QuoteModel) {
                return _quoteView(item);
              } else if (item is StoryModel) {
                return _storyView(item);
              } else if (item is ActivityModel) {
                return _activityView(item);
              } else {
                return const SizedBox();
              }
            },
          ),

          // Close
          Positioned(
            top: 50,
            right: 20,
            child: _glassIcon(
              icon: Icons.close,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- VIEW TYPES ----------

  Widget _quoteView(QuoteModel q) {
    return _centerCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '"${q.text}"',
            style: _titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (q.author != null)
            Text("- ${q.author}",
                style: _subStyle, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _storyView(StoryModel s) {
    return _centerCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(s.title ?? "", style: _titleStyle),
          const SizedBox(height: 16),
          Text(s.content ?? "", style: _bodyStyle),
        ],
      ),
    );
  }

  Widget _activityView(ActivityModel a) {
    return _centerCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(a.title ?? "", style: _titleStyle),
          const SizedBox(height: 12),
          Text(a.description ?? "", style: _bodyStyle),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: [
              _tag(a.type),
              _tag(a.difficulty),
              _tag(a.time),
            ],
          )
        ],
      ),
    );
  }

  // ---------- UI Helpers ----------

  Widget _centerCard({required Widget child}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D1321),
                Color(0xFF1B2A49),
                Color(0xFF0D1321),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          top: 100,
          left: -60,
          child: _glow(160, Colors.purpleAccent.withOpacity(0.25)),
        ),

        Positioned(
          bottom: 120,
          right: -60,
          child: _glow(180, Colors.blueAccent.withOpacity(0.25)),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 80,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }

  TextStyle get _titleStyle => const TextStyle(
    fontSize: 26,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  TextStyle get _bodyStyle => TextStyle(
    fontSize: 16,
    color: Colors.white.withOpacity(0.9),
  );

  TextStyle get _subStyle => TextStyle(
    fontSize: 16,
    color: Colors.white.withOpacity(0.7),
  );
}

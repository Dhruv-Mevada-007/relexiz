import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_classes/suggestion_model.dart';
import '../providers/suggestions_provider.dart';
import 'add_edit_suggestion_screen.dart';

class SuggestionViewerScreen extends StatefulWidget {
  final int initialIndex;

  const SuggestionViewerScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  State<SuggestionViewerScreen> createState() =>
      _SuggestionViewerScreenState();
}

class _SuggestionViewerScreenState extends State<SuggestionViewerScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final sp = Provider.of<SuggestionsProvider>(context);
    final suggestions = sp.filteredSuggestions;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      body: Stack(
        children: [
          _background(),

          // TOP FADE
          if (currentIndex == 0)
            _edgeFade(top: true),

          // BOTTOM FADE
          if (currentIndex == suggestions.length - 1)
            _edgeFade(top: false),

          // PAGE VIEW
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: suggestions.length,
            onPageChanged: (i) => setState(() => currentIndex = i),
            itemBuilder: (context, index) {
              return _suggestionCard(suggestions[index]);
            },
          ),

          // CLOSE BUTTON
          Positioned(
            top: 50,
            right: 20,
            child: _glassIcon(
              icon: Icons.close,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // EDIT + DELETE
          Positioned(
            right: 20,
            bottom: 120,
            child: Column(
              children: [
                _glassIcon(
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditSuggestionScreen(
                          isEditing: true,
                          suggestion: suggestions[currentIndex],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                _glassIcon(
                  icon: Icons.delete,
                  color: Colors.redAccent,
                  onTap: () {
                    sp.deleteSuggestion(suggestions[currentIndex].id!);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= VIEW CARD =================

  Widget _suggestionCard(SuggestionModel s) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    s.title ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    s.description ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _tag(s.type),
                      _tag(s.difficulty),
                      _tag(s.time),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _glassIcon({
    required IconData icon,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
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
            child: Icon(icon, color: color),
          ),
        ),
      ),
    );
  }

  Widget _tag(String? text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.12),
      ),
      child: Text(
        text ?? "",
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _edgeFade({required bool top}) {
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                top
                    ? Colors.blueAccent.withOpacity(0.25)
                    : Colors.purpleAccent.withOpacity(0.25),
                Colors.transparent,
              ],
              begin: top ? Alignment.topCenter : Alignment.bottomCenter,
              end: top ? Alignment.bottomCenter : Alignment.topCenter,
            ),
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
          top: 120,
          left: -50,
          child: _glow(140, Colors.purpleAccent.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 130,
          right: -50,
          child: _glow(160, Colors.cyanAccent.withOpacity(0.2)),
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
}

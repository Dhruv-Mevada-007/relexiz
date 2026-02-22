import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model_classes/story_model_class.dart';
import '../providers/story_provider.dart';
import 'add_edit_story_screen.dart';

class StoryViewerScreen extends StatefulWidget {
  final int initialIndex;

  const StoryViewerScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late PageController _controller;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final sp = Provider.of<StoriesProvider>(context);
    final stories = sp.filteredStories;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      body: Stack(
        children: [
          Positioned.fill(child: _background()),

          // Page View
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _controller,
            itemCount: stories.length,
            onPageChanged: (i) => setState(() => currentPage = i),
            itemBuilder: (_, index) {
              final story = stories[index];
              return _storyPage(story);
            },
          ),

          // Close button
          Positioned(
            top: 50,
            right: 20,
            child: _glassButton(
              icon: Icons.close,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // Edit & Delete floating buttons
          Positioned(
            bottom: 120,
            right: 20,
            child: Column(
              children: [
                _glassButton(
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditStoryScreen(
                          isEditing: true,
                          story: stories[currentPage],
                        ),
                      ),

                    );
                  },
                ),
                const SizedBox(height: 14),
                _glassButton(
                  icon: Icons.delete,
                  color: Colors.redAccent,
                  onTap: () async {
                    final id = stories[currentPage].id;
                    if (id == null) return;

                    // Delete from provider
                    await Provider.of<StoriesProvider>(context, listen: false)
                        .deleteStory(id);

                    Navigator.pop(context); // close viewer after deletion
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Background theme
  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D1321),
                Color(0xFF152238),
                Color(0xFF0D1321),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          top: 150,
          left: -60,
          child: _blurCircle(150, Colors.cyanAccent.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 120,
          right: -60,
          child: _blurCircle(170, Colors.purpleAccent.withOpacity(0.2)),
        ),
      ],
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 80,
            spreadRadius: 40,
          )
        ],
      ),
    );
  }

  // Story page layout
  Widget _storyPage(StoryModel story) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),

              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Text(
                      story.title ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      story.content ?? "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Glass button widget
  Widget _glassButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
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
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
        ),
      ),
    );
  }
}

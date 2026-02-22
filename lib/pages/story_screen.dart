import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:relaxiz/pages/story_viewer_screen.dart';

import '../model_classes/story_model_class.dart';
import '../providers/story_provider.dart';
import 'add_edit_story_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<StoriesProvider>(context, listen: false).loadStories();
    });
  }

  // ⭐ Modern Category Button
  Widget categoryButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: isSelected
              ? const LinearGradient(
            colors: [
              Color(0xFF89CFF0),
              Color(0xFFB0E0E6),
            ],
          )
              : LinearGradient(
            colors: [
              Colors.white12,
              Colors.white10,
            ],
          ),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white30,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ⭐ Ambient background (slightly different colors from QuoteScreen)
  Widget _buildAmbientBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF101820), Color(0xFF152232)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Subtle cyan glow
        Positioned(
          top: 90,
          left: -40,
          child: _glowCircle(90, Colors.cyanAccent.withOpacity(0.18)),
        ),

        // Soft teal glow
        Positioned(
          bottom: 140,
          right: -40,
          child: _glowCircle(120, Colors.tealAccent.withOpacity(0.18)),
        ),
      ],
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 70,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sp = Provider.of<StoriesProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF101820),

      appBar: AppBar(
        title: const Text("Stories"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: Stack(
        children: [
          Positioned.fill(child: _buildAmbientBackground()),

          Column(
            children: [
              const SizedBox(height: 75),

              // ⭐ Category Buttons
              SizedBox(
                height: 55,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: sp.categories.map((cat) {
                    final isSelected =
                        sp.selectedCategory == cat || (sp.selectedCategory == null && cat == "All");

                    return categoryButton(
                      label: cat,
                      isSelected: isSelected,
                      onTap: () {
                        sp.setCategoryFilter(cat == "All" ? null : cat);
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 5),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 5),


              // ⭐ Staggered Story Grid
              Expanded(
                child: sp.filteredStories.isEmpty
                    ? const Center(
                  child: Text(
                    "No Stories Available",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: MasonryGridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    padding: EdgeInsets.all(0),
                    itemCount: sp.filteredStories.length,
                    itemBuilder: (context, index) {
                      final story = sp.filteredStories[index];
                      return _storyCard(story, index, sp.filteredStories);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // ⭐ Beautiful Add Button
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditStoryScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          margin: const EdgeInsets.only(bottom: 12, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF89CFF0), Color(0xFFB0E0E6)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.black, size: 20),
              SizedBox(width: 6),
              Text(
                "Add Story",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ Story Card (Glass + Staggered Height)
  Widget _storyCard(story, int index, List<StoryModel> stories) {

    final content = story.content ?? "";

// Estimate number of lines
    int lines = (content.length / 30).ceil();

// Cap lines at max 12
    lines = lines.clamp(1, 18);

// Now calculate height
    final double height = 110 + (lines * 14);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryViewerScreen(
              initialIndex: index,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            height: height.toDouble(),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
      
                const SizedBox(height: 6),
      
                Expanded(
                  child: Text(
                    story.content ?? "",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ),
      
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: IconButton(
                //     icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (_) => AddEditStoryScreen(
                //             isEditing: true,
                //             story: story,
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

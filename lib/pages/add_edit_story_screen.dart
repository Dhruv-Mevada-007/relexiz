import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_classes/story_model_class.dart';
import '../providers/story_provider.dart';

class AddEditStoryScreen extends StatefulWidget {
  final bool isEditing;
  final StoryModel? story;

  const AddEditStoryScreen({
    super.key,
    this.isEditing = false,
    this.story,
  });

  @override
  State<AddEditStoryScreen> createState() => _AddEditStoryScreenState();
}

class _AddEditStoryScreenState extends State<AddEditStoryScreen> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  final _category = TextEditingController();
  final _emotion = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _title.text = widget.story!.title ?? "";
      _content.text = widget.story!.content ?? "";
      _category.text = widget.story!.category ?? "";
      _emotion.text = widget.story!.emotion ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final sp = Provider.of<StoriesProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      appBar: AppBar(
        title: Text(widget.isEditing ? "Edit Story" : "Add Story"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: Stack(
        children: [
          _background(),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _inputField(
                          controller: _title,
                          label: "Title",
                        ),

                        const SizedBox(height: 16),

                        _inputField(
                          controller: _category,
                          label: "Category",
                        ),

                        const SizedBox(height: 16),

                        _inputField(
                          controller: _content,
                          label: "Story",
                          maxLines: 6,
                        ),

                        const SizedBox(height: 16),

                        _inputField(
                          controller: _emotion,
                          label: "Emotion",
                        ),

                        const SizedBox(height: 28),

                        _saveButton(sp),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------- UI COMPONENTS ----------

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _saveButton(StoriesProvider sp) {
    return GestureDetector(
      onTap: () {
        if (widget.isEditing) {
          sp.updateStory(
            StoryModel(
              id: widget.story!.id,
              title: _title.text.trim(),
              content: _content.text.trim(),
              category: _category.text.trim(),
              emotion: _emotion.text.trim(),
              date: widget.story!.date,
            ),
          );
        } else {
          sp.addStory(
            StoryModel(
              title: _title.text.trim(),
              content: _content.text.trim(),
              category: _category.text.trim(),
              emotion: _emotion.text.trim(),
              date: DateTime.now(),
            ),
          );
        }

        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF89CFF0), Color(0xFFB0E0E6)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.isEditing ? "Update Story" : "Add Story",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // BACKGROUND
  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1321), Color(0xFF1B2A49)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          top: 120,
          left: -40,
          child: _glow(120, Colors.cyanAccent.withOpacity(0.2)),
        ),

        Positioned(
          bottom: 120,
          right: -40,
          child: _glow(150, Colors.purpleAccent.withOpacity(0.2)),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 80,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}

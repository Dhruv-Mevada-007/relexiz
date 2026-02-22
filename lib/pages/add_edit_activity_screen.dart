import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_classes/activity_model.dart';
import '../providers/activities_provider.dart';

class AddEditActivityScreen extends StatefulWidget {
  final bool isEditing;
  final ActivityModel? activity;

  const AddEditActivityScreen({
    super.key,
    this.isEditing = false,
    this.activity,
  });

  @override
  State<AddEditActivityScreen> createState() => _AddEditActivityScreenState();
}

class _AddEditActivityScreenState extends State<AddEditActivityScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _type = TextEditingController();
  final _difficulty = TextEditingController();
  final _time = TextEditingController();
  final _emotion = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _title.text = widget.activity!.title ?? "";
      _description.text = widget.activity!.description ?? "";
      _type.text = widget.activity!.type ?? "";
      _difficulty.text = widget.activity!.difficulty ?? "";
      _time.text = widget.activity!.time ?? "";
      _emotion.text = widget.activity!.emotion ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<ActivitiesProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      appBar: AppBar(
        title: Text(widget.isEditing ? "Edit Activity" : "Add Activity"),
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

                        _inputField(_title, "Title"),
                        const SizedBox(height: 14),

                        _inputField(_type, "Type (stress / anxiety / focus)"),
                        const SizedBox(height: 14),

                        _inputField(_difficulty, "Difficulty (easy / medium / hard)"),
                        const SizedBox(height: 14),

                        _inputField(_time, "Time (e.g. 5 mins)"),
                        const SizedBox(height: 14),

                        _inputField(_emotion, "Emotion"),
                        const SizedBox(height: 14),

                        _inputField(_description, "Description", maxLines: 4),

                        const SizedBox(height: 28),

                        _saveButton(ap),
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

  // ---------- UI COMPONENTS ----------

  Widget _inputField(TextEditingController controller, String label,
      {int maxLines = 1}) {
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

  Widget _saveButton(ActivitiesProvider ap) {
    return GestureDetector(
      onTap: () {
        if (widget.isEditing) {
          ap.updateActivity(
            ActivityModel(
              id: widget.activity!.id,
              title: _title.text.trim(),
              description: _description.text.trim(),
              type: _type.text.trim(),
              difficulty: _difficulty.text.trim(),
              time: _time.text.trim(),
              emotion: _emotion.text.trim(),
              createdAt: widget.activity!.createdAt,
            ),
          );
        } else {
          ap.addActivity(
            ActivityModel(
              title: _title.text.trim(),
              description: _description.text.trim(),
              type: _type.text.trim(),
              difficulty: _difficulty.text.trim(),
              emotion: _emotion.text.trim(),
              time: _time.text.trim(),
              createdAt: DateTime.now(),
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
            widget.isEditing ? "Update Activity" : "Add Activity",
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
          child: _glow(140, Colors.purpleAccent.withOpacity(0.2)),
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

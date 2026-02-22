import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_classes/quote_model.dart';
import '../providers/quote_provider.dart';

class AddEditQuoteScreen extends StatefulWidget {
  final bool isEditing;
  final QuoteModel? quote;

  const AddEditQuoteScreen({
    super.key,
    this.isEditing = false,
    this.quote,
  });

  @override
  State<AddEditQuoteScreen> createState() => _AddEditQuoteScreenState();
}

class _AddEditQuoteScreenState extends State<AddEditQuoteScreen> {
  final TextEditingController _text = TextEditingController();
  final TextEditingController _author = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _emotion = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _text.text = widget.quote!.text ?? "";
      _author.text = widget.quote!.author ?? "";
      _category.text = widget.quote!.category ?? "";
      _emotion.text = widget.quote!.emotion ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final qp = Provider.of<QuotesProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      appBar: AppBar(
        title: Text(widget.isEditing ? "Edit Quote" : "Add Quote"),
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
                          controller: _text,
                          label: "Quote",
                          maxLines: 4,
                        ),

                        const SizedBox(height: 16),

                        _inputField(
                          controller: _author,
                          label: "Author",
                        ),

                        const SizedBox(height: 16),

                        _inputField(
                          controller: _category,
                          label: "Category",
                        ),

                        const SizedBox(height: 16),

                        _inputField(
                          controller: _emotion,
                          label: "Emotion",
                        ),

                        const SizedBox(height: 30),

                        _saveButton(qp),
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

  // 🔹 Input field
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

  // 🔹 Save Button
  Widget _saveButton(QuotesProvider qp) {
    return GestureDetector(
      onTap: () {
        if (widget.isEditing) {
          qp.addQuote(
            QuoteModel(
              id: widget.quote!.id,
              text: _text.text.trim(),
              author: _author.text.trim(),
              category: _category.text.trim(),
              emotion: _emotion.text.trim(),
              date: widget.quote!.date,
            ),
          );
        } else {
          qp.addQuote(
            QuoteModel(
              text: _text.text.trim(),
              author: _author.text.trim(),
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
            colors: [Color(0xFFB794F6), Color(0xFFD6BCFA)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.isEditing ? "Update Quote" : "Add Quote",
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

  // 🔹 Background
  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D1321),
                Color(0xFF1B2A49),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: -40,
          child: _glow(120, Colors.purpleAccent.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 100,
          right: -40,
          child: _glow(140, Colors.blueAccent.withOpacity(0.2)),
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
            color: color,
            blurRadius: 80,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}

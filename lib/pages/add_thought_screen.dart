import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase_service/firebase_service.dart';
import '../model_classes/thought_model.dart';
import '../providers/thought_provider.dart';

class AddThoughtScreen extends StatefulWidget {
  const AddThoughtScreen({super.key});

  @override
  State<AddThoughtScreen> createState() => _AddThoughtScreenState();
}

class _AddThoughtScreenState extends State<AddThoughtScreen> {
  final _formKey = GlobalKey<FormState>();
  String? title, description, category, mood;

  @override
  void initState() {
    super.initState();
    // Optional: Uncomment this to auto-generate sample data once.
    // addSampleThoughts();
  }

  Future<void> addSampleThoughts() async {
    final provider = Provider.of<ThoughtProvider>(context, listen: false);
    await provider.addSampleThoughts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sample thoughts added!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final thoughtProvider = Provider.of<ThoughtProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dump Your Thought!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _buildTextField(
                label: 'Title (optional)',
                onChanged: (v) => title = v,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Your Thought',
                hint: 'Write what’s on your mind...',
                maxLines: 4,
                onChanged: (v) => description = v,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please add your thought.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Category (optional)',
                onChanged: (v) => category = v,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                label: 'Mood (optional)',
                onChanged: (v) => mood = v,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.black,
                  elevation: 3,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  'Dump it!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newThought = ThoughtModel(
                      title: title,
                      description: description,
                      category: category,
                      mood: mood,
                      date: DateTime.now(),
                    );
                    await thoughtProvider.addThought(newThought);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    required Function(String) onChanged,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      style: const TextStyle(color: Colors.white70, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.8),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.6,
          ),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
    );
  }
}

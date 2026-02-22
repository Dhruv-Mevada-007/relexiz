import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relaxiz/pages/suggestion_viewer_screen.dart';

import '../providers/suggestions_provider.dart';
import 'activity_viewer_screen.dart';
import 'add_edit_suggestion_screen.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SuggestionsProvider>(context, listen: false)
          .loadSuggestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sp = Provider.of<SuggestionsProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      appBar: AppBar(
        title: const Text("Suggestions"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: Stack(
        children: [
          _background(),

          Column(
            children: [
              const SizedBox(height: 80),

              // ⭐ Category Chips
              SizedBox(
                height: 55,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: sp.types.map((t) {
                    final selected =
                        (sp.selectedType == null && t == "All") ||
                            (sp.selectedType == t);

                    return _categoryChip(
                      label: t,
                      isSelected: selected,
                      onTap: () {
                        sp.setTypeFilter(t == "All" ? null : t);
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              // ⭐ Suggestion Cards
              Expanded(
                child: sp.filteredSuggestions.isEmpty
                    ? const Center(
                  child: Text(
                    "No suggestions available",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                  itemCount: sp.filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    final s = sp.filteredSuggestions[index];

                    return _suggestionCard(s,index);
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      // Floating Add Button
      floatingActionButton: _floatingAddButton(),
    );
  }

  // ================= COMPONENTS =================

  Widget _categoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFFB794F6), Color(0xFFD6BCFA)],
          )
              : const LinearGradient(
            colors: [Colors.white12, Colors.white10],
          ),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white24,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _suggestionCard(s, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SuggestionViewerScreen(
                initialIndex: index,
              ),
            ),
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => AddEditSuggestionScreen(
          //       isEditing: true,
          //       suggestion: s,
          //     ),
          //   ),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.title ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                s.description ?? "",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${s.type} • ${s.difficulty} • ${s.time}",
                    style: TextStyle(
                      color: Colors.purpleAccent.shade100,
                      fontSize: 12,
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.white70),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditSuggestionScreen(
                                isEditing: true,
                                suggestion: s,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.redAccent),
                        onPressed: () {
                          Provider.of<SuggestionsProvider>(context).deleteSuggestion(s.id!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingAddButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddEditSuggestionScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.black),
            SizedBox(width: 6),
            Text(
              "Add Suggestion",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
          child: _glow(120, Colors.purpleAccent.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 120,
          right: -40,
          child: _glow(150, Colors.cyanAccent.withOpacity(0.2)),
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

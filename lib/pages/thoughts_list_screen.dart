import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relaxiz/pages/thought_detail_screen.dart';

import '../providers/thought_provider.dart';
import 'add_thought_screen.dart';
import 'home_screen.dart';

class ThoughtsListScreen extends StatefulWidget {
  const ThoughtsListScreen({super.key});

  @override
  State<ThoughtsListScreen> createState() => _ThoughtsListScreenState();
}

class _ThoughtsListScreenState extends State<ThoughtsListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ThoughtProvider>(context, listen: false);
    provider.loadThoughts().then((_) {
      if (mounted) setState(() => isLoading = false);
    });
  }

  Widget _buildCategoryFilter(ThoughtProvider provider) {
    final categories = provider.categories; // dynamic from provider

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = (provider.selectedCategory == null && category == 'All') ||
              provider.selectedCategory == category;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) {
              provider.setCategoryFilter(category == 'All' ? null : category);
            },
            selectedColor: const Color(0xFFB794F6),
            backgroundColor: Colors.grey[800],
            labelStyle: TextStyle(
              color: isSelected ? Colors.black : Colors.grey[300],
              fontWeight: FontWeight.w500,
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final thoughtProvider = Provider.of<ThoughtProvider>(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final thoughts = thoughtProvider.filteredThoughts;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Mind Dump Journal'), centerTitle: true),
        body: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: _buildCategoryFilter(thoughtProvider),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: thoughts.isEmpty
                  ? const Center(child: Text('No thoughts yet. Add one!'))
                  : ListView.builder(
                      itemCount: thoughts.length,
                      itemBuilder: (context, index) {
                        final thought = thoughts[index];
                        return Card(
                          color: Theme.of(context).cardColor.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(
                              thought.title ?? 'Untitled',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              thought.category ?? 'No category',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () async {
                                await thoughtProvider.deleteThought(thought.id!);
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ThoughtDetailScreen(thought: thought),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB794F6), // lavender accent
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddThoughtScreen()),
                );
              },
              child: const Text(
                'Dump Your Thoughts!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

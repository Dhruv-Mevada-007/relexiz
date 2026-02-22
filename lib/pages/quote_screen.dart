import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quote_provider.dart';
import 'add_edit_quote_screen.dart';
import 'quote_viewer_screen.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<QuotesProvider>(context, listen: false).loadQuotes();
    });
  }

  Widget modernAddButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        margin: const EdgeInsets.only(bottom: 12, right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFB794F6),
              Color(0xFFD6BCFA),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAmbientBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1321), Color(0xFF172745)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Soft purple glow
        Positioned(
          top: 80,
          left: -40,
          child: _glowCircle(140, Colors.purpleAccent.withOpacity(0.18)),
        ),

        // Soft blue glow
        Positioned(
          bottom: 120,
          right: -50,
          child: _glowCircle(170, Colors.blueAccent.withOpacity(0.18)),
        ),

        // Slight pink glow
        Positioned(
          bottom: 300,
          left: -30,
          child: _glowCircle(110, Colors.pinkAccent.withOpacity(0.14)),
        ),
      ],
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 90,
            spreadRadius: 50,
          ),
        ],
      ),
    );
  }


  Widget categoryButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
          gradient: isSelected
              ? const LinearGradient(
            colors: [
              Color(0xFFB794F6),
              Color(0xFFD6BCFA),
            ],
          )
              : LinearGradient(
            colors: [
              Colors.white12,
              Colors.white10,
            ],
          ),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white24,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final qp = Provider.of<QuotesProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      appBar: AppBar(
        title: const Text("Quotes"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1321), Color(0xFF172745)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _buildAmbientBackground()),
            Column(
              children: [
                const SizedBox(height: 75),

                // ⭐ Animated Category Chips
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: qp.categories.map((cat) {
                      final isSelected = qp.selectedCategory == cat ||
                          (cat == "All" && qp.selectedCategory == null);

                      return categoryButton(
                        label: cat,
                        isSelected: isSelected,
                        onTap: () {
                          qp.setCategoryFilter(cat == "All" ? null : cat);
                        },
                      );
                    }).toList(),
                  ),
                ),


                const SizedBox(height: 12),

                // ⭐ Quote List with Smooth Card Design
                Expanded(
                  child: qp.filteredQuotes.isEmpty
                      ? const Center(
                    child: Text(
                      "No Quotes Available",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                    physics: const BouncingScrollPhysics(),
                    itemCount: qp.filteredQuotes.length,
                    itemBuilder: (context, index) {
                      final q = qp.filteredQuotes[index];

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + index * 80),
                        curve: Curves.easeOut,
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
                                builder: (_) => QuoteViewerScreen(
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "\"${q.text}\"",
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    height: 1.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                if (q.author != null &&
                                    q.author!.isNotEmpty)
                                  Text(
                                    "- ${q.author}",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  ),

                                const SizedBox(height: 6),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${q.category}",
                                      style: TextStyle(
                                        color: Colors.purpleAccent.shade100,
                                        fontSize: 13,
                                      ),
                                    ),

                                    Text(
                                      q.date?.toLocal().toString().substring(0, 10) ?? "",
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),


                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     IconButton(
                                //       icon: const Icon(Icons.edit,
                                //           color: Colors.white70),
                                //       onPressed: () {
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (_) =>
                                //                 AddEditQuoteScreen(
                                //                     isEditing: true, quote: q),
                                //           ),
                                //         );
                                //       },
                                //     ),
                                //     IconButton(
                                //       icon: const Icon(Icons.delete,
                                //           color: Colors.redAccent),
                                //       onPressed: () {
                                //         qp.deleteQuote(q.id!);
                                //       },
                                //     )
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

          ],
        )


      ),

      // ⭐ Modern Floating Add Button
      floatingActionButton: modernAddButton(
        label: "Add Quote",
        icon: Icons.add,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditQuoteScreen(),
            ),
          );
        },
      ),

    );
  }
}

// 🔧 Extension for turning Container into button
extension GestureWrapper on Widget {
  Widget applyGestureDetector({required VoidCallback onTap}) {
    return GestureDetector(onTap: onTap, child: this);
  }
}

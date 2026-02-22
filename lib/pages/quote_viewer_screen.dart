import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relaxiz/providers/quote_provider.dart';
import '../model_classes/quote_model.dart';
import 'add_edit_quote_screen.dart';

class QuoteViewerScreen extends StatefulWidget {
  final int initialIndex;

  const QuoteViewerScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  State<QuoteViewerScreen> createState() => _QuoteViewerScreenState();
}

class _QuoteViewerScreenState extends State<QuoteViewerScreen> {
  late PageController _pageController;
  int currentPage = 0;

  Widget _glassIconButton({
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
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }



  @override
  void initState() {
    super.initState();
    currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {

    final quoteProvider = Provider.of<QuotesProvider>(context);
    final quotes = quoteProvider.filteredQuotes;
    print(currentPage);
    print(quotes[currentPage].id);
    print(quotes[currentPage].text);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      body: Stack(
        children: [
          // ⭐ Animated Background
          Positioned.fill(child: _buildAnimatedBackground()),

          // TOP FADE
          if (currentPage == 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  height: 130,
                  decoration:  BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),

// BOTTOM FADE
          if (currentPage == quotes.length - 1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  height: 130,
                  decoration:  BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purpleAccent.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),


          // ⭐ PAGED QUOTE VIEW
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: quotes.length,
            onPageChanged: (i) => setState(() => currentPage = i),
            itemBuilder: (context, index) {
              return _buildQuoteView(quotes[index]);
            },
          ),

          // ⭐ Glassmorphic Close Button
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ⭐ Floating Edit/Delete Buttons
          Positioned(
            right: 20,
            bottom: 120,
            child: Column(
              children: [
                _glassIconButton(
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditQuoteScreen(
                          isEditing: true,
                          quote: quotes[currentPage],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                _glassIconButton(
                  icon: Icons.delete,
                  color: Colors.redAccent,
                  onTap: () async {
                    final id = quotes[currentPage].id;
                    if (id == null) return;

                    // Delete from provider
                    await Provider.of<QuotesProvider>(context, listen: false)
                        .deleteQuote(id);

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

  // ⭐ Background with gradient + soft ambient circles
  Widget _buildAnimatedBackground() {
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

        // Ambient circles
        Positioned(
          top: 120,
          left: -50,
          child: _ambientCircle(140, Colors.purpleAccent.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 130,
          right: -50,
          child: _ambientCircle(160, Colors.blueAccent.withOpacity(0.2)),
        ),
      ],
    );
  }

  Widget _ambientCircle(double size, Color color) {
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

  // ⭐ Quote Page UI
  Widget _buildQuoteView(QuoteModel q) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Glass-like card container
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Quote text with subtle glow
                      Text(
                        "\"${q.text}\"",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(color: Colors.white24, blurRadius: 18),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      if (q.author != null && q.author!.isNotEmpty)
                        Text(
                          "- ${q.author}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 18),

                      Text(
                        "${q.category} • ${q.date?.toLocal().toString().substring(0, 10)}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

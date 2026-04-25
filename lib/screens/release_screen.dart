import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ReleaseScreen extends StatefulWidget {
  const ReleaseScreen({super.key});

  @override
  State<ReleaseScreen> createState() => _ReleaseScreenState();
}

class _ReleaseScreenState extends State<ReleaseScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _released = false;
  late AnimationController _smokeController;
  late Animation<double> _smokeScale;
  late Animation<double> _smokeOpacity;

  @override
  void initState() {
    super.initState();
    _smokeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _smokeScale = Tween<double>(begin: 1.0, end: 2.8).animate(
      CurvedAnimation(parent: _smokeController, curve: Curves.easeOut),
    );
    _smokeOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _smokeController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _smokeController.dispose();
    super.dispose();
  }

  Future<void> _release() async {
    if (_controller.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    _smokeController.reset();
    setState(() => _released = true);
    await _smokeController.forward();
  }

  void _reset() {
    _controller.clear();
    setState(() => _released = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _released ? _buildReleased() : _buildVentInput(),
          ),
        ),
      ),
    );
  }

  Widget _buildVentInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Text('release it.',
            style: Theme.of(context).textTheme.displaySmall)
            .animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 8),
        Text(
          'type whatever\'s on your mind. it won\'t be saved.\nit won\'t be judged. it just disappears — like smoke.',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSoft,
            fontStyle: FontStyle.italic,
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 500.ms),

        const SizedBox(height: 24),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: TextField(
            controller: _controller,
            maxLines: 8,
            minLines: 8,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textDark,
              height: 1.7,
            ),
            decoration: InputDecoration(
              hintText: 'just start typing... whatever\'s in your head...',
              hintStyle: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: _release,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.mauve,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'let it go  →',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 0.03,
              ),
            ),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

        const SizedBox(height: 12),

        Center(
          child: Text(
            'nothing is stored. this is just for you.',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: AppColors.textHint,
              fontStyle: FontStyle.italic,
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildReleased() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Smoke animation
          AnimatedBuilder(
            animation: _smokeController,
            builder: (context, _) {
              return Transform.scale(
                scale: _smokeScale.value,
                child: Opacity(
                  opacity: _smokeOpacity.value,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.mauvePale,
                          AppColors.mauvePale.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 28),

          Text(
            'released.',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              color: AppColors.sage,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 700.ms),

          const SizedBox(height: 10),

          Text(
            'it\'s gone. you\'re lighter now.',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textSoft,
              fontStyle: FontStyle.italic,
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 700.ms),

          const SizedBox(height: 36),

          GestureDetector(
            onTap: _reset,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.sage,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                'write more',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.cream,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/emotion.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/emotion_orb.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36),
              _buildLogo(),
              const SizedBox(height: 32),
              _buildBlobHeader(context),
              const SizedBox(height: 28),
              _buildCheckInLabel(),
              const SizedBox(height: 14),
              _buildEmotionGrid(context),
              const SizedBox(height: 24),
              _buildEnterButton(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'relaXi',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 38,
                  color: AppColors.sage,
                  letterSpacing: -1,
                ),
              ),
              TextSpan(
                text: 'Z',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 38,
                  color: AppColors.mauve,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1, end: 0),
        const SizedBox(height: 4),
        Text(
          'nothing to fix. just a place to be.',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: AppColors.textSoft,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.04,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildBlobHeader(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.creamWarm,
      ),
      child: Stack(
        children: [
          // Decorative blobs
          Positioned(
            left: -20,
            top: -10,
            child: Container(
              width: 130,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sagePale.withOpacity(0.7),
              ),
            ),
          ),
          Positioned(
            right: -10,
            top: -20,
            child: Container(
              width: 150,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mauvePale.withOpacity(0.6),
              ),
            ),
          ),
          Positioned(
            left: 50,
            bottom: -30,
            child: Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.softBluePale.withOpacity(0.5),
              ),
            ),
          ),
          // Center text
          Center(
            child: Text(
              'how are you right now?',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 16,
                color: AppColors.sageMid,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 700.ms)
        .scale(begin: const Offset(0.97, 0.97), end: const Offset(1, 1));
  }

  Widget _buildCheckInLabel() {
    return Text(
      'pick what resonates',
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: AppColors.textSoft,
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms);
  }

  Widget _buildEmotionGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.92,
      ),
      itemCount: EmotionData.all.length,
      itemBuilder: (context, index) {
        return _EmotionCard(
          emotion: EmotionData.all[index],
          delay: Duration(milliseconds: 500 + (index * 60)),
        );
      },
    );
  }

  Widget _buildEnterButton(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final selected = provider.selectedEmotion != null;
        return AnimatedOpacity(
          opacity: selected ? 1.0 : 0.35,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: selected
                ? () => provider.setTab(1) // navigate to With You
                : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.sage,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'come in  →',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.cream,
                  letterSpacing: 0.03,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmotionCard extends StatelessWidget {
  final Emotion emotion;
  final Duration delay;

  const _EmotionCard({required this.emotion, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final isSelected = provider.selectedEmotion == emotion.type;

        return GestureDetector(
          onTap: () => provider.selectEmotion(emotion.type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              color: isSelected ? emotion.paleColor : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? emotion.accentColor.withOpacity(0.5)
                    : AppColors.cardBorder,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: emotion.accentColor.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmotionOrb(
                  colorStart: emotion.dotColorStart,
                  colorEnd: emotion.dotColorEnd,
                  size: 32,
                  animate: isSelected,
                ),
                const SizedBox(height: 8),
                Text(
                  emotion.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? emotion.accentColor
                        : AppColors.textMid,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: delay, duration: 500.ms).scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
              delay: delay,
              duration: 400.ms,
              curve: Curves.easeOutBack,
            );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/breathing_orb.dart';
import '../widgets/ambient_sound_row.dart';

class WithYouScreen extends StatelessWidget {
  const WithYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final emotion = provider.currentEmotionData;

        return Scaffold(
          backgroundColor: AppColors.cream,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: emotion != null
                    ? [
                  AppColors.creamWarm,
                  emotion.paleColor.withOpacity(0.35),
                  AppColors.mauvePale.withOpacity(0.2),
                ]
                    : [
                  AppColors.creamWarm,
                  AppColors.sagePale.withOpacity(0.3),
                ],
              ),
            ),
            child: SafeArea(
              child: emotion == null
                  ? _buildNoEmotionState(context)
                  : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 8),
                child: _buildWithEmotionState(context, provider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoEmotionState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BreathingOrb(
              color: AppColors.sageMid,
              size: 90,
            ),
            const SizedBox(height: 32),
            Text(
              'just be here for a moment.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 22,
                color: AppColors.sage,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'when you\'re ready, check in from the home tab.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.textSoft,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildWithEmotionState(BuildContext context, AppProvider provider) {
    final emotion = provider.currentEmotionData!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        Text(
          emotion.title,
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 26,
            color: AppColors.sage,
            height: 1.25,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0),

        const SizedBox(height: 6),

        Text(
          emotion.subtitle,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSoft,
            fontStyle: FontStyle.italic,
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 600.ms),

        const SizedBox(height: 28),

        const AmbientSoundRow()
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms),

        const SizedBox(height: 28),

        Center(
          child: Column(
            children: [
              BreathingOrb(
                color: emotion.accentColor,
                size: 88,
              ),
              const SizedBox(height: 12),
              Text(
                'just breathe, if you want',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.textSoft,
                  letterSpacing: 0.06,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 700.ms),

        const SizedBox(height: 28),

        _StoryCard(story: emotion.storyQuote)
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.05, end: 0),

        const SizedBox(height: 12),

        _AffirmCard(text: emotion.affirmation)
            .animate()
            .fadeIn(delay: 500.ms, duration: 600.ms)
            .slideY(begin: 0.05, end: 0),

        const SizedBox(height: 12),

        _TinyMomentCard()
            .animate()
            .fadeIn(delay: 600.ms, duration: 600.ms),

        const SizedBox(height: 32),
      ],
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String story;

  const _StoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.mauveLight, AppColors.sageLight],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.textMid,
                      fontStyle: FontStyle.italic,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'someone shared this',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.sageMid,
                      letterSpacing: 0.07,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AffirmCard extends StatelessWidget {
  final String text;

  const _AffirmCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sagePale,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sageLight.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          color: AppColors.sage,
          fontWeight: FontWeight.w500,
          height: 1.6,
        ),
      ),
    );
  }
}

class _TinyMomentCard extends StatelessWidget {
  static const _moments = [
    'It\'s okay that today was a lot.',
    'You made it to right now. That counts.',
    'Resting is not the same as giving up.',
    'Some days just surviving is enough.',
    'You don\'t have to earn your rest.',
    'Being gentle with yourself is brave.',
    'You\'re allowed to take up space.',
  ];

  @override
  Widget build(BuildContext context) {
    final index = DateTime.now().hour % _moments.length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.emberPale,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emberLight.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.ember,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _moments[index],
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.ember,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

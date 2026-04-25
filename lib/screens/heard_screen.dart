import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/heard_story.dart';
import '../models/emotion.dart';
import '../providers/stories_provider.dart';
import '../theme/app_theme.dart';

class HeardScreen extends StatelessWidget {
  const HeardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'you\'re heard.',
                      style: Theme.of(context).textTheme.displaySmall,
                    ).animate().fadeIn(duration: 500.ms),
                    const SizedBox(height: 4),
                    Text(
                      'real moments. real people. you\'re not the only one.',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: AppColors.textSoft,
                        fontStyle: FontStyle.italic,
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Consumer<StoriesProvider>(
              builder: (context, provider, _) {
                if (provider.loading) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.sageMid,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _HeardCard(
                        story: provider.stories[index],
                        delay: Duration(milliseconds: index * 70),
                      ),
                      childCount: provider.stories.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HeardCard extends StatelessWidget {
  final HeardStory story;
  final Duration delay;

  const _HeardCard({required this.story, required this.delay});

  Color get _emotionColor {
    switch (story.emotionType) {
      case EmotionType.anxious:
        return AppColors.mauve;
      case EmotionType.angry:
        return AppColors.coral;
      case EmotionType.sad:
        return AppColors.softBlue;
      case EmotionType.numb:
        return const Color(0xFF6B6865);
      case EmotionType.overwhelmed:
        return AppColors.sageMid;
      case EmotionType.justOff:
        return AppColors.ember;
    }
  }

  Color get _emotionBg {
    switch (story.emotionType) {
      case EmotionType.anxious:
        return AppColors.mauvePale;
      case EmotionType.angry:
        return AppColors.coralPale;
      case EmotionType.sad:
        return AppColors.softBluePale;
      case EmotionType.numb:
        return const Color(0xFFEEECEA);
      case EmotionType.overwhelmed:
        return AppColors.sagePale;
      case EmotionType.justOff:
        return AppColors.emberPale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          context.read<StoriesProvider>().toggleRelate(story);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.quote,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textMid,
                  fontStyle: FontStyle.italic,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _emotionBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      story.emotionLabel,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.07,
                        color: _emotionColor,
                      ),
                    ),
                  ),
                  _MeTooButton(story: story),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 500.ms)
        .slideY(begin: 0.04, end: 0, delay: delay, duration: 400.ms);
  }
}

class _MeTooButton extends StatelessWidget {
  final HeardStory story;

  const _MeTooButton({required this.story});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoriesProvider>(
      builder: (context, provider, _) {
        final current = provider.stories.firstWhere(
          (s) => s.id == story.id,
          orElse: () => story,
        );

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: current.didRelate ? AppColors.sagePale : Colors.transparent,
            border: Border.all(
              color: current.didRelate
                  ? AppColors.sageLight
                  : AppColors.cardBorder,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'me too · ${current.meTooDisplay}',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: current.didRelate
                  ? AppColors.sageMid
                  : AppColors.textSoft,
              fontWeight:
                  current.didRelate ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        );
      },
    );
  }
}

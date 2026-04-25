import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum EmotionType {
  anxious,
  angry,
  sad,
  numb,
  overwhelmed,
  justOff,
}

class Emotion {
  final EmotionType type;
  final String label;
  final String title;
  final String subtitle;
  final String storyQuote;
  final String affirmation;
  final Color dotColorStart;
  final Color dotColorEnd;
  final Color paleColor;
  final Color accentColor;
  final String ambientMood; // maps to audio asset

  const Emotion({
    required this.type,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.storyQuote,
    required this.affirmation,
    required this.dotColorStart,
    required this.dotColorEnd,
    required this.paleColor,
    required this.accentColor,
    required this.ambientMood,
  });
}

class EmotionData {
  static const List<Emotion> all = [
    Emotion(
      type: EmotionType.anxious,
      label: 'Anxious',
      title: 'anxiety means you care deeply.',
      subtitle: 'and that\'s actually something.',
      storyQuote:
          '"I set three alarms for something that didn\'t even matter, just to feel some control. My brain was in overdrive. I let it be."',
      affirmation:
          'You don\'t have to calm down on cue. Anxiety is your mind trying to protect you — even when it overdoes it. That\'s okay.',
      dotColorStart: AppColors.mauveLight,
      dotColorEnd: AppColors.mauve,
      paleColor: AppColors.mauvePale,
      accentColor: AppColors.mauve,
      ambientMood: 'rain',
    ),
    Emotion(
      type: EmotionType.angry,
      label: 'Angry',
      title: 'anger means something matters to you.',
      subtitle: 'it\'s a completely valid feeling.',
      storyQuote:
          '"I was so frustrated I sat outside and stared at nothing for 20 minutes. Didn\'t fix anything. But I felt a little softer after."',
      affirmation:
          'Being angry doesn\'t make you a bad person. You\'re allowed to feel this. Take all the time you need — no rush.',
      dotColorStart: Color(0xFFF4A07A),
      dotColorEnd: AppColors.coral,
      paleColor: AppColors.coralPale,
      accentColor: AppColors.coral,
      ambientMood: 'quiet',
    ),
    Emotion(
      type: EmotionType.sad,
      label: 'Sad',
      title: 'sadness deserves space.',
      subtitle: 'you don\'t have to hurry through it.',
      storyQuote:
          '"I cried without knowing why. Just let it happen. Sometimes the body knows something the mind is still catching up with."',
      affirmation:
          'There\'s no timeline on this. Sit with it as long as you need to. You don\'t owe anyone a smile right now.',
      dotColorStart: Color(0xFF92ACD4),
      dotColorEnd: AppColors.softBlue,
      paleColor: AppColors.softBluePale,
      accentColor: AppColors.softBlue,
      ambientMood: 'ocean',
    ),
    Emotion(
      type: EmotionType.numb,
      label: 'Numb',
      title: 'numb is a feeling too.',
      subtitle: 'sometimes the body just needs rest.',
      storyQuote:
          '"I felt nothing for a whole day. Not sad, not happy. Just blank. I watched the ceiling for an hour. I think I needed that blank."',
      affirmation:
          'You don\'t have to feel anything right now. Sometimes numb is the system asking for a pause. That\'s completely okay.',
      dotColorStart: Color(0xFFC8C4BE),
      dotColorEnd: Color(0xFF8C8882),
      paleColor: Color(0xFFEEECEA),
      accentColor: Color(0xFF6B6865),
      ambientMood: 'quiet',
    ),
    Emotion(
      type: EmotionType.overwhelmed,
      label: 'Overwhelmed',
      title: 'you\'re carrying a lot.',
      subtitle: 'and you don\'t have to carry it alone.',
      storyQuote:
          '"I had 47 unread messages and couldn\'t open any of them. I made tea instead. The messages could wait. I couldn\'t."',
      affirmation:
          'You can put some of it down. Just for now. Not everything needs your attention this moment — including this.',
      dotColorStart: AppColors.sageLight,
      dotColorEnd: AppColors.sage,
      paleColor: AppColors.sagePale,
      accentColor: AppColors.sageMid,
      ambientMood: 'rain',
    ),
    Emotion(
      type: EmotionType.justOff,
      label: 'Just... off',
      title: 'sometimes there\'s no name for it.',
      subtitle: 'and that\'s okay too.',
      storyQuote:
          '"I couldn\'t explain what was wrong. Nothing specific happened. I just felt like I was slightly outside of myself all day."',
      affirmation:
          'You don\'t need a reason. Feeling off is real. You\'re allowed to just be here without explaining it to anyone.',
      dotColorStart: AppColors.emberLight,
      dotColorEnd: AppColors.ember,
      paleColor: AppColors.emberPale,
      accentColor: AppColors.ember,
      ambientMood: 'ocean',
    ),
  ];

  static Emotion byType(EmotionType type) =>
      all.firstWhere((e) => e.type == type);
}

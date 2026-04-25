import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';

class AmbientSoundRow extends StatefulWidget {
  const AmbientSoundRow({super.key});

  @override
  State<AmbientSoundRow> createState() => _AmbientSoundRowState();
}

class _AmbientSoundRowState extends State<AmbientSoundRow> {
  String? _playing;

  final _sounds = [
    {'id': 'rain', 'label': 'rain', 'icon': '🌧'},
    {'id': 'ocean', 'label': 'ocean', 'icon': '🌊'},
    {'id': 'quiet', 'label': 'quiet', 'icon': '🕯'},
  ];

  void _toggle(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _playing = _playing == id ? null : id;
    });
    // TODO: Connect to just_audio to play actual audio assets
    AudioService.play(id);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _sounds.map((sound) {
        final isPlaying = _playing == sound['id'];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _toggle(sound['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isPlaying ? AppColors.mauvePale : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isPlaying
                        ? AppColors.mauveLight
                        : AppColors.cardBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      sound['icon']!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sound['label']!,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: isPlaying
                            ? AppColors.mauve
                            : AppColors.textMid,
                        fontWeight: isPlaying
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

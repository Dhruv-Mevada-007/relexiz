import 'package:flutter/material.dart';
import '../model_classes/thought_model.dart';

class ThoughtDetailScreen extends StatelessWidget {
  final ThoughtModel thought;

  const ThoughtDetailScreen({super.key, required this.thought});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // title: Text(
        //   // thought.title ??
        //       'Thought Details',
        //   // style: TextStyle(color: primaryColor),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (thought.title != null)
              Text(
                thought.title!,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor, // Title in theme primary color
                ),
              ),
            const SizedBox(height: 10),
            if (thought.description != null && thought.description!.isNotEmpty)
              Text(
                thought.description!,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.grey[300], // Soft grey for readability
                ),
              )
            else
              Text(
                'No description provided.',
                style: TextStyle(color: Colors.grey[500]),
              ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[400]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Mood: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: thought.mood ?? 'N/A',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Category: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: thought.category ?? 'N/A',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${thought.date != null ? thought.date!.toLocal().toString().split(" ")[0] : "N/A"}',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}

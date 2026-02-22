import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_classes/activity_model.dart';
import '../providers/activities_provider.dart';
import 'add_edit_activity_screen.dart';

class ActivityViewerScreen extends StatefulWidget {
  final int initialIndex;

  const ActivityViewerScreen({
    super.key,
    required this.initialIndex,
  });

  @override
  State<ActivityViewerScreen> createState() => _ActivityViewerScreenState();
}

class _ActivityViewerScreenState extends State<ActivityViewerScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<ActivitiesProvider>(context);
    final activities = ap.filteredActivities;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      body: Stack(
        children: [
          _buildAnimatedBackground(),

          // TOP FADE
          if (currentPage == 0)
            _edgeFade(top: true),

          // BOTTOM FADE
          if (currentPage == activities.length - 1)
            _edgeFade(top: false),

          // PAGE VIEW
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: activities.length,
            onPageChanged: (i) => setState(() => currentPage = i),
            itemBuilder: (context, index) {
              return _buildActivityView(activities[index]);
            },
          ),

          // CLOSE BUTTON
          Positioned(
            top: 50,
            right: 20,
            child: _glassIcon(
              icon: Icons.close,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // ACTION BUTTONS
          Positioned(
            right: 20,
            bottom: 120,
            child: Column(
              children: [
                _glassIcon(
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditActivityScreen(
                          isEditing: true,
                          activity: activities[currentPage],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                _glassIcon(
                  icon: Icons.delete,
                  color: Colors.redAccent,
                  onTap: () {
                    ap.deleteActivity(activities[currentPage].id!);
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

  // ================= VIEW =================

  Widget _buildActivityView(ActivityModel a) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    a.title ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    a.description ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _tag(a.type),
                      _tag(a.difficulty),
                      _tag(a.time),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _glassIcon({
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
            ),
            child: Icon(icon, color: color),
          ),
        ),
      ),
    );
  }

  Widget _tag(String? text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.12),
      ),
      child: Text(
        text ?? "",
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _edgeFade({required bool top}) {
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                top
                    ? Colors.blueAccent.withOpacity(0.25)
                    : Colors.purpleAccent.withOpacity(0.25),
                Colors.transparent,
              ],
              begin: top ? Alignment.topCenter : Alignment.bottomCenter,
              end: top ? Alignment.bottomCenter : Alignment.topCenter,
            ),
          ),
        ),
      ),
    );
  }

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
        Positioned(
          top: 120,
          left: -50,
          child: _glow(140, Colors.purpleAccent.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 130,
          right: -50,
          child: _glow(160, Colors.blueAccent.withOpacity(0.2)),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) {
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
}

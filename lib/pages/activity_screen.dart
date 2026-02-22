import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activities_provider.dart';
import 'activity_viewer_screen.dart';
import 'add_edit_activity_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ActivitiesProvider>(context, listen: false)
          .loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<ActivitiesProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1321),

      appBar: AppBar(
        title: const Text("Activities"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: Stack(
        children: [
          _background(),

          Column(
            children: [
              const SizedBox(height: 80),

              // ⭐ CATEGORY CHIPS
              SizedBox(
                height: 55,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: ap.types.map((type) {
                    final selected =
                        (ap.selectedType == null && type == "All") ||
                            (ap.selectedType == type);

                    return _categoryChip(
                      label: type,
                      isSelected: selected,
                      onTap: () {
                        ap.setTypeFilter(type == "All" ? null : type);
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              // ⭐ ACTIVITY LIST
              Expanded(
                child: ap.filteredActivities.isEmpty
                    ? const Center(
                  child: Text(
                    "No Activities Available",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                  itemCount: ap.filteredActivities.length,
                  itemBuilder: (context, index) {
                    final a = ap.filteredActivities[index];

                    return _activityCard(a, ap, index);
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      // ⭐ Floating Add Button
      floatingActionButton: _floatingAddButton(),
    );
  }

  // ================= UI PARTS =================

  Widget _categoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFFB794F6), Color(0xFFD6BCFA)],
          )
              : const LinearGradient(
            colors: [Colors.white12, Colors.white10],
          ),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white24,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _activityCard(activity, ActivitiesProvider ap, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
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
              builder: (_) => ActivityViewerScreen(
                initialIndex: index,
              ),
            ),
          );
        },

        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) => AddEditActivityScreen(
        //         isEditing: true,
        //         activity: activity,
        //       ),
        //     ),
        //   );
        // },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                activity.description ?? "",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${activity.type} • ${activity.difficulty}",
                    style: TextStyle(
                      color: Colors.purpleAccent.shade100,
                      fontSize: 12,
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.white70),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditActivityScreen(
                                isEditing: true,
                                activity: activity,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.redAccent),
                        onPressed: () {
                          ap.deleteActivity(activity.id!);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingAddButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddEditActivityScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFFB794F6), Color(0xFFD6BCFA)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.black),
            SizedBox(width: 6),
            Text(
              "Add Activity",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1321), Color(0xFF1B2A49)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: -40,
          child: _glow(120, Colors.purpleAccent.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 120,
          right: -40,
          child: _glow(150, Colors.cyanAccent.withOpacity(0.2)),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 80,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}

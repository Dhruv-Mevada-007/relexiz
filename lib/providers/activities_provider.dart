import 'package:flutter/material.dart';

import '../firebase_service/activities_services.dart';
import '../model_classes/activity_model.dart';



class ActivitiesProvider with ChangeNotifier {
  final ActivitiesServices _firebase = ActivitiesServices();

  List<ActivityModel> _activities = [];
  List<ActivityModel> get activities => _activities;

  String? _selectedType;
  String? get selectedType => _selectedType;

  // Filter activities based on type
  List<ActivityModel> get filteredActivities {
    if (_selectedType == null || _selectedType == "All") {
      return _activities;
    }
    return _activities
        .where((a) => a.type?.toLowerCase() == _selectedType!.toLowerCase())
        .toList();
  }

  // Dynamic category list
  List<String> get types {
    final typeList = _activities
        .map((a) => a.type)
        .where((t) => t != null && t!.trim().isNotEmpty)
        .map((t) => t!.trim())
        .toSet()
        .toList();

    typeList.sort();
    return ["All", ...typeList];
  }

  void setTypeFilter(String? type) {
    _selectedType = type;
    notifyListeners();
  }

  // Load activities
  Future<void> loadActivities() async {
    final fetched = await _firebase.getActivitiesOnce();
    _activities = fetched;
    notifyListeners();
    // addSampleActivities();
  }

  // Add activity
  Future<void> addActivity(ActivityModel activity) async {
    final id = await _firebase.addActivityReturnId(activity);

    _activities.insert(
      0,
      ActivityModel(
        id: id,
        type: activity.type,
        title: activity.title,
        emotion: activity.emotion,
        description: activity.description,
        time: activity.time,
        difficulty: activity.difficulty,
        createdAt: activity.createdAt,
      ),
    );

    notifyListeners();
  }

  // Delete activity
  Future<void> deleteActivity(String id) async {
    await _firebase.deleteActivity(id);

    final removed = _activities.firstWhere((a) => a.id == id);
    final removedType = removed.type;

    _activities.removeWhere((a) => a.id == id);

    // If that category became empty → reset filter
    final stillExists = _activities.any(
            (a) => a.type?.toLowerCase() == removedType?.toLowerCase()
    );

    if (!stillExists) _selectedType = null;

    notifyListeners();
  }

  // Update activity
  Future<void> updateActivity(ActivityModel activity) async {
    await _firebase.updateActivity(activity);

    final index = _activities.indexWhere((a) => a.id == activity.id);
    _activities[index] = activity;

    notifyListeners();
  }

  // Add sample activities (for testing / onboarding)
  Future<void> addSampleActivities() async {
    final samples = [
      ActivityModel(
        title: "Deep Breathing",
        description:
        "Sit comfortably and take slow, deep breaths. Inhale through your nose for 4 seconds, hold for 2, and exhale slowly for 6 seconds.",
        type: "Stress",
        difficulty: "Easy",
        time: "3 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),

      ActivityModel(
        title: "Mindful Walk",
        description:
        "Take a slow walk and focus on your surroundings. Notice colors, sounds, and sensations without judgment.",
        type: "Mindfulness",
        difficulty: "Easy",
        time: "10 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),

      ActivityModel(
        title: "Gratitude Listing",
        description:
        "Write down three things you’re grateful for today. They can be small or big.",
        type: "Positivity",
        difficulty: "Easy",
        time: "5 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),

      ActivityModel(
        title: "Body Scan Relaxation",
        description:
        "Close your eyes and slowly bring attention to each part of your body, relaxing it step by step.",
        type: "Relaxation",
        difficulty: "Medium",
        time: "7 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),

      ActivityModel(
        title: "Thought Dump",
        description:
        "Write everything on your mind without filtering. Don’t judge, just release.",
        type: "Mental Health",
        difficulty: "Easy",
        time: "5 mins",
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];

    for (final activity in samples) {
      final id = await _firebase.addActivityReturnId(activity);

      _activities.insert(
        0,
        ActivityModel(
          id: id,
          title: activity.title,
          description: activity.description,
          type: activity.type,
          emotion: activity.emotion,
          difficulty: activity.difficulty,
          time: activity.time,
          createdAt: activity.createdAt,
        ),
      );
    }

    notifyListeners();
  }





}

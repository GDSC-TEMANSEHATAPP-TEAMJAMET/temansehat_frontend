class Moods {
  Map<String, MoodEntry> entries;

  Moods({required this.entries});

  factory Moods.fromJson(Map<String, dynamic> json) {
    Map<String, MoodEntry> entries = {};

    json.forEach((key, value) {
      entries[key] = MoodEntry.fromJson(value);
    });

    return Moods(entries: entries);
  }
}

class MoodEntry {
  String feeling;
  String story;
  String moodDate;

  MoodEntry({
    required this.feeling,
    required this.story,
    required this.moodDate,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      feeling: json['feeling'],
      story: json['story'],
      moodDate: json['mood_date'],
    );
  }
}
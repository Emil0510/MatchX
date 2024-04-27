class Weather {
  final Location location;
  final Current current;

  Weather({required this.location, required this.current});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        location: Location.fromJson(json['location']),
        current: Current.fromJson(json['current']));
  }
}

class Location {
  final String name;
  final String country;

  Location({required this.name, required this.country});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(name: json['name'], country: json['country']);
  }
}

class Current {
  final Condition condition;
  final double temp_c;
  final int is_day;

  Current(
      {required this.condition, required this.temp_c, required this.is_day});

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
        condition: Condition.fromJson(json['condition']),
        temp_c: json['temp_c'],
        is_day: json['is_day']);
  }
}

class Condition {
  final String icon;
  final String text;

  Condition({required this.icon, required this.text});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(icon: json['icon'], text: json['text']);
  }
}

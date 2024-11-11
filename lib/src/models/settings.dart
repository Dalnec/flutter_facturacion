import 'dart:convert';

class Settings {
  String? intervalTimeDevice;

  Settings({
    this.intervalTimeDevice,
  });

  factory Settings.fromRawJson(String str) =>
      Settings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        intervalTimeDevice: json["interval_time_device"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "interval_time_device": intervalTimeDevice,
      };
}
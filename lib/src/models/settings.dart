import 'dart:convert';

class Settings {
  String? intervalTimeDevice;
  String? width;
  String? height;

  Settings({
    this.intervalTimeDevice,
    this.width,
    this.height,
  });

  factory Settings.fromRawJson(String str) =>
      Settings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        intervalTimeDevice: json["interval_time_device"].toString(),
        width: json["width"].toString(),
        height: json["height"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "interval_time_device": intervalTimeDevice,
        "width": width,
        "height": height,
      };
}

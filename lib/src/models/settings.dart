import 'dart:convert';

class Settings {
  String? intervalTimeDevice;
  String? width;
  String? height;
  String? length;
  int? penaltyAmount;
  bool? autoPenalty;
  bool? forceCi;
  bool? collectPreviousMonth;

  Settings({
    this.intervalTimeDevice,
    this.width,
    this.height,
    this.length,
    this.penaltyAmount,
    this.autoPenalty,
    this.forceCi,
    this.collectPreviousMonth,
  });

  factory Settings.fromRawJson(String str) =>
      Settings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        intervalTimeDevice: json["interval_time_device"].toString(),
        width: json["width"].toString(),
        height: json["height"].toString(),
        length: json["length"].toString(),
        penaltyAmount: json["penalty_amount"],
        autoPenalty: json["auto_penalty"],
        forceCi: json["force_ci"],
        collectPreviousMonth: json["collect_previous_month"],
      );

  Map<String, dynamic> toJson() => {
        "interval_time_device": intervalTimeDevice,
        "width": width,
        "height": height,
        "length": length,
        "penalty_amount": penaltyAmount,
        "auto_penalty": autoPenalty,
        "force_ci": forceCi,
        "collect_previous_month": collectPreviousMonth,
      };
}

import 'dart:convert';

class AlarmModel {
  int id;
  DateTime dateTime;
  bool isActive;

  AlarmModel({required this.id, required this.dateTime, required this.isActive});

  Map<String, dynamic> toJson() => {
    'id': id,
    'dateTime': dateTime.toIso8601String(),
    'isActive': isActive,
  };

  String toJsonString() => jsonEncode(toJson());

  factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
    id: json['id'],
    dateTime: DateTime.parse(json['dateTime']),
    isActive: json['isActive'],
  );

  factory AlarmModel.fromJsonString(String str) =>
      AlarmModel.fromJson(jsonDecode(str));
}

import 'package:flutter_widgetkit/flutter_widgetkit.dart';

class FlutterWidgetData {
  final String text;

  FlutterWidgetData(this.text);

  FlutterWidgetData.fromJson(Map<String, dynamic> json)
      : text = json['text'];

  Map<String, dynamic> toJson() =>
    {
      'text': text,
    };
}
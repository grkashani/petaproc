import 'dart:typed_data';

import 'enum.dart';

class BaseWidgetInfo {
  WidgetType type;

  BaseWidgetInfo({
    required this.type,
  });
}


class MyQuestion extends BaseWidgetInfo {
  String question;
  String hint;
  List<String> answers;
  bool isTest;

  MyQuestion({
    required this.question,
    required this.hint,
    required this.answers,
    required this.isTest,
    super.type = WidgetType.question,
  });
}

class MyImage extends BaseWidgetInfo {
  Uint8List fileU8 = Uint8List(0);

  MyImage({
    required this.fileU8,
    super.type = WidgetType.image,
  });
}

class MyVideo extends BaseWidgetInfo {
  Uint8List fileU8 = Uint8List(0);

  MyVideo({
    required this.fileU8,
    super.type = WidgetType.video,
  });
}

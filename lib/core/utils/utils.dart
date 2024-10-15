import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../providers/user_provider.dart';
import '../constant/constants.dart';
import '../widgets/loading_progress.dart';

Future<Uint8List?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc'], // فرمت‌های مجاز
  );
  if (result != null) {
    Uint8List? fileBytes = result.files.first.bytes;
    String? fileName = result.files.first.name;
    // فایل انتخاب شده را به همراه داده‌های باینری بازمی‌گرداند
    if (kDebugMode) {
      print('Selected file: $fileName');
    }
    return fileBytes;
  }
  return null;
}

pickVideo({required ImageSource source}) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickVideo(source: source);
  if (file != null) {
    return await file.readAsBytes(); // ویدیو به‌صورت بایت‌ها
  }
}

Future<Uint8List?> pickImage({required ImageSource source}) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  return null;
}

double numberMax(List<dynamic> mm, String field) {
  int maxnum = 0;
  for (int i = 0; i < mm.length; i++) {
    maxnum = max(maxnum, int.parse(mm[i][field]));
  }
  maxnum =
      (1 + int.parse(maxnum.toString()[0])) * (pow(10, (maxnum.toString().length - 1))).toInt();
  put(maxnum.toString());
  return maxnum.toDouble();
}

double rangeNumber(double num) {
  if (num.toString().length > 12) {
    return 1000000000000;
  } else if (num.toString().length > 9) {
    return 1000000000;
  } else if (num.toString().length > 6) {
    return 1000000;
  } else if (num.toString().length > 3) {
    return 1000;
  } else {
    return 1;
  }
}

String rangeLetters(double num) {
  if (num.toString().length > 12) {
    return 'بیلیون';
  } else if (num.toString().length > 9) {
    return 'میلیارد';
  } else if (num.toString().length > 6) {
    return 'میلیون';
  } else if (num.toString().length > 3) {
    return 'هزار';
  } else {
    return '';
  }
}

showDialogProgress(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const LoadingProgress();
    },
  );
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(text),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.04,
          right: MediaQuery.of(context).size.width * 0.15,
          left: MediaQuery.of(context).size.width * 0.15),
    ),
  );
}

String dateTimeShamsi(DateTime inDateTime, DateTimePart part) {
  var myDateTime = Jalali.fromDateTime(inDateTime);
  String monthname = '';

  if (inDateTime.isAtSameMomentAs(DateTime(1, 1, 1))) {
    return 'داده ای از سمت سرور دریافت نشد';
  } else {
    switch (part) {
      case DateTimePart.date:
        return '${myDateTime.year}/${myDateTime.month >= 10 ? myDateTime.month : '0${myDateTime.month}'}/${myDateTime.day >= 10 ? myDateTime.day : '0${myDateTime.day}'}';

      case DateTimePart.year:
        return myDateTime.year.toString();

      case DateTimePart.month:
        return myDateTime.month.toString();

      case DateTimePart.day:
        return myDateTime.day.toString();

      case DateTimePart.time:
        return '${myDateTime.hour >= 10 ? myDateTime.hour : '0${myDateTime.hour}'}:${myDateTime.minute >= 10 ? myDateTime.minute : '0${myDateTime.minute}'}:${myDateTime.second >= 10 ? myDateTime.second : '0${myDateTime.second}'}';

      case DateTimePart.hour:
        return myDateTime.hour.toString();

      case DateTimePart.minute:
        return myDateTime.minute.toString();

      case DateTimePart.second:
        return myDateTime.second.toString();

      case DateTimePart.monthname:
        switch (myDateTime.month) {
          case 1:
            return monthname = 'فروردین';
          case 2:
            return monthname = 'اردیبهشت';
          case 3:
            return monthname = 'خرداد';
          case 4:
            return monthname = 'تیر';
          case 5:
            return monthname = 'مرداد';
          case 6:
            return monthname = 'شهریور';
          case 7:
            return monthname = 'مهر';
          case 8:
            return monthname = 'آبان';
          case 9:
            return monthname = 'آذر';
          case 10:
            return monthname = 'دی';
          case 11:
            return monthname = 'بهمن';
          case 12:
            return monthname = 'اسفند';
        }
        return monthname;
      default:
        throw ArgumentError('Invalid DateTimePart');
    }
  }
}

put(String st) {
  if (kDebugMode) debugPrint(st);
}

String changeFormat(String str, String separator) {
  List<String> parts = str.split(separator);
  parts = parts.reversed.toList();
  return parts.join(separator);
}

exitLinkedin(ref) {
  ref.read(userProvider).changeUserState(ViewState.dashboardPage);
  ref.read(userProvider).changePage(screen: 'SignIn');
}

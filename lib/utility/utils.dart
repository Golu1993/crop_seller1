import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
getDottedLine() {
  return const DottedLine(
    direction: Axis.horizontal,
    lineLength: double.infinity,
    dashLength: 1.0,
    dashColor: Colors.grey,
    dashGapLength: 1.0,
    dashGapColor: Colors.transparent,
  );
}

getHorizontalLine() {
  return const DottedLine(
    direction: Axis.horizontal,
    lineLength: double.infinity,
    dashColor: Color.fromRGBO(0, 0, 0, 0.16),
    dashGapColor: Color.fromRGBO(0, 0, 0, 0.16),
  );
}

getVerticalLine() {
  return const DottedLine(
    direction: Axis.vertical,
    lineLength: double.infinity,
    dashColor: Color.fromRGBO(0, 0, 0, 0.16),
    dashGapColor: Color.fromRGBO(0, 0, 0, 0.16),
  );
}

showLoaderDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                padding: EdgeInsets.all(15),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
          onWillPop: () async {
            return false;
          });
    },
  );
}

printConsoleData(String key, String? value) {
  if (kDebugMode) {
    print('$key   $value');
  }
}

Future<String> getImageFromGallery() async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    // maxWidth: 800,
    // maxHeight: 800,
  );
  if (pickedFile != null) {
    return pickedFile.path;
  } else {
    return "";
  }
}

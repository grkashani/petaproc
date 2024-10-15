// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final jobsProvider = ChangeNotifierProvider<JobsProvider>((ref) => JobsProvider());
//
// class JobsProvider with ChangeNotifier {
//   TextEditingController stateYourOccupationController = TextEditingController();
//   TextEditingController expressYourExpertiseController = TextEditingController();
//
//   bool _stateYourOccupation = false;
//   bool _expressYourExpertise = false;
//   Uint8List _image = Uint8List(0);
//   Uint8List _video = Uint8List(0);
//
//   bool get stateYourOccupation => _stateYourOccupation;
//
//   bool get expressYourExpertise => _expressYourExpertise;
//
//   Uint8List get image => _image;
//
//   Uint8List get video => _video;
//
//   Future<void> changeStateYourOccupation() async {
//     _stateYourOccupation = !stateYourOccupation;
//     notifyListeners();
//   }
//
//   Future<void> changeExpressYourExpertise() async {
//     _expressYourExpertise = !expressYourExpertise;
//     notifyListeners();
//   }
//
//   Future<void> addImage({required Uint8List? file}) async {
//     if (file!.isNotEmpty) {
//       _image = file;
//       notifyListeners();
//     }
//   }
//
//   Future<void> addVideo({required Uint8List file}) async {
//     _video = file;
//     notifyListeners();
//
//     if (kDebugMode) {
//       print('Video loaded with size: ${_video.lengthInBytes}');
//     }
//   }
// }

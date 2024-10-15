import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/data/model/widgets_info.dart';

final certificateProvider = ChangeNotifierProvider<CertificateProvider>((ref) {
  return CertificateProvider(refProvider: ref);
});

class CertificateProvider with ChangeNotifier {
  final ChangeNotifierProviderRef<CertificateProvider> refProvider;
  CertificateProvider({required this.refProvider});

  String certificateName = 'Certificate Name';
  void updateCertificateName(){
    certificateName = certificateNameController.text;
    notifyListeners();
  }

  final certificateNameController = TextEditingController();
  final questionController = TextEditingController();
  final hintController = TextEditingController();
  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();
  final answer3Controller = TextEditingController();
  final answer4Controller = TextEditingController();

  bool isTest = false;
  void updateQuestion(bool value){
    isTest = value;
    notifyListeners();
  }


  List<BaseWidgetInfo> myWidgetList = [];

  addQuestionExplaination({required String question, required String hint}) {
    MyQuestion eq = MyQuestion(question: question, hint: hint, isTest: false, answers: []);
    myWidgetList.add(eq);
    notifyListeners();
  }

  addQuestionTest({
    required String question,
    required String hint,
    required String answer1,
    required String answer2,
    required String answer3,
    required String answer4,
  }) {
    MyQuestion eq = MyQuestion(question: question, hint: hint, answers: [answer1, answer2, answer3, answer4], isTest: true);
    myWidgetList.add(eq);
    notifyListeners();
  }

  Future<void> addImage({required Uint8List? file}) async {
    if (file!.isNotEmpty) {
      MyImage mi = MyImage(fileU8: file);
      myWidgetList.add(mi);
      notifyListeners();
    }
  }

  Future<void> addVideo({required Uint8List file}) async {
    if (file.isNotEmpty) {
      MyVideo mv = MyVideo(fileU8: file);
      myWidgetList.add(mv);
      notifyListeners();
    }
  }
}

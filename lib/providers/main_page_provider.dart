import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constant/constants.dart';



class MainPageProvider extends ChangeNotifier {
  final ChangeNotifierProviderRef<MainPageProvider> refProvider;

  MainPageState _mainPageState = MainPageState.notifications;

  MainPageState get mainPageState => _mainPageState;

  MainPageProvider({required this.refProvider});

  void updateMainState(MainPageState newState) {
    _mainPageState = newState;
    notifyListeners();
  }
}

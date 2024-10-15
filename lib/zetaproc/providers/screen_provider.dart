import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/zetaproc/constant/zconstants.dart';

final screenProvider = ChangeNotifierProvider<ScreenProvider>((ref) {
  return ScreenProvider(refProvider: ref);
});

class ScreenProvider extends ChangeNotifier {
  final ChangeNotifierProviderRef<ScreenProvider> refProvider;
  ZClientScreen _clienScreen = ZClientScreen.mobile;

  ZClientScreen get clienScreen => _clienScreen;

  ScreenProvider({required this.refProvider}) {
    // You can call the method with a default size to avoid null values at initialization
    updateClientScreen(const Size(0, 0));
  }

  void updateClientScreen(Size screenSize) {
    if (screenSize.width > 1200) {
      _clienScreen = ZClientScreen.desktop;
    } else if (screenSize.width > 800) {
      _clienScreen = ZClientScreen.tablet;
    } else {
      _clienScreen = ZClientScreen.mobile;
    }
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petaproc/zetaproc/constant/zconstants.dart';

final signPageProvider = ChangeNotifierProvider<SignPageProvider>((ref) {
  return SignPageProvider(refProvider: ref);
});

class SignPageProvider extends ChangeNotifier {
  final ChangeNotifierProviderRef<SignPageProvider> refProvider;
  final TextEditingController usernameController = TextEditingController(text: 'grkashani');
  final TextEditingController emailController = TextEditingController(text: 'grkashani1@gmail.com');
  final TextEditingController passwordController = TextEditingController(text: 'R!e2z3a4');

  ZSignPageState _signPageState = ZSignPageState.signdIn;

  ZSignPageState get signPageState => _signPageState;

  SignPageProvider({required this.refProvider});

  void updateUserState(ZSignPageState newState) {
    _signPageState = newState;
    notifyListeners();
  }
}

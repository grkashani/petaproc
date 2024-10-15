import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider = ChangeNotifierProvider<MessageProvider>((ref) {
  return MessageProvider(refProvider: ref);
});

class MessageProvider extends ChangeNotifier {
  final ChangeNotifierProviderRef<MessageProvider> refProvider;
  bool _isMessage = false;
  String _message = '';

  bool get isMessage => _isMessage;
  String get message => _message;

  MessageProvider({required this.refProvider});

  void showMessage(String message) {
    _message = message;
    _isMessage = true;
    notifyListeners();
  }
  void hideMessage() {
    _message = '';
    _isMessage = false;
  }

}

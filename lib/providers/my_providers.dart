import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_page_provider.dart';

class MyPrividers{
  static  final mainPageProvider = ChangeNotifierProvider<MainPageProvider>((ref) {
  return MainPageProvider(refProvider: ref);
  });
}
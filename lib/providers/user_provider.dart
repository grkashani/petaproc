import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/firebase/firebase_services.dart';
import '../data/model/user_profile_model.dart';

final userProvider = ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

class UserProvider with ChangeNotifier {
  UserProfileModel _myUser = const UserProfileModel();

  UserProfileModel get myUser => _myUser; // یوزر فعال

  Uint8List _image = Uint8List(0);

  Uint8List get image => _image; // تصویر پروفایل

  int? _userCount;

  int? get userCount => _userCount;

  UserProvider() {
    initializeUser();
  }

  Future<void> initializeUser() async {
    await refreshUser();
    await getNumberUser();
    await loadProfileImage();
  }

  Future<void> refreshUser() async {
    try {
      UserProfileModel? user = await FirebaseServices.getOwnerDetails();

      _myUser = user ?? const UserProfileModel();
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing user: $e');
    }
  }

  Future<void> getNumberUser() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('users').get();
      _userCount = snapshot.docs.length;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching user count: $e');
    }
  }

  // متد برای بارگذاری تصویر پیش ‌فرض
  Future<void> loadProfileImage() async {
    try {
      if (myUser.profileImageUrl == '') {
        // اگر تصویر پروفایل موجود نبود، تصویر پیش‌فرض را بارگذاری می‌کند
        _image = await rootBundle
            .load('assets/pictures/anonymouse.png')
            .then((data) => data.buffer.asUint8List());
      } else {
        // دانلود تصویر پروفایل از URL
        final response = await http.get(Uri.parse(myUser.profileImageUrl));
        if (response.statusCode == 200) {
          _image = response.bodyBytes;
        } else {
          _image = await rootBundle
              .load('assets/pictures/anonymouse.png')
              .then((data) => data.buffer.asUint8List());
          throw Exception('Failed to load profile image');
        }
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading profile image: $e');
      }
    }
  }

  Future<void> changeimage({required Uint8List? file}) async {
    notifyListeners();
    if (file!.isNotEmpty) {
      await FirebaseServices.deleteProfileImage();
      if (await FirebaseServices.uploadProfileImage(
          file: file, imageSize: 400, imageQuality: 80, imageDirectory: 'profile_images')) {
        _image = file;
        refreshUser();
      }
    }
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, Uint8List, defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:petaproc/zetaproc/data/zmodel_owner.dart';
import 'package:petaproc/zetaproc/widgets/widget_work_sample.dart';
import 'package:uuid/uuid.dart';
import 'package:petaproc/zetaproc/data/zmodel_user_profile.dart';

class ZFirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB8LQYpUFNHl5mZht3MhbWKh5XfkQIR18w',
    appId: '1:239658572637:web:a2e85bc7180c1e8a8a66b4',
    messagingSenderId: '239658572637',
    projectId: 'itja-66cb4',
    authDomain: 'itja-66cb4.firebaseapp.com',
    storageBucket: 'itja-66cb4.appspot.com',
    measurementId: 'G-6HC19JZ2ZG',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static final authStateProvider = StreamProvider<User?>((ref) {
    return _auth.authStateChanges();
  });

  Future<void> saveUserToFirestore() async {
    // گرفتن UID کاربر جاری
    User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;

      // ارجاع به داکیومنت با UID
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('ITJA Users').doc(uid);

      // چک کردن وجود داکیومنت
      DocumentSnapshot docSnapshot = await userDocRef.get();

      if (!docSnapshot.exists) {
        // اگر داکیومنت وجود ندارد، آن را ایجاد کن
        await userDocRef.set({
          'name': user.displayName ?? 'Unknown',
          'email': user.email ?? 'No email',
          // فیلدهای بیشتر
        });
        if (kDebugMode) {
          print('User document created');
        }
      } else {
        if (kDebugMode) {
          print('User document already exists');
        }
        // اگر لازم است، می‌توانید داده‌ها را به‌روزرسانی کنید
      }
    } else {
      if (kDebugMode) {
        print('User is not signed in');
      }
    }
  }

  // static addUser() async {
  //   try {
  //     final user = <String, dynamic>{"first": "reza", "last": "Lovelace", "born": 1815};
  //     _db.collection("users").add(user).then((DocumentReference doc) {
  //       final profilePic = <String, dynamic>{
  //         "address":
  //             "https://www.google.com/search?q=pictures&sca_esv=9ea59d307d2a2909&rlz=1C1CHZN_enIR1123IR1123&sxsrf=ADLYWILitDraJmo4nWeBu7qYktjLJoSjAg:1723907905137&udm=2&source=iu&ictx=1&vet=1&fir=Q53WJiavu6IJtM%252C0JWe7yDOKrVFAM%252C%252Fm%252F0jg24%253BsKMM4eBjWSQEBM%252CB51x0PBR9KNzvM%252C_%253B8bIBfJtlZwYNrM%252CYl7gTqaCG8A-UM%252C_%253B13B_VF2p8JgEFM%252Cs3iFRcHv5BESwM%252C_%253BScnmyk9jYFSBNM%252CE-_aOwFp15AeLM%252C_%253BlfWnW2IEnhbPvM%252CePjCKhFm09p5bM%252C_&usg=AI4_-kRuhWV_DP1MDODeb7enN53BlCPEUw&sa=X&ved=2ahUKEwi1rb6yqfyHAxXDxwIHHfwIAHAQ_B16BAg1EAE&biw=1920&bih=911&dpr=1#vhid=8bIBfJtlZwYNrM&vssid=mosaic"
  //       };
  //       _db.collection("users").doc(doc.id).collection("profile pictures").add(profilePic);
  //     });
  //   } catch (e) {
  //     debugPrint('Error adding document to Firestore');
  //   }
  // }

  // static Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
  //   Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
  //   if (isPost) {
  //     String id = const Uuid().v1();
  //     ref = ref.child(id);
  //   }
  //
  //   UploadTask uploadTask = ref.putData(file);
  //   TaskSnapshot snapshot = await uploadTask;
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  // static Future<MyUser> getOwnerDetails() async {
  //   User currentUser = _auth.currentUser!;
  //
  //   DocumentSnapshot documentSnapshot = await _db.collection('users').doc(currentUser.uid).get();
  //
  //   return MyUser.fromSnap(documentSnapshot);
  // }

  static Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = "Some error Occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        ZMyUser myUser = ZMyUser(
          username: username,
          email: email,
          photoUrl: '',
          uid: cred.user!.uid,
        );

        await _db.collection("ITJA Users").doc(cred.user!.uid).set(myUser.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  static Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // static Future<String> adddWorkSample(
  //     String description, Uint8List file, String uid, String username, String profImage) async {
  //   String res = "Some error occurred";
  //   try {
  //     String photoUrl = await uploadImageToStorage('workSamples', file, true);
  //     String workSampleId = const Uuid().v1();
  //     WorkSamplet workSample = WorkSamplet(
  //       description: description,
  //       uid: uid,
  //       username: username,
  //       likes: [],
  //       favourites: [],
  //       workSampleId: workSampleId,
  //       datePublished: DateTime.now(),
  //       workSampleUrl: photoUrl,
  //       profImage: profImage,
  //     );
  //     _db.collection('workSamples').doc(workSampleId).set(workSample.toJson());
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  static Future<String> favouriteWorkSamplet(String workSampleId, String uid, List favourites) async {
    String res = "Some error occurred";
    try {
      if (favourites.contains(uid)) {
        _db.collection('workSamples').doc(workSampleId).update({
          'favourites': FieldValue.arrayRemove([uid])
        });
      } else {
        _db.collection('workSamples').doc(workSampleId).update({
          'favourites': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<String> likeWorkSamplet(String workSampleId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _db.collection('workSamples').doc(workSampleId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _db.collection('workSamples').doc(workSampleId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<String> workSampleComment(
      String workSampleId, String text, String uid, String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _db.collection('workSamples').doc(workSampleId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<String> deleteWorkSamplet(String workSampleId) async {
    String res = "Some error occurred";
    try {
      await _db.collection('workSamples').doc(workSampleId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await _db.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _db.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _db.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _db.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _db.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      log('Error adding document to Firestore');
    }
  }

  static Future<void> unfollowUser(String currentUserId, String userIdToUnfollow) async {
    try {
      // Assuming your Firestore collection for users has a field 'followers' which is a list of user IDs
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userIdToUnfollow);
      DocumentReference currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot userSnapshot = await transaction.get(userRef);
        DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserRef);

        if (userSnapshot.exists && currentUserSnapshot.exists) {
          // Remove currentUserId from the 'followers' list of the user being unfollowed
          transaction.update(userRef, {
            'followers': FieldValue.arrayRemove([currentUserId])
          });

          // Optionally, remove the userIdToUnfollow from the 'following' list of the current user
          transaction.update(currentUserRef, {
            'following': FieldValue.arrayRemove([userIdToUnfollow])
          });
        }
      });
    } catch (e) {
      throw Exception("Error unfollowing user: $e");
    }
  }

  //----------------------------------
  static Future<String> adddWorkSample(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occurred";
    try {
      String photoUrl = await uploadImageToStorage('workSamples', file, true);
      String workSampleId = const Uuid().v1();
      WorkSamplet workSample = WorkSamplet(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        favourites: [],
        workSampleId: workSampleId,
        datePublished: DateTime.now(),
        workSampleUrl: photoUrl,
        profImage: profImage,
      );
      await _db.collection('workSamples').doc(workSampleId).set(workSample.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

//--------------------------------------------------------------------------------------------------
  static Future<ZUserProfileModel?> getOwnerDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      log('No user is currently logged in.');
      return null;
    }
    DocumentSnapshot documentSnapshot = await _db.collection('ITJA Users').doc(currentUser.uid).get();
    return ZUserProfileModel.fromSnap(documentSnapshot);
  }

  static Future<void> addFollow(String userId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        log('No user is currently logged in.');
        return;
      }
      String followerId = currentUser.uid;

      // دریافت نام و تصویر کاربر لاگین شده
      DocumentSnapshot currentUserDoc = await _db.collection('ITJA Users').doc(followerId).get();
      if (!currentUserDoc.exists) {
        log('Current user document does not exist.');
        return;
      }

      String userName = currentUserDoc.get('UserName');
      String profilePicture = currentUserDoc.get('ProfilePicture');

      // followers
      await _db.collection('ITJA Users').doc(userId).collection('followers').doc(followerId).set({
        'UserName': userName,
        'ProfilePicture': profilePicture,
        'followedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Total followers
      QuerySnapshot followersSnapshot = await _db.collection('ITJA Users').doc(userId).collection('followers').get();

      int totalFollowers = followersSnapshot.size;

      await _db.collection('ITJA Users').doc(userId).update({
        'Total followers': totalFollowers,
      });
    } catch (e) {
      log('Error adding follower: $e');
    }
  }

  static Future<void> unFollow(String userId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        log('No user is currently logged in.');
        return;
      }
      String followerId = currentUser.uid;

      // followers
      await _db.collection('ITJA Users').doc(userId).collection('followers').doc(followerId).delete();

      // Total followers
      QuerySnapshot followersSnapshot = await _db.collection('ITJA Users').doc(userId).collection('followers').get();

      int totalFollowers = followersSnapshot.size;

      await _db.collection('ITJA Users').doc(userId).update({
        'Total followers': totalFollowers,
      });
    } catch (e) {
      log('Error deleting follower: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getFollowersWithDetails(String userId) async {
    try {
      QuerySnapshot followersSnapshot = await _db.collection('ITJA Users').doc(userId).collection('followers').get();

      List<Map<String, dynamic>> followersList = [];

      for (var doc in followersSnapshot.docs) {
        DocumentSnapshot userDoc = await _db.collection('ITJA Users').doc(doc.id).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          Map<String, dynamic> followerData = {
            'userId': doc.id,
            'name': userData['name'],
            'picurl': userData['picurl']
          };
          followersList.add(followerData);
        }
      }
      return followersList;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching followers with details: $e');
      }
      return [];
    }
  }

  static Future<bool> uploadProfileImage({required Uint8List file}) async {
    int imageSize = 400;
    int imageQuality = 80;
    try {
      // print('مرحله 1: گرفتن userId از کاربر فعال');
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (kDebugMode) {
          // print('No user is currently logged in.');
        }
        return false;
      }
      String userId = currentUser.uid;

      // print(' تبدیل داده‌های باینری تصویر به یک شیء تصویر');
      img.Image image = img.decodeImage(file)!;

      // print(' تغییر ساز تصویر');
      if (image.width == image.height) {
        image = img.copyResize(image, width: imageSize);
      } else if (image.width > image.height) {
        image = img.copyResize(image, height: imageSize);
        image = img.copyCrop(image, x: (image.width - imageSize) ~/ 2, y: 0, width: imageSize, height: imageSize);
      } else {
        image = img.copyResize(image, width: imageSize);
        image = img.copyCrop(image, x: 0, y: (image.height - imageSize) ~/ 2, width: imageSize, height: imageSize);
      }

      // print('${image.width} * ${image.height}');
      // print(' حجم تصویر (در بایت) را بررسی می‌کنیم');
      Uint8List compressedImage = Uint8List.fromList(img.encodeJpg(image, quality: imageQuality));

      // print(' آپلود فایل به Firebase Storage');
      Reference ref = _storage.ref().child('profile_images').child("${const Uuid().v1()}.jpg");
      UploadTask uploadTask = ref.putData(compressedImage);
      TaskSnapshot snapshot = await uploadTask;

      // print(' دریافت لینک دانلود');
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // print(' دریافت متادیتا فایل');
      FullMetadata metadata = await snapshot.ref.getMetadata();

      // print(' مرحله 2: ذخیره متادیتا در کالکشن ITJA images metadata');
      DocumentReference metadataRef = await _db.collection('ITJA images metadata').add({
        'userId': userId,
        'contentType': metadata.contentType,
        'size': metadata.size,
        'timeCreated': metadata.timeCreated,
        'fileName': metadata.name,
        'bucket': metadata.bucket,
        'downloadUrl': downloadUrl,
      });

      // print(' مرحله 3: ذخیره Document ID و لینک در کالکشن ITJA Users');
      await _db.collection('ITJA Users').doc(userId).update({
        'profile image metadata': metadataRef.id, // ذخیره Document ID
        'profile image url': downloadUrl, // ذخیره لینک دانلود تصویر
      });

      if (kDebugMode) {
        print('Profile image and metadata uploaded successfully.');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image and saving metadata: $e');
      }
      return false;
    }
  }

  static Future<void> deleteProfileImage() async {
    try {
      // مرحله 1: گرفتن userId از کاربر فعال
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (kDebugMode) {
          print('No user is currently logged in.');
        }
        return;
      }
      String userId = currentUser.uid;

      // مرحله 2: گرفتن Document ID از پروفایل کاربر
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('ITJA Users').doc(userId).get();

      // تبدیل داده‌ها به Map و بررسی وجود متادیتا
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData == null || !userData.containsKey('profile image metadata')) {
        if (kDebugMode) {
          print('No profile image metadata found for this user.');
        }
        return;
      }

      // گرفتن metadataId و لینک تصویر پروفایل
      String metadataId = userData['profile image metadata'];
      String profileImageUrl = userData['profile image url'];

      // مرحله 3: حذف فایل از Firebase Storage
      Reference fileRef = FirebaseStorage.instance.refFromURL(profileImageUrl);
      await fileRef.delete();

      // مرحله 4: حذف متادیتا از کالکشن ITJA images metadata
      await FirebaseFirestore.instance.collection('ITJA images metadata').doc(metadataId).delete();

      // مرحله 5: به‌روزرسانی پروفایل کاربر و حذف فیلدهای metadata و image url
      await FirebaseFirestore.instance.collection('ITJA Users').doc(userId).update({
        'profile image metadata': FieldValue.delete(), // حذف متادیتا
        'profile image url': FieldValue.delete(), // حذف لینک تصویر
      });

      if (kDebugMode) {
        print('Profile image and metadata deleted successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting profile image and metadata: $e');
      }
    }
  }

  static Future<bool> addNewPost({required Uint8List file}) async {
    int imageSize = 1080;
    int imageQuality = 80;
    try {
      // print('مرحله 1: گرفتن userId از کاربر فعال');
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (kDebugMode) {
          // print('No user is currently logged in.');
        }
        return false;
      }
      String userId = currentUser.uid;

      // print(' تبدیل داده‌های باینری تصویر به یک شیء تصویر');
      img.Image image = img.decodeImage(file)!;

      // print(' تغییر ساز تصویر');
      if (image.width == image.height) {
        image = img.copyResize(image, width: imageSize);
      } else if (image.width > image.height) {
        image = img.copyResize(image, height: imageSize);
        image = img.copyCrop(image, x: (image.width - imageSize) ~/ 2, y: 0, width: imageSize, height: imageSize);
      } else {
        image = img.copyResize(image, width: imageSize);
        image = img.copyCrop(image, x: 0, y: (image.height - imageSize) ~/ 2, width: imageSize, height: imageSize);
      }

      // print('${image.width} * ${image.height}');
      // print(' حجم تصویر (در بایت) را بررسی می‌کنیم');
      Uint8List compressedImage = Uint8List.fromList(img.encodeJpg(image, quality: imageQuality));

      // print(' آپلود فایل به Firebase Storage');
      Reference ref = _storage.ref().child('post_images').child("${const Uuid().v1()}.jpg");
      UploadTask uploadTask = ref.putData(compressedImage);
      TaskSnapshot snapshot = await uploadTask;

      // print(' دریافت لینک دانلود');
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // print(' دریافت متادیتا فایل');
      FullMetadata metadata = await snapshot.ref.getMetadata();

      // print(' مرحله 2: ذخیره متادیتا در کالکشن ITJA images metadata');
      DocumentReference metadataRef = await _db.collection('ITJA images metadata').add({
        'userId': userId,
        'contentType': metadata.contentType,
        'size': metadata.size,
        'timeCreated': metadata.timeCreated,
        'fileName': metadata.name,
        'bucket': metadata.bucket,
        'downloadUrl': downloadUrl,
      });

      // print(' مرحله 3: ذخیره Document ID و لینک در کالکشن ITJA Users');
      await _db.collection('ITJA Post').add({
        'userId': userId,
        'profile image metadata': metadataRef.id, // ذخیره Document ID
        'profile image url': downloadUrl, // ذخیره لینک دانلود تصویر
      });

      // await _db.collection('ITJA Users').doc(userId).collection('Post').doc();

      if (kDebugMode) {
        print('Profile image and metadata uploaded successfully.');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image and saving metadata: $e');
      }
      return false;
    }
  }
}

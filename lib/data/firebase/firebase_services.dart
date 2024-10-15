import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, Uint8List, defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

import '../model/owner.dart';
import '../model/post_model.dart';
import '../model/user_profile_model.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static final streamPost = FirebaseFirestore.instance.collection('ITJA Post').snapshots();

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
    required String bio,
  }) async {
    String res = "Some error Occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        MyUser myUser = MyUser(username: username, email: email, uid: cred.user!.uid, bio: bio);

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

  static Future<String> favouriteWorkSamplet(
      String workSampleId, String uid, List favourites) async {
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
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userIdToUnfollow);
      DocumentReference currentUserRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserId);

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
      String workSampleId = const Uuid().v1();
      CreatePostModel post = CreatePostModel(
        description: description,
        tags: '',
        likes: [],
      );
      await _db.collection('workSamples').doc(workSampleId).set(post.toJson());
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
  static Future<UserProfileModel?> getOwnerDetails() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      log('No user is currently logged in.');
      return null;
    }
    DocumentSnapshot documentSnapshot =
        await _db.collection('ITJA Users').doc(currentUser.uid).get();
    return UserProfileModel.fromSnap(documentSnapshot);
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
      QuerySnapshot followersSnapshot =
          await _db.collection('ITJA Users').doc(userId).collection('followers').get();

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
      await _db
          .collection('ITJA Users')
          .doc(userId)
          .collection('followers')
          .doc(followerId)
          .delete();

      // Total followers
      QuerySnapshot followersSnapshot =
          await _db.collection('ITJA Users').doc(userId).collection('followers').get();

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
      QuerySnapshot followersSnapshot =
          await _db.collection('ITJA Users').doc(userId).collection('followers').get();

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

  static Future<bool> uploadProfileImage({
    required Uint8List file,
    required int imageSize,
    required int imageQuality,
    required String imageDirectory,
  }) async {
    try {
      // 1. گرفتن userId از کاربر فعال
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (kDebugMode) {
          print('No user is currently logged in.');
        }
        return false;
      }
      String userId = currentUser.uid;

      // 2. پردازش و تغییر سایز تصویر
      img.Image? image = img.decodeImage(file);
      if (image == null) {
        if (kDebugMode) {
          print('Error decoding image');
        }
        return false;
      }

      if (image.width == image.height) {
        image = img.copyResize(image, width: imageSize);
      } else if (image.width > image.height) {
        image = img.copyResize(image, height: imageSize);
        image = img.copyCrop(image,
            x: (image.width - imageSize) ~/ 2, y: 0, width: imageSize, height: imageSize);
      } else {
        image = img.copyResize(image, width: imageSize);
        image = img.copyCrop(image,
            x: 0, y: (image.height - imageSize) ~/ 2, width: imageSize, height: imageSize);
      }

      Uint8List compressedImage = Uint8List.fromList(img.encodeJpg(image, quality: imageQuality));

      // 3. آپلود فایل به Firebase Storage
      Reference ref = _storage.ref().child(imageDirectory).child("${const Uuid().v1()}.jpg");
      UploadTask uploadTask = ref.putData(compressedImage);
      TaskSnapshot snapshot = await uploadTask;

      // 4. دریافت لینک دانلود و متادیتا
      String profileImageUrl = await snapshot.ref.getDownloadURL();
      FullMetadata metadata = await snapshot.ref.getMetadata();

      // 5. انجام تراکنش برای ذخیره اطلاعات در Firestore
      await _db.runTransaction((transaction) async {
        DocumentReference userRef = _db.collection('ITJA Users').doc(userId);

        // به‌روزرسانی اطلاعات پروفایل کاربر با متادیتای تصویر
        transaction.update(userRef, {
          'size': metadata.size,
          'timeCreated': metadata.timeCreated,
          'fileName': metadata.name,
          'profileImageUrl': profileImageUrl,
        });
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

  static Future<bool> deleteProfileImage() async {
    try {
      // 1. گرفتن userId از کاربر احراز هویت‌شده
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (kDebugMode) {
          print('No user is currently logged in.');
        }
        return false;
      }
      String userId = currentUser.uid;

      // 2. دریافت اطلاعات کاربر از Firestore
      DocumentReference userRef = _db.collection('ITJA Users').doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        if (kDebugMode) {
          print('User with ID $userId not found.');
        }
        return false;
      }

      // 3. دریافت downloadUrl و fileName از سند کاربر
      var userData = userSnapshot.data() as Map<String, dynamic>;
      String? downloadUrl = userData['downloadUrl'];
      String? fileName = userData['fileName'];

      if (downloadUrl == null || fileName == null) {
        if (kDebugMode) {
          print('No profile image data found.');
        }
        return false;
      }

      // 4. حذف فایل تصویر از Firebase Storage
      Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      await ref.delete(); // حذف فایل تصویر

      // 5. انجام تراکنش برای پاک کردن اطلاعات متادیتا در Firestore
      await _db.runTransaction((transaction) async {
        // حذف متادیتا مرتبط با تصویر از سند کاربر
        transaction.update(userRef, {
          'size': FieldValue.delete(),
          'timeCreated': FieldValue.delete(),
          'fileName': FieldValue.delete(),
          'profileImageUrl': FieldValue.delete(),
        });
      });

      if (kDebugMode) {
        print('Profile image and metadata deleted successfully.');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting profile image and metadata: $e');
      }
      return false;
    }
  }

  static Future<bool> addNewPost({
    required Uint8List file,
    required CreatePostModel post,
  }) async {
    int imageSize = 1080;
    int imageQuality = 80;

    try {
      // 1. دریافت کاربر احراز هویت‌شده
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (kDebugMode) {
          print('No user is currently logged in.');
        }
        return false;
      }
      String userId = currentUser.uid;

      // 2. دریافت اطلاعات کاربر (مانند username و profileImageUrl)
      DocumentSnapshot userSnapshot = await _db.collection('ITJA Users').doc(userId).get();
      if (!userSnapshot.exists) {
        if (kDebugMode) {
          print('User data not found.');
        }
        return false;
      }

      var userData = userSnapshot.data() as Map<String, dynamic>;
      String username = userData['username'] ?? 'Unknown User'; // دریافت username
      String bio = userData['bio'] ?? 'Unknown bio'; // دریافت username
      String profileImageUrl = userData['profileImageUrl'] ?? ''; // دریافت آدرس تصویر پروفایل

      // 3. پردازش و تغییر سایز تصویر پست
      img.Image? image = img.decodeImage(file);
      if (image == null) {
        if (kDebugMode) {
          print('Error decoding image');
        }
        return false;
      }

      if (image.width == image.height) {
        image = img.copyResize(image, width: imageSize);
      } else if (image.width > image.height) {
        image = img.copyResize(image, height: imageSize);
        image = img.copyCrop(image,
            x: (image.width - imageSize) ~/ 2, y: 0, width: imageSize, height: imageSize);
      } else {
        image = img.copyResize(image, width: imageSize);
        image = img.copyCrop(image,
            x: 0, y: (image.height - imageSize) ~/ 2, width: imageSize, height: imageSize);
      }

      Uint8List compressedImage = Uint8List.fromList(img.encodeJpg(image, quality: imageQuality));

      // 4. آپلود تصویر به Firebase Storage
      Reference ref = _storage.ref().child('post_images').child("${const Uuid().v1()}.jpg");
      UploadTask uploadTask = ref.putData(compressedImage);
      TaskSnapshot snapshot = await uploadTask;
      String postImageUrl = await snapshot.ref.getDownloadURL();
      FullMetadata metadata = await snapshot.ref.getMetadata();

      // 5. انجام تراکنش Firestore برای اضافه‌کردن پست و متادیتای تصویر
      await _db.runTransaction((transaction) async {
        // اضافه‌کردن پست به کالکشن 'ITJA Post'
        DocumentReference postRef = _db.collection('ITJA Post').doc();
        transaction.set(postRef, post.toJson());

        // به‌روزرسانی پست با متادیتای تصویر و اطلاعات کاربر (username و profileImageUrl)
        transaction.update(postRef, {
          'uid': userId,
          'postId': postRef.id,
          'size': metadata.size,
          'timeCreated': metadata.timeCreated,
          'fileName': metadata.name,
          'postImageUrl': postImageUrl,
          'username': username, // اضافه‌کردن username
          'profileImageUrl': profileImageUrl, // اضافه‌کردن آدرس تصویر پروفایل کاربر
          'bio': bio, // اضافه‌کردن آدرس تصویر پروفایل کاربر
        });

        // اضافه‌کردن پست به زیرمجموعه 'Post' در کالکشن 'ITJA Users'
        DocumentReference userPostRef =
            _db.collection('ITJA Users').doc(userId).collection('Post').doc(postRef.id);
        transaction.set(userPostRef, {
          'postId': postRef.id,
        });
      });

      if (kDebugMode) {
        print('Post and metadata uploaded successfully.');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading post and saving metadata: $e');
      }
      return false;
    }
  }

  static Future<bool> deletePost({required String postId}) async {
    try {
      // 1. پیدا کردن پست با استفاده از postId
      DocumentReference postRef = _db.collection('ITJA Post').doc(postId);
      DocumentSnapshot postSnapshot = await postRef.get();

      if (!postSnapshot.exists) {
        if (kDebugMode) {
          print('Post with ID $postId not found.');
        }
        return false;
      }

      var postData = postSnapshot.data() as Map<String, dynamic>;

      // 2. دریافت اطلاعات پست مثل downloadUrl و userId
      String? downloadUrl = postData['downloadUrl'];
      String? userId = postData['uid'];

      if (downloadUrl == null || userId == null) {
        if (kDebugMode) {
          print('Missing required post data.');
        }
        return false;
      }

      // 3. حذف فایل تصویر از Firebase Storage
      Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      await ref.delete(); // حذف فایل تصویر

      // 4. انجام تراکنش Firestore برای حذف اطلاعات پست و رکورد کاربر
      await _db.runTransaction((transaction) async {
        // حذف پست از کالکشن 'ITJA Post'
        transaction.delete(postRef);

        // حذف پست از زیرمجموعه 'Post' در کالکشن 'ITJA Users'
        DocumentReference userPostRef =
            _db.collection('ITJA Users').doc(userId).collection('Post').doc(postId);
        transaction.delete(userPostRef);
      });

      if (kDebugMode) {
        print('Post and related records deleted successfully.');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting post and metadata: $e');
      }
      return false;
    }
  }

  static Future<String> likePost(
      {required String postId, required String uid, required List likes}) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _db.collection('ITJA Post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _db.collection('ITJA Post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<String> score({
    required String postId,
    required String uid,
    required List likes,
    required int points,
  }) async {
    String res = "Some error occurred";
    try {
      final docRef = _db.collection('ITJA Post').doc(postId);

      if (points == 0) {
        // حذف uid از لیست likes و حذف points مربوط به آن uid
        await docRef.update({
          'likes': FieldValue.arrayRemove([uid]),
          'points.$uid': FieldValue.delete(), // حذف points مربوط به uid
        });
      } else {
        // اضافه کردن یا به‌روزرسانی points مربوط به uid
        await docRef.update({
          'likes': FieldValue.arrayUnion([uid]),
          'points.$uid': points, // به‌روزرسانی points برای uid
        });
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<String> postComment(
      {required String postId,
      required String comment,
      required String uid,
      required String userName,
      required String profileImageUrl}) async {
    String res = "Some error occurred";
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        _db.collection('ITJA Post').doc(postId).collection('comments').doc(commentId).set({
          'userName': userName,
          'uid': uid,
          'comment': comment,
          'commentId': commentId,
          'profileImageUrl': profileImageUrl,
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

  static Future<String> addCertificate({
    required String cerName,
  }) async {
    String res = "Some error occurred";
    try {
      if (cerName.isNotEmpty) {
        String cerId = const Uuid().v1();
        _db.collection('ITJA Certification').doc(cerId).set({
          'CertificationName': cerName,
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
}

// replies  comments

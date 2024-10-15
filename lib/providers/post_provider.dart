import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/firebase/firebase_services.dart';
import '../data/model/post_model.dart';
import '../data/model/reply_comment_model.dart';

final postProvider = ChangeNotifierProvider<PostProvider>((ref) => PostProvider());

class PostProvider with ChangeNotifier {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  Uint8List _image = Uint8List(0);
  final CreatePostModel _post = CreatePostModel(description: '', tags: '', likes: []);
  final ReplyCommentModel _reply = ReplyCommentModel(commentId: '',userName: '');

  Uint8List get image => _image;

  CreatePostModel get post => _post;

  ReplyCommentModel get  reply => _reply;

  Future<void> addImage({required Uint8List? file}) async {
    if(file!.isNotEmpty) {
      _image = file;
      notifyListeners();
    }
  }

  Future<void> addPost() async {
    _post.description = descriptionController.text;
    _post.tags = tagsController.text;
    notifyListeners();

    FirebaseServices.addNewPost(file: image, post: post);
  }
  Future<void> changeReply({required String commentId,required String userName}) async {
    _reply.commentId = commentId;
    _reply.userName = userName;
    notifyListeners();
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* 
this database stores posts that users have published in the app. 
It is stored in a collection called 'Posts' in Firebase 

Each post contains ; 

- a message 
- email of user
-  timestamp 
 */

class FirestoreDatabase{
  // current logged in user 

  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts from firebase 
  final CollectionReference posts = 
    FirebaseFirestore.instance.collection("Posts");

  // post a message 

  Future<void> addPost(String message){
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp':Timestamp.now(), 

    });
  }

  // read posts from database
  Stream<QuerySnapshot>getPostsStream(){
    final postsStream = FirebaseFirestore.instance
      .collection('Posts')
      .orderBy('TimeStamp', descending: true)
      .snapshots();

    return postsStream;
  }
}
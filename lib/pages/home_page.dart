import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_x/components/my_drawer.dart';
import 'package:insta_x/components/my_list_tile.dart';
import 'package:insta_x/components/my_post_button.dart';
import 'package:insta_x/components/my_textfield.dart';
import 'package:insta_x/database/firestore.dart';

class HomePage extends StatefulWidget {
     const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore access 
  final FirestoreDatabase database= FirestoreDatabase(); 

// text controller 
final TextEditingController newPostController = TextEditingController();

@override
void dispose(){
  // dispose of the controller 
  newPostController.dispose();
  super.dispose();
}



// post message 
void postMessage(){
  // only post message if there is something in the textfield
  String message = newPostController.text;

  try{
    database.addPost(message);

    // clear the textfield
    newPostController.clear();

    // show a SnackBar to the user

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post added successfully" ),
      ),
    );

  }catch (e){
    // Handle the exception

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error adding post" ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          title: const Text("W A L L"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
      ), 
          
          drawer: const MyDrawer(),
          body: Column(
            children: [
              // TEXTFIELD BOX  FOR USER TO TYPE 

              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    // textfield 

                    Expanded(
                      child: MyTextField(
                        hintText: "say something..", 
                        obsureText: false, 
                        controller: newPostController
                        ),
                    ),

                    // post button 

                    PostButton(
                      onTap: postMessage,
                    )

                  ],
                ),
              ),

              // POSTS 

              StreamBuilder(
                stream: database.getPostsStream(),
                 builder: (context, snapshot){
                  // show loading circle 

                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // get all posts 
                  final posts = snapshot.data!.docs;

                  // no data ?
                 

                  // return a list 
                  return Expanded(
                    child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context , index) {
                      // get each individual post 
                      final post = posts[index];

                      // get data from ech post 
                      String message = post['PostMessage'];
                      String userEmail = post['UserEmail'];
                      Timestamp timestamp = post['TimeStamp'];

                      // return as a list tile 
                      return MyListTile(title: message, subtitle: userEmail);
                    },
                 ),
               );

                 },
                )

            ],
          ),
        );
  }
}

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:insta_x/components/my_button.dart";
import "package:insta_x/components/my_textfield.dart";
import "../helper/helper_function.dart";

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
// Text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

 // register method
  void registerUser() async {
    // show loading circle

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure passwords match

    if (passwordController.text != confirmPwController.text) {
      // pop the loading circle

      Navigator.pop(context);

      //display error message to the user
      displayMessageToUser(" Passwords don't match! ", context);
    }

    // if passwords do match
    else {
      // try creating the user

      try {
        // create the user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // create a user document and add to firestore 
        createUserDocument(userCredential);

        // pop the loading circle

        if(context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // display error message to user
        displayMessageToUser(e.code, context);
      }
    }
  }

  // create a user document and collect them in firestore 

  Future<void>createUserDocument(UserCredential? userCredential) async {
    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance.
      collection("users").
      doc(userCredential.user!.email).
      set({
        'email':userCredential.user!.email,
        "username": usernameController.text,

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo

              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),

              // app name

              const Text(
                "I N S T A X",
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 50),

              // email textfield
              MyTextField(
                  hintText: "Username",
                  obsureText: false,
                  controller: usernameController),

              const SizedBox(height: 10),

              MyTextField(
                  hintText: "Email",
                  obsureText: false,
                  controller: emailController),

              const SizedBox(height: 10),

              // password textField
              MyTextField(
                hintText: "Password",
                obsureText: true,
                controller: passwordController,
              ),

              const SizedBox(height: 10),

              // confirm password textField
              MyTextField(
                hintText: "Confirm Password",
                obsureText: true,
                controller: confirmPwController,
              ),

              const SizedBox(height: 10),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "forgot Password ?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // register button
              MyButton(
                text: "Register",
                onTap: registerUser,
              ),

              // don't have an account ? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " Already have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:G3-main/lib/pages/dashboard.dart';

//import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import '../packages/pretty_login/values/values.dart';
// import '../packages/pretty_login/widgets/clipShadowPath.dart';
// import '../packages/pretty_login/widgets/custom_button.dart';
// import '../packages/pretty_login/widgets/custom_shape_clippers.dart';
// import '../packages/pretty_login/widgets/custom_text_form_field.dart';
// import '../packages/pretty_login/widgets/spaces.dart';

import 'package:get/get.dart';

import '../widgets/centered_view/centered_view.dart';

class LoginScreen4 extends StatefulWidget {
  static const String route = '/';
  @override
  _LoginScreen4State createState() => _LoginScreen4State();
}

class _LoginScreen4State extends State<LoginScreen4> {
  final username_controller = TextEditingController();
  // ignore: non_constant_identifier_names
  final password_controller = TextEditingController();

// Initialize the FirebaseUI Widget using Firebase.

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    username_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      return Container(
          color: Colors.grey[300],
          padding: constraints.maxWidth < 400
              ? EdgeInsets.zero
              : const EdgeInsets.all(50.0),
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
              constraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 16, color: Colors.grey)],
                color: Color.fromARGB(255, 242, 242, 242),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('images/g3_logo.png'),
                          fit: BoxFit.cover,
                        ))),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: username_controller,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon:
                                Icon(Icons.email, color: Colors.deepPurple)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: password_controller,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.deepPurple)),
                      ),
                    ),
                    RaisedButton(
                        color: Color.fromRGBO(103, 58, 183, 1),
                        child: Text("Login",
                            style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () async {
                          try {
                            var logResult = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: username_controller.text,
                                    password: password_controller.text);
                            print(logResult.user.displayName);
                            print(logResult.user.email);
                            print(logResult.user.photoUrl);
                            print(logResult.user.uid);
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Success Login'),
                                  backgroundColor: Colors.green),
                            );
                            Get.toNamed('/dashboard');
                          } catch (er) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(er.toString()),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 5),
                            ));
                          }
                        })
                  ]),
            ),
          ));
    }));
  }
}

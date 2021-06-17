import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musopathy/models/data.dart';
import 'package:musopathy/models/adduser.dart';
import 'package:musopathy/screens/languagePage.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  Registerwidget createState() => Registerwidget();
}

class Registerwidget extends State<Register> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _emailsignin = TextEditingController();
  TextEditingController _passwordsignin = TextEditingController();
  TextEditingController _username = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  TextEditingController _passwordretype = TextEditingController();
  bool showspinner = false;

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    hintText: "username",
                    labelText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailsignin,
                  decoration: InputDecoration(
                    hintText: "something@example.com",
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _passwordsignin,
                  obscureText: true,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "enter password";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    labelText: "password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordretype,
                  obscureText: true,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "enter password";
                    }
                    if (_passwordretype.text != _passwordsignin.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                height: 45,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showspinner = true;
                    });
                    if (_formkey.currentState.validate()) {
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: _emailsignin.text.trim(),
                                password: _passwordsignin.text.trim());

                        if (newUser != null) {
                          Provider.of<Data>(context, listen: false).login();
                          var user = AddUser(_username.text, false, 7050818912,
                              newUser.user.email, newUser.user.photoURL);
                          user.addUser();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => Language()));
                          //  print(email);
                        }
                        setState(() {
                          showspinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    }
                    _formkey.currentState.reset();
                  },
                  child: Text("Register"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      primary: Colors.blueGrey,
                      onPrimary: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

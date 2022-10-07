import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {

  String name;
  String email;
  Home(this.name,this.email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Home")),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customText(name),
              customText(email),
              ElevatedButton(
                child: const Text("Log out"),
                onPressed: ()async{
                  var prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Timer(const Duration(seconds: 2), () {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customText(text){
  return Text(text,style: TextStyle(fontSize: 20),);
}
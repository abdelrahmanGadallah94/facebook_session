import 'dart:async';

import 'package:facebook_session/screens/login1.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home1 extends StatefulWidget {
  String name;
  String Email;
  Home1({required this.name,required this.Email});
  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  RoundedLoadingButtonController logout_btn = RoundedLoadingButtonController();
  //loading button
  Widget LoadingButton(){
    return RoundedLoadingButton(
      borderRadius: 5,
      width: MediaQuery.of(context).size.width * .4,
      child: Text("Log Out"),
      onPressed: () async {
        var prefs = await SharedPreferences.getInstance();
        await prefs.setBool("logging_state", false);
        logout_btn.success();
        Timer(Duration(seconds: 2), () {
          logout_btn.reset();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login1()));
        });
      },
      controller: logout_btn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Home"),),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(widget.name),
              CustomText(widget.Email),
              SizedBox(height: 10,),
              LoadingButton()
            ],
          ),
        ),
      ),
    );
  }
}

Widget CustomText(text){
  return Text(text,style: TextStyle(fontSize: 20),);
}
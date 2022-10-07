import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // text editting control
  var txt_phone = TextEditingController();
  var txt_pass = TextEditingController();

  var loading_btn = RoundedLoadingButtonController();


  //initstate fnc
  @override
  void initState() {
    txt_phone.text = "0109";
    txt_pass.text = "12345678";
    getData();
    super.initState();
  }

  //sign in fnc
  Future<void> signIn() async {

    if (txt_phone.text.isEmpty) {
      alert("you must enter your phone");
      loading_btn.error();
      Timer(Duration(seconds: 1), () {
        loading_btn.reset();
      });
    } else if (txt_pass.text.isEmpty) {
      alert("you must enter password");
      loading_btn.error();
      Timer(Duration(seconds: 1), () {
        loading_btn.reset();
      });
    } else {
      var headers = {
        "x-api-key":
        "Vj4zMT4y0tU90btNDTcYuy87H9fnzZD33zOTjw7dSxXmEHJ4wDGIUGKs0BnF"
      };
      var body = {"mobile": txt_phone.text, "password": txt_pass.text};
      var url = Uri.parse("https://tavolobooking.com/api/login");
      var response = await http.post(url, headers: headers, body: body);

      var data = jsonDecode(response.body);

      String name = data["data"]["name"];
      String email = data["data"]["email"];

      if (response.statusCode == 200) {
        loading_btn.success();
        // call saveddata fnc
        savedData(name, email);

        Timer(Duration(milliseconds: 1000), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => Home(name,email)));
        });
      } else if (response.statusCode == 404) {
        alert("not found");
        loading_btn.error();
        Timer(Duration(seconds: 1), () {
          loading_btn.reset();
        });
      } else {
        alert(data["error"]);
        loading_btn.error();
        Timer(Duration(seconds: 1), () {
          loading_btn.reset();
        });
      }
    }
  }

  // alert fnc
  void alert(msg) {
    Flushbar(
      message: msg,
      title: "Error",
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 4),
      borderRadius: BorderRadius.circular(15),
      icon: Icon(
        Icons.highlight_remove_outlined,
        size: 25,
        color: Colors.white,
      ),
    ).show(context);
  }

  // loading button fnc
  Widget ladingButton() {
    return RoundedLoadingButton(
        controller: loading_btn,
        height: 55,
        width: MediaQuery.of(context).size.width * .9,
        color: Color(0xff223b73),
        borderRadius: 5,
        onPressed: signIn,
        child: Text(
          "Login",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        ));
  }


  //saved data fnc
  Future<void> savedData(name,email) async {
    // 1- create the folder to store the setting s on my phone
    var prefs = await SharedPreferences.getInstance();

    //2- set name
    await prefs.setString("user_name",name);
    await prefs.setString("user_email",email);
    await prefs.setBool("logged_in", true);
  }

  //get data from localstorage
  getData() async {
    var prefs = await SharedPreferences.getInstance();

    var name = prefs.getString("user_name") ?? "Guest";
    var email = prefs.getString("user_email") ?? "_";
    var loggedIn = prefs.getBool("logged_in") ?? false;
    var phone = prefs.getString("user_phone") ?? "0109";

    if(loggedIn){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home(name,email)));
    }

  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2d4a88),
      body: SafeArea(
        top: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 80),
                        child: Image.asset(
                          "images/logo.png",
                          height: 90,
                          width: 250,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.center,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: TextField(
                          controller: txt_phone,
                          decoration: InputDecoration(
                              hintText: "Email or Phone number",
                              hintStyle: TextStyle(fontSize: 18),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.center,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: TextField(
                          controller: txt_pass,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(fontSize: 18),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ladingButton(),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Forget Password ?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(20),
                child: Text(
                  "Sign Up for Facebook",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

/**
 *  "x-api-key":"Vj4zMT4y0tU90btNDTcYuy87H9fnzZD33zOTjw7dSxXmEHJ4wDGIUGKs0BnF"
 *  "mobile": txt_phone.text, "password": txt_pass.text
 */
/*
*   void signIn() async {
* var txt_phone = TextEditingController();
  var txt_pass = TextEditingController();

  var btn_login = RoundedLoadingButtonController();
    if (txt_phone.text.isEmpty) {
      error("please enter username");
    } else if (txt_pass.text.isEmpty) {
      error("please enter your password");
    } else {
      var url = Uri.parse("https://tavolobooking.com/api/login");
      var headers = {
        "x-api-key":
            "Vj4zMT4y0tU90btNDTcYuy87H9fnzZD33zOTjw7dSxXmEHJ4wDGIUGKs0BnF"
      };
      var body = {"mobile": txt_phone.text, "password": txt_pass.text};
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        btn_login.success();
      } else if (response.statusCode == 404) {
        error("not found");
        btn_login.error();
        Timer(Duration(seconds: 1), () {btn_login.reset();});
      } else {
        error("The Mobile or password maybe not correct");
        btn_login.error();
        Timer(Duration(seconds: 1), () {btn_login.reset();});
      }
    }
  }

  //error message
  void error(msg) {
    Flushbar(
      borderRadius: BorderRadius.circular(10),
      title: "Error",
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.highlight_remove_outlined,
        color: Colors.white,
        size: 25,
      ),
      backgroundColor: Colors.red,
      message: msg,
    ).show(context);
  }

  // rounded loadin button
  Widget LoadingButton() {
    return RoundedLoadingButton(
      controller: btn_login,
      onPressed: signIn,
      color: Color(0xff223b73),
      height: 55,
      width: MediaQuery.of(context).size.width * .9,
      borderRadius: 20,
      child: Text(
        "log In",
        style: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
      ),
      successColor: Colors.green,
    );
  }
* */

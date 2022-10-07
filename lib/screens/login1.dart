import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/widget/custom textbutton.dart';
import '../settings/colors.dart';
import 'package:http/http.dart' as http;

import 'home1.dart';
class Login1 extends StatefulWidget {


  @override
  State<Login1> createState() => _Login1State();
}

class _Login1State extends State<Login1> {

  TextEditingController txt_phone = TextEditingController();
  TextEditingController txt_Pass = TextEditingController();
  RoundedLoadingButtonController loading_btn = RoundedLoadingButtonController();

  //1- sign in fnc
  signIn() async {
    if(txt_phone.text.isEmpty){
      alert("email can not be empty");
      loading_btn.error();
      Timer(Duration(seconds: 1), () { loading_btn.reset();});
    }else if(txt_Pass.text.isEmpty){
      alert("password can not be empty");
      loading_btn.error();
      Timer(Duration(seconds: 1), () { loading_btn.reset();});
    }else{
      var headers = {"x-api-key": "Vj4zMT4y0tU90btNDTcYuy87H9fnzZD33zOTjw7dSxXmEHJ4wDGIUGKs0BnF"};
      var body = {"mobile": txt_phone.text,"password": txt_Pass.text};
      var url = await Uri.parse("https://tavolobooking.com/api/login");
      var response = await http.post(url,headers: headers,body: body);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        var name = data["data"]["name"];
        var email = data["data"]["email"];
        loading_btn.success();
        Timer(
          Duration(seconds: 3),
            ()=>loading_btn.reset()
        );
        Timer(
          Duration(seconds: 2),(){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Home1(name: name,Email: email))
          );
        });

        //call savedata fnc
        saveData(name,email);

      }else if(response.statusCode == 404){
        alert("not found");
        loading_btn.error();
        Timer(Duration(seconds: 1), () { loading_btn.reset();});
      }else{
        alert("not valid");
        loading_btn.error();
        Timer(Duration(seconds: 1), () { loading_btn.reset();});
      }
    }
  }
  //2- alert fnc
  alert(msg){
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      title: "Error",
      icon: Icon(Icons.highlight_remove_outlined,color: colors.white,size: 25,),
      message: msg,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ).show(context);
  }

  //3- loading button
  Widget LoadingButton(){
    return RoundedLoadingButton(
      color: colors.button_color,
      width: MediaQuery.of(context).size.width * .9,
      borderRadius: 5,
      height: 55,
      controller: loading_btn,
      child: Text("Log In",style: TextStyle(color: colors.white,fontSize: 22,fontWeight: FontWeight.w500),),
      onPressed: signIn,
    );
  }

   //4-init state fnc
  @override
  void initState() {
    txt_phone.text = "0109";
    txt_Pass.text = "12345678";

    //call getdata fnc
    getData();

    super.initState();
  }

  //5- saved data
  saveData(name,email) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
    await prefs.setString("email", email);
    await prefs.setBool("logging_state", true);
  }

  //get data
  getData() async {
    var prefs = await SharedPreferences.getInstance();
    var name = await prefs.getString("name") ?? "Guest";
    var email = await prefs.getString("email") ?? "_";
    var logging_state = await prefs.getBool("logging_state") ?? false;

    if(logging_state == true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home1(name: name, Email: email)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.blue,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 60),
                        child: Image.asset("images/logo.png",height: 90,),
                      ),
                      Container(
                        height: 55,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: colors.white,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: TextFormField(
                          controller: txt_phone,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(fontSize: 18),
                            border: InputBorder.none
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        height: 55,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: TextFormField(
                          controller: txt_Pass,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.remove_red_eye),
                              hintText: "Enter password",
                              hintStyle: TextStyle(fontSize: 18),
                              border: InputBorder.none,
                          ),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 20,),
                      LoadingButton(),
                      SizedBox(height: 20,),
                      CustomTextButton(text: "Forgot Password?",)
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Sign Up For Facebook",
                      style: TextStyle(
                        fontSize: 18,color: colors.white,decoration: TextDecoration.underline
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


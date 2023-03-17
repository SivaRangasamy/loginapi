import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loginapifunc/DetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool doNotShowPassword = true;
  bool checkValue = true;
  Map<String,dynamic> data={};
  String accessToken="";
  bool exitApp = false;
  bool loader=false;

  validateFunc()async{
    if(_nameController.text==""||_passwordController.text==""){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      setState(() {
        loader=false;
      });
    }else{
      if(checkValue){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user_name", _nameController.text);
        prefs.setString("pass_word", _passwordController.text);
      }
      await apiFunc();
    }
  }

  apiFunc() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse("https://www.pearlcons.com/hrms/pearlchrms/api/login");
    var response = await http.post(url, body: {
      "username": _nameController.text,
      "password": _passwordController.text,
    });
    var responseData = json.decode(response.body);
    print(responseData);
    if (responseData["status"]=="000") {
      accessToken=responseData['access_token'];
      print(accessToken);
      data=responseData['user'][0];
      print(data);
      prefs.setString("token", accessToken);
      if(mounted){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DetailsPage(data: data,)));
      }
      setState(() {
        loader=false;
      });
    }
    else{
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData["message"])));
      }
      setState(() {
        loader=false;
      });
    }
  }

  cacheFunc() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uName=prefs.getString('user_name');
    String? pWord=prefs.getString('pass_word');
    if (uName!= null) {
      print("hello");
      _nameController.text=uName;
      _passwordController.text=pWord!;
    }
    else{
      print("no value received");
      _nameController.text="";
      _passwordController.text="";
    }
  }

  @override
  void initState() {
    cacheFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        setState(() {
          exitApp = !exitApp;
          Future.delayed(const Duration(seconds: 3), () {
            exitApp = !exitApp;
          });
        });
        if (exitApp) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 10.0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            content: const Text(
              "Are you sure to exit!",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  fontSize: 15),
            ),
            margin: const EdgeInsets.all(80),
          ));
        }
        else {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        }
        return false as Future<bool>;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            "Login",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Username"),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  hintText: "Enter username",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Password"),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                obscureText: doNotShowPassword,
                controller: _passwordController,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        doNotShowPassword = !doNotShowPassword;
                      });
                    },
                    child: doNotShowPassword
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                            size: 25,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.blue,
                            size: 25,
                          ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  hintText: "Enter password",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: CheckboxListTile(
                        value: checkValue,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("Remember me"),
                        onChanged: (value) {
                          setState((){
                            checkValue=!checkValue;
                          });
                          if (kDebugMode) {
                            print(value);
                          }
                        }),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              loader?const Center(child: CircularProgressIndicator()):Center(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loader=true;
                      });
                      validateFunc();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Text("Login"),
                    )),
              )
            ],
          ),
        ),
      )),
    );
  }
}

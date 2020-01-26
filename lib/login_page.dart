import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2000);

  Future<String> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async{

      var response = await http.post(globals.mainURL+'/login', body: {'email': data.name, 'password': data.password});

      if(response.statusCode == 200){
        final resp = json.decode(response.body);
        if(resp['status'] != "success"){
          return "Wrong username or password";
        }
        globals.userID = resp['msg'];
        return null;
      }else{
        return "The server experiences an error";
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {

      return 'Not Working!';
      
      // Return Null when working
      // return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
            title: 'Schedule Builder',
            onLogin: _authUser,
            onSignup: _authUser,
            onSubmitAnimationCompleted: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DashboardScreen(),
              ));
            },
            onRecoverPassword: _recoverPassword,
          );
  }
}

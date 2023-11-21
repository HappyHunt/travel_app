import 'package:flutter/cupertino.dart';
import 'package:travel_app/pages/login/sign_up_page.dart';

import 'login_page.dart';

class LoginAndSignUp extends StatefulWidget{
  const LoginAndSignUp({super.key});

  @override
  State<LoginAndSignUp> createState() => _LoginAndSignUp();
}

class _LoginAndSignUp extends State<LoginAndSignUp>{
  bool isLogin = true;

  void togglePage() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin){
      return LoginPage(
          onPressed : togglePage
      );
    }else {
      return SignUp(
          onPressed : togglePage
      );
    }
  }


}
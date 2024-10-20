import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var obscureText = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> userLoginOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('token') ?? '';
    print("=============------${token}");
    if (token != "") {
      Get.offAllNamed("/home");
    } else {
      Get.offAllNamed("/login");
    }
  }

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<void> login() async {
    try {
      Get.dialog(
        Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1)
          ),
          child: Center(child: CircularProgressIndicator(color: Colors.blueGrey[700],)),)
      );
      UserCredential userCradential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCradential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", userCradential.user!.uid);
        Get.offAllNamed('/home');
        errorMessage.value = "";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage.value = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage.value = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage.value = 'Invalid email format. Please check your email.';
      } else if (e.code == 'user-disabled') {
        errorMessage.value = 'This user has been disabled.';
      } else {
        errorMessage.value = 'Login failed. Please check your credentials.';
      }
    } catch (e) {
      errorMessage.value = 'Login failed. Please check your credentials.';
    }finally{
      Get.back();
    }
  }

}

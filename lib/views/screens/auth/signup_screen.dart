import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TikTok',
              style: TextStyle(
                fontSize: 35,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Register',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Stack(
              children: [
                Obx(() => authController.isImagePicked.value != 1
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://beforeigosolutions.com/wp-content/uploads/2021/12/dummy-profile-pic-300x300-1.png'),
                        backgroundColor: Colors.black,
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage:
                            FileImage(authController.profilePhoto!),
                      )),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                      onPressed: () {
                        authController.pickImage();
                      },
                      icon: const Icon(Icons.add_a_photo)),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _usernameController,
                icon: Icons.person,
                labelText: 'Username',
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _emailController,
                icon: Icons.email,
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _passwordController,
                icon: Icons.lock,
                labelText: 'Password',
                isObscure: true,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: InkWell(
                onTap: () {
                  if (authController.profilePhoto != null) {
                    authController.registerUser(
                        _usernameController.text,
                        _emailController.text,
                        _passwordController.text,
                        authController.profilePhoto);
                  } else {
                    Get.snackbar('Profile Picture',
                        'Please select your profile picture');
                  }
                },
                child: Center(
                  child: Obx(() => !authController.isLoding.value
                      ? const Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                        )),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    Get.offAll(LoginScreen());
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: buttonColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

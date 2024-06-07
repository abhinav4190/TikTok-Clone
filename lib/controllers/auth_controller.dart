import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/models/users.dart' as models;
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late final Rx<User?> _user;
  final Rx<bool> isLoding = Rx<bool>(false);
  final Rx<File?> _pickedImage = Rx<File?>(null);
  final Rx<int> isImagePicked = Rx<int>(0);

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setIntialScreen);
  }

  _setIntialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
      isImagePicked.value = 1;
      _pickedImage.value = File(pickedImage.path);
    }
  }

  // upload to firebase storage
  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    Uint8List bytes = image.readAsBytesSync(); //THIS LINE
    TaskSnapshot snapshot = await ref.putData(bytes); //THIS LINE
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering the user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        isLoding.value = true;
        // save out user to our auth and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);
        models.User user = models.User(
            name: username,
            email: email,
            uid: cred.user!.uid,
            profilePhoto: downloadUrl);
        await fireStore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        isLoding.value = false;
      } else {
        Get.snackbar('Error Creating Account', 'Please enter all the fields');
      }
    } catch (e) {
      isLoding.value = false;
      Get.snackbar('Error Creating Account', e.toString());
    }
  }

  //login user

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        isLoding.value = true;
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        isLoding.value = false;
      } else {
        Get.snackbar('Error Logging in', 'Please enter all the fields');
      }
    } catch (e) {
      isLoding.value = false;
      Get.snackbar('Error Loggingin', e.toString());
    }
  }

  signOut() async {
    await firebaseAuth.signOut();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/views/screens/confirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConfirmScreen(
                videoFile: File(video.path),
                videoPath: video.path,
              )));
    }
  }

  showOptionsDialog(BuildContext cx) {
    return showDialog(
        context: cx,
        builder: (cx) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () => pickVideo(ImageSource.gallery, cx),
                  child: const Row(
                    children: [
                      Icon(Icons.image),
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.all(7),
                        child: Text(
                          'Gallery',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => pickVideo(ImageSource.camera, cx),
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.all(7),
                        child: Text(
                          'Camera',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                     Navigator.pop(cx);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.cancel),
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.all(7),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            showOptionsDialog(context);
          },
          child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
                color: buttonColor, borderRadius: BorderRadius.circular(8)),
            child: const Center(
              child: Text(
                'Add Video',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

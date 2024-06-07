import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  final Rx<bool> isLoding = Rx<bool>(false);

  static UploadVideoController instance = Get.put(UploadVideoController());
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    File videoThumbnail = await _getThumbnail(videoPath);
    Uint8List bytes = videoThumbnail.readAsBytesSync();
    TaskSnapshot snap = await ref.putData(bytes);
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // upload video

  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      isLoding.value = true;
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await fireStore.collection('users').doc(uid).get();
      var allDocs = await fireStore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      Video video = Video(
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          id: "Video $len",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
          thumbnail: thumbnail);

      await fireStore
          .collection('videos')
          .doc('Video $len')
          .set(video.toJson());
      Get.back();
      isLoding.value = false;
    } catch (e) {
      isLoding.value = false;
      Get.snackbar('Error Uploading Video', e.toString());
    }
  }
}

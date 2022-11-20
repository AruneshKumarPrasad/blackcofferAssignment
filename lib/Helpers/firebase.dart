import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class FireHelp {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> fireSignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void fireLoginWithPhone(
      {required String number, required BuildContext context}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {}
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        Navigator.pushNamed(context, 'verify',
            arguments: <String>[verificationId]);
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

  Future<String?> fireReceiveCodeAndLogin(String verID, String sCode) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verID,
      smsCode: sCode,
    );
    // Sign the user in (or link) with the credential
    final userCred = await auth.signInWithCredential(credential);
    return userCred.user?.uid;
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  void fireFetchExplore() {}

  Future<void> fireAddData(Model profile) async {
    await db.collection("videos").doc(profile.videoID).set(
      {
        "ID": profile.profileID,
        "VideoID": profile.videoID,
        "Name": profile.titleOfVideo,
        "Description": profile.description,
        "Category": profile.category,
        "Location": profile.locationOfVideo,
        "VideoURL": profile.urlOfVideo,
        "ThumbURL": profile.urlOfThumbnail,
      },
    );
  }

  Reference referenceRoot = FirebaseStorage.instance.ref();

  double percentDone = 0;

  Future<String?> fireStorageUpload(
      {required File fileToUpload,
      required Model profile,
      required bool isVideo}) async {
    Reference referenceDirImages =
        referenceRoot.child('videos').child(profile.videoID);
    Reference referenceForUpload = isVideo
        ? referenceDirImages
            .child("video_upload")
            .child("video${profile.videoID}")
        : referenceDirImages
            .child("thumb_upload")
            .child("pic${profile.videoID}");
    try {
      //Store the file on Database
      await referenceForUpload.putFile(fileToUpload);
      //Get and Store the URL from Database
      final url = await referenceForUpload.getDownloadURL();
      return url;
    } catch (error) {
      return null;
    }
  }

  Future<void> startDelete(
      {required Model profile, required BuildContext ctx}) async {
    // Delete Data
    db.collection("videos").doc(profile.videoID).delete().then(
          (doc) => ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text("Deleted"),
              ),
              behavior: SnackBarBehavior.floating,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              duration: const Duration(milliseconds: 750),
            ),
          ),
          onError: (e) => ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text("Delete Failed"),
              ),
              behavior: SnackBarBehavior.floating,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              duration: const Duration(milliseconds: 750),
            ),
          ),
        );

    // Delete video ref
    Reference referenceDir =
        referenceRoot.child('videos').child(profile.videoID);
    Reference referenceForUploadedVideo =
        referenceDir.child("video_upload").child("video${profile.videoID}");
    // Delete video here
    await referenceForUploadedVideo.delete();

    // Delete thumbnail ref
    Reference referenceForUploadedThumbnail =
        referenceDir.child("thumb_upload").child("pic${profile.videoID}");
    // Delete thumbnail here
    await referenceForUploadedThumbnail.delete();
  }
}

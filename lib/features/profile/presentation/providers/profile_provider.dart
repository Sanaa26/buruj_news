import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileImageNotifier extends Notifier<File?> {
  @override
  File? build() => null;

  void setImage(File image) {
    state = image;
  }
}

final profileImageProvider = NotifierProvider<ProfileImageNotifier, File?>(() {
  return ProfileImageNotifier();
});

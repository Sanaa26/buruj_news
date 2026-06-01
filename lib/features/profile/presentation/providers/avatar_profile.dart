import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvatarNotifier extends Notifier<String> {
  @override
  String build() => "seed1";

  void setAvatar(String seed) {
    state = seed;
  }
}

final avatarProvider = NotifierProvider<AvatarNotifier, String>(() {
  return AvatarNotifier();
});

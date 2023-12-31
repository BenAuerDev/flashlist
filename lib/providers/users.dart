import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlist/models/notification.dart';
import 'package:flashlist/models/user.dart';
import 'package:flashlist/providers/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final currentUserDataProvider = StreamProvider((ref) {
  final userData = ref.watch(authProvider).value;

  if (userData != null) {
    var docRef =
        FirebaseFirestore.instance.collection('users').doc(userData.uid);
    return docRef.snapshots().map((snapshot) => snapshot.data());
  } else {
    return const Stream.empty();
  }
});

final userNotificationStreamProvider = StreamProvider<List<UserNotification>>(
  (ref) async* {
    try {
      yield* ref.watch(firestoreServiceProvider).userNotificationsStream();
    } catch (error) {
      throw StateError("failed to get user's notifications: $error");
    }
  },
);

final userUnreadNotificationsCountProvider = StreamProvider.autoDispose(
  (ref) {
    try {
      return ref
          .watch(firestoreServiceProvider)
          .userUnreadNotificationsCountStream();
    } catch (error) {
      throw StateError(
          "failed to get user's unread notifications count: $error");
    }
  },
);

final getUserByUidProvider =
    FutureProvider.family<CustomUser, String>((ref, userUid) async {
  try {
    return ref.watch(firestoreServiceProvider).getUserByUid(userUid);
  } catch (error) {
    throw StateError("failed to get user by uid: $error");
  }
});

final getUserByEmailProvider =
    FutureProvider.family<CustomUser?, String>((ref, email) async {
  try {
    return ref.watch(firestoreServiceProvider).getUserByEmail(email);
  } catch (error) {
    throw StateError("failed to get user by email: $error");
  }
});

final uploadUserAvatarProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
  try {
    return ref.watch(firestoreServiceProvider).uploadUserAvatar(
          data['pickedImage'],
          data['userUid'],
        );
  } catch (error) {
    throw StateError("failed to upload user avatar: $error");
  }
});

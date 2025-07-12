import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../app/routes.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final box = GetStorage();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      final role = userDoc.data()?['role'] ?? 'user';
      box.write('user_role', role);
      print("Role $role");

      Get.offAllNamed(Routes.dashboard, arguments: {'role': role});
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password, String role) async {
    try {
      isLoading.value = true;
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'email': email, 'role': role});
      box.write('user_role', role);
      print("Role $role");

      Get.offAllNamed(Routes.dashboard, arguments: {'role': role});
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.code} - ${e.message}');
      Get.snackbar('Registration Error', e.message ?? 'Something went wrong');
    } catch (e) {
      print('❌ Unknown Exception: $e');
      Get.snackbar('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.login);
  }
}

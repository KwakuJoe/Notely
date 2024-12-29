import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  // final _box = GetStorage(); // Use GetStorage for persistence
  var userId = ''.obs;
  var isLoggingOut = false.obs;
  var isLoggingInGoogle = false.obs;
  var isLoggingInLocal = false.obs;
  var isSigningUpLocal = false.obs;
  final supabase = Supabase.instance.client;
  var user = const User(
          id: '', appMetadata: {}, userMetadata: {}, aud: '', createdAt: '')
      .obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Retrieve saved theme state
  //   isDarkMode.value = _box.read('isDarkMode') ?? false;
  //   Get.changeTheme(isDarkMode.value ? AppThemes.darkTheme : AppThemes.lightTheme);
  // }

  // void toggleTheme() {
  //   isDarkMode.value = !isDarkMode.value;
  //   _box.write('isDarkMode', isDarkMode.value); // Save state
  //   Get.changeTheme(isDarkMode.value ? AppThemes.darkTheme : AppThemes.lightTheme);
  // }

  User? displayUserInfo(){
    return supabase.auth.currentSession?.user;
  }

  Future<void> googleSignIn() async {
    isLoggingInGoogle.value = true;

    try {
      /// Web Client ID that you registered with Google Cloud.
      const webClientId =
          '127577894542-99us9tt4frck720o3e253gmu0li7be02.apps.googleusercontent.com';

      /// TODO: update the iOS client ID with your own.
      ///
      /// iOS Client ID that you registered with Google Cloud.
      const iosClientId =
          '127577894542-ls448srhttj423vu11hs7norkntnuma2.apps.googleusercontent.com';

      // Google sign in on Android will work without providing the Android
      // Client ID registered on Google Cloud.

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        isLoggingInGoogle.value = false;

        // throw 'No Access Token found.';
        Get.snackbar('Error Logging in', 'No Access Token found.',
            icon: const Icon(Icons.error_outline),
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
      if (idToken == null) {
        isLoggingInGoogle.value = false;
        Get.snackbar('Error Logging in', 'No ID Token found.',
            icon: const Icon(Icons.error_outline),
            backgroundColor: Colors.red,
            colorText: Colors.white);
        // throw 'No ID Token found.';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken ?? '',
        accessToken: accessToken,
      );

        // Get.offAllNamed('/');

    } on AuthException catch (error) {
      Get.snackbar('Error Logging in', error.message,
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (error) {
      debugPrint('$error');
      isLoggingInLocal.value = false;
      Get.snackbar('Error Logging in', error.toString(),
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }

    ///

    isLoggingInGoogle.value = false;
  }

  Future<void> logout() async {
    isLoggingOut.value = true;

    try {
      await supabase.auth.signOut();
      isLoggingOut.value = false;
      Get.snackbar('Logged out successfully',
          'You have successfully logged out of you account',
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.green,
          colorText: Colors.white);
      // Get.offAllNamed('/login');
    } catch (error) {
      Get.snackbar('Error Logging out', error.toString(),
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.red,
          colorText: Colors.white);
      isLoggingOut.value = false;
      debugPrint('$error');
    }
  }

  Future<void> loginLocal(String email, String password) async {
    isLoggingInLocal.value = true;
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // final Session? session = res.session;
      user.value = res.user!;
      isLoggingInLocal.value = false;
      Get.snackbar('Logged in successfully',
          'You have successfully logged in of you account',
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.green,
          colorText: Colors.white);
        Get.offAllNamed('/');
    } on AuthException catch (error) {
      isLoggingInLocal.value = false;
      Get.snackbar('Error Logging in', error.message,
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (error) {
      debugPrint('$error');
      isLoggingInLocal.value = false;
      Get.snackbar('Error Logging in', error.toString(),
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }


  Future<void> signupLocal(
      String email, String password, String fullName) async {
    isSigningUpLocal.value = true;
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      // final Session? session = res.session;
      user.value = res.user!;
      isSigningUpLocal.value = false;
      debugPrint('signup -message ${res.session.toString()}');
      Get.snackbar('Sign up in successfully',
          'Now log in with your newly created account',
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.green,
          colorText: Colors.white);
        Get.offAllNamed('/login');
    } on AuthException catch (error) {
      isSigningUpLocal.value = false;
      Get.snackbar('Error Logging in', error.message,
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (error) {
      debugPrint('$error');
      isSigningUpLocal.value = false;
      Get.snackbar('Error Signing up in', error.toString(),
          icon: const Icon(Icons.error_outline),
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}

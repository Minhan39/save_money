import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:save_money/assets/file_manager.dart';
import 'package:save_money/screens/home_screen.dart';
import 'package:save_money/utils/awesome_snack_bar_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> _scopes = [
    'email',
    'https://www.googleapis.com/auth/spreadsheets',
  ];

  void goToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Future<void> saveLoginData(
    String userEmail,
    String userDisplayName,
    String userAvatar,
    String idGoogle,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', userEmail);
    await prefs.setString('user_display_name', userDisplayName);
    await prefs.setString('user_avatar', userAvatar);
    await prefs.setString('user_id_google', idGoogle);
  }

  Future<GoogleSignInAccount> _signInWithGoogle() async {
    if (GoogleSignIn.instance.supportsAuthenticate()) {
      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: _scopes,
      ); 
      return account;
    }
    throw 'Not support login Google!';
  }

  void _handleError(String message) {
    AwesomeSnackBarHelper.showError(
      context: context,
      title: 'Failed!!!',
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 120, width: 120, child: imagePicture(appLogo)),
              const SizedBox(height: 40),
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Please sign in to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: GoogleSignInButton(
                  onPressed: () async {
                    try {
                      final account = await _signInWithGoogle();

                      if (account.displayName != null &&
                          account.photoUrl != null) {
                        await saveLoginData(
                          account.email,
                          account.displayName!,
                          account.photoUrl!,
                          account.id,
                        );
                        goToHome();
                      }
                    } catch (e) {
                      _handleError(e.toString());
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'By signing in, you acknowledge and agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        foregroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo Google
          SizedBox(height: 32, width: 32, child: imagePicture(google)),
          const SizedBox(width: 12),
          // Text
          const Text(
            'Sign in with Google',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

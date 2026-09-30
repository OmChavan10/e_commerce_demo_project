import 'package:e_commerce_demo_project/homeScreen.dart';
import 'package:e_commerce_demo_project/signup_page.dart';
import 'package:e_commerce_demo_project/user_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your username and password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await UserDatabase.instance.authenticate(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect username or password')),
        );
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen(account: user)),
        (route) => false,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not sign in. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardIsOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade300,
              Colors.orange.shade500,
              Colors.orange.shade700,
              Colors.orange.shade100,
            ],
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              top: keyboardIsOpen ? 0 : 230,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.orange.shade100,
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(keyboardIsOpen ? 0 : 70),
                    topRight: Radius.circular(keyboardIsOpen ? 0 : 70),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: keyboardIsOpen ? 80 : 70),
                      keyboardIsOpen
                          ? Center(
                              child: Text(
                                "Login",
                                style: GoogleFonts.gabarito(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            )
                          : Text(""),
                      SizedBox(height: keyboardIsOpen ? 20 : 0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Username  ",
                          style: GoogleFonts.gabarito(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange,
                                spreadRadius: 0.3,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.deepOrange,
                              ),
                              hint: Text('Username'),
                              floatingLabelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Password  ",
                          style: GoogleFonts.gabarito(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange,
                                spreadRadius: 0.3,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscuringCharacter: '*',
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.password_rounded,
                                color: Colors.deepOrange,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.deepOrange,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              hint: Text('Password'),
                              floatingLabelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.orange.shade500,
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                horizontal: 105,
                                vertical: 13,
                              ),
                            ),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style: GoogleFonts.gabarito(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      // SizedBox(height: ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New User?",
                            style: GoogleFonts.gabarito(
                              fontSize: 15,
                              color: Colors.deepOrange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SignupScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.gabarito(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              top: keyboardIsOpen ? 18 : 90,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "LOGIN",
                  style: GoogleFonts.hammersmithOne(
                    fontSize: keyboardIsOpen ? 40 : 65,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

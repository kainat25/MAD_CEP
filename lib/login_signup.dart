import 'package:eventvista/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 39, 47, 82),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Login', // Tab label
                style: TextStyle(
                  fontSize: 16, // Set the font size
                  fontWeight: FontWeight.w500, // Set the font weight
                ),
              ),
            ),
            Tab(
              child: Text(
                'Signup', // Tab label
                style: TextStyle(
                  fontSize: 16, // Set the font size
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AuthForm(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            authController: authController,
            isLogin: true,
            screenWidth: screenWidth,
          ),
          AuthForm(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            authController: authController,
            isLogin: false,
            screenWidth: screenWidth,
          ),
        ],
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  // Changed to StatefulWidget
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final AuthController authController;
  final bool isLogin;
  final double screenWidth;

  AuthForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.authController,
    required this.isLogin,
    required this.screenWidth,
  });

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _passwordObscure = true;
  bool _confirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry formPadding = EdgeInsets.symmetric(
      horizontal: widget.screenWidth > 600 ? 100 : 30,
    );

    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: formPadding,
            child: TextField(
              controller: widget.emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: formPadding,
            child: TextField(
              controller: widget.passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordObscure = !_passwordObscure;
                    });
                  },
                ),
              ),
              obscureText: _passwordObscure,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (!widget.isLogin)
            Padding(
              padding: formPadding,
              child: TextField(
                controller: widget.confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmPasswordObscure
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmPasswordObscure = !_confirmPasswordObscure;
                      });
                    },
                  ),
                ),
                obscureText: _confirmPasswordObscure,
              ),
            ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: widget.screenWidth > 600 ? 200 : 100,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 39, 47, 82),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  if (widget.isLogin) {
                    widget.authController.login(
                      email: widget.emailController.text.trim(),
                      password: widget.passwordController.text.trim(),
                      context: context,
                    );
                  } else {
                    if (widget.passwordController.text.trim() !=
                        widget.confirmPasswordController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Passwords do not match.'), // Password mismatch message
                        ),
                      );
                    } else {
                      widget.authController.signup(
                        email: widget.emailController.text.trim(),
                        password: widget.passwordController.text.trim(),
                        context: context,
                      );
                    }
                  }
                }
              },
              child: Obx(() {
                if (widget.authController.isloading.value) {
                  return CircularProgressIndicator();
                } else {
                  return Text(widget.isLogin ? 'Login' : 'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ));
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

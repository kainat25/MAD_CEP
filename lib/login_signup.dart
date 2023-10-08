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

    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 39, 47, 82),
        title: Text(
          'Login & Signup',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Login',
            ),
            Tab(text: 'Signup'),
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
            authController: authController,
            isLogin: true,
            screenWidth: screenWidth, // Pass screen width to AuthForm
          ),
          AuthForm(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            authController: authController,
            isLogin: false,
            screenWidth: screenWidth, // Pass screen width to AuthForm
          ),
        ],
      ),
    );
  }
}

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AuthController authController;
  final bool isLogin;
  final double screenWidth; // Receive screen width from LoginSignupScreen

  AuthForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.authController,
    required this.isLogin,
    required this.screenWidth, // Receive screen width
  });

  @override
  Widget build(BuildContext context) {
    // You can use screenWidth to adjust padding and button width

    // Define padding based on screen width
    EdgeInsetsGeometry formPadding = EdgeInsets.symmetric(
      horizontal: screenWidth > 600 ? 100 : 30, // Adjust padding as needed
    );

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: formPadding, // Use formPadding for padding
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: formPadding, // Use formPadding for padding
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: screenWidth > 600 ? 300 : 200, // Adjust button width
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 39, 47, 82)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (isLogin) {
                    authController.login(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      context: context,
                    );
                  } else {
                    authController.signup(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      context: context,
                    );
                  }
                }
              },
              child: Obx(() {
                if (authController.isloading.value) {
                  return CircularProgressIndicator();
                } else {
                  return Text(isLogin ? 'Login' : 'Sign Up',
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hyperconnect_cms_app/AuthScreens/login.dart';
import 'package:hyperconnect_cms_app/Provider/theme.dart' as provider_theme;
import 'package:hyperconnect_cms_app/Views/ContactScreen.dart';
import 'package:flutter/material.dart';
import 'package:hyperconnect_cms_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:hyperconnect_cms_app/main.dart';

class SignupScreen extends StatefulWidget {
  final AuthService _auth = AuthService();

  // const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 800;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("HyperConnect",
            style: TextStyle(fontSize: 30, color: Colors.white)),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        backgroundColor: Colors.blueGrey,
      ),
      resizeToAvoidBottomInset: false,
      endDrawer: Drawer(
        child: Container(
          color: Theme.of(context)
              .drawerTheme
              .backgroundColor, // Theme-based color
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dark_mode,
                    color: Theme.of(context).iconTheme.color),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
                trailing: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up In Our App",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    height: isLargeScreen
                        ? constraints.maxHeight * 0.5
                        : constraints.maxHeight *
                            0.5, // Adjust height based on screen size
                    width: isLargeScreen
                        ? constraints.maxWidth * 0.5
                        : constraints.maxWidth * 0.8,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            prefixIcon: Icon(Icons.person,
                                color: Theme.of(context).iconTheme.color),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Name is required"
                              : null,
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            prefixIcon: Icon(Icons.email,
                                color: Theme.of(context).iconTheme.color),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Email is required"
                              : null,
                        ),
                        TextFormField(
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            prefixIcon: Icon(Icons.lock,
                                color: Theme.of(context).iconTheme.color),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Password is required"
                              : null,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  User? user = await widget._auth
                                      .registerWithEmailAndPassword(
                                    _emailController.text.trim(),
                                    _passController.text.trim(),
                                  );
                                  if (user != null) {
                                    // Show success Snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Sign-up successful!"),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );

                                    // Navigate to ContactScreen
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ContactScreen(),
                                      ),
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  // Handle Firebase-specific errors
                                  if (e.code == 'email-already-in-use') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "This email is already in use."),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else if (e.code == 'invalid-email') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Enter a valid email address."),
                                        backgroundColor: Colors.orange,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else if (e.code == 'weak-password') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Password is too weak. Use a stronger password."),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Sign-up failed: ${e.message}"),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  // Handle other errors
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "An error occurred: ${e.toString()}"),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                }
                              } else {
                                // Show validation error Snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please fill in all required fields."),
                                    backgroundColor: Colors.orange,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // const Text("Sign Up With Other Platforms"),
                  // const SizedBox(height: 15),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     IconButton(
                  //       icon: const Icon(Icons.g_mobiledata),
                  //       onPressed: () {},
                  //       style: IconButton.styleFrom(
                  //         side: BorderSide(
                  //           color: Theme.of(context).primaryColor,
                  //           width: 2,
                  //         ),
                  //       ),
                  //     ),
                  //     IconButton(
                  //       icon: const Icon(Icons.apple),
                  //       onPressed: () {},
                  //       style: IconButton.styleFrom(
                  //         side: BorderSide(
                  //           color: Theme.of(context).primaryColor,
                  //           width: 2,
                  //         ),
                  //       ),
                  //     ),
                  //     IconButton(
                  //       icon: const Icon(Icons.facebook),
                  //       onPressed: () {},
                  //       style: IconButton.styleFrom(
                  //         side: BorderSide(
                  //           color: Theme.of(context).primaryColor,
                  //           width: 2,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 20),
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color, // Theme-based text color
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context)
                            .primaryColor, // Use theme's primary color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Information
              const Text(
                "Welcome to HyperConnect CMS App",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "HyperConnect is a powerful Contact Management System (CMS) designed to help you organize and manage your personal and professional connections with ease. Our app ensures your data is secure and accessible anytime, anywhere.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Creators Section
              const Text(
                "Meet the Creators",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Creators Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isLargeScreen ? 4 : 2, // 4 columns for large screens, 2 for small screens
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1, // Adjust aspect ratio for square-like items
                ),
                itemCount: 4, // Number of creators
                itemBuilder: (context, index) {
                  final creators = [
                    {
                      "name": "Prathamesh Gurav",
                      "photo": "images/pratham.jpg", // Asset path
                    },
                    {
                      "name": "Vinit Devadiga",
                      "photo": "images/vinit.jpeg", // Asset path
                    },
                    {
                      "name": "Rudra Gala",
                      "photo": "images/rudra.jpeg", // Asset path
                    },
                    {
                      "name": "Ebrahim Bilakhia",
                      "photo": "images/ebrahim.jpeg", // Asset path
                    },
                  ];

                  final creator = creators[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: isLargeScreen ? 0.17*screenWidth : 0.3*screenWidth,
                        width: isLargeScreen ? 0.17*screenWidth : 0.3*screenWidth,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(creator["photo"]!),
                            fit: BoxFit.cover,
                          ),// Circular avatar
                        ),
                      ),
                      // const SizedBox(height: 10),
                      Text(
                        creator["name"]!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 40),
              Text(
                "Contact Us At :",
                style: TextStyle(
                  fontSize: isLargeScreen ? 40 : 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "hyperconnect@email.com",
                style: TextStyle(
                  fontSize: isLargeScreen ? 35 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
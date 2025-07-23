import 'package:hyperconnect_cms_app/Views/about.dart';
import 'package:hyperconnect_cms_app/Views/home.dart';
import 'package:hyperconnect_cms_app/AuthScreens/login.dart';
import 'package:hyperconnect_cms_app/AuthScreens/signup.dart';
import 'package:hyperconnect_cms_app/Provider/theme.dart' as provider_theme;
import 'package:hyperconnect_cms_app/Views/ContactScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hyperconnect_cms_app/main.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        title: Text("HyperConnect",
            style: TextStyle(fontSize: 30, color: Colors.white)),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context)
                    .openEndDrawer(); // Opens the right-side drawer
              },
            ),
          ),
        ],
        backgroundColor: Colors.blueGrey,
      ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Container(
            height: 50,
            width: double.infinity,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text('Home',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutScreen()),
                    );
                  },
                  child: Text('About',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text('Signup',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            "Your Contacts,",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "Organized & Secure!",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Manage your personal and professional connections with ease.",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

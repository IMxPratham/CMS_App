import 'package:hyperconnect_cms_app/Provider/theme.dart' as provider_theme;
import 'package:hyperconnect_cms_app/Widgets/All_contacts.dart';
import 'package:hyperconnect_cms_app/Widgets/Family_contacts.dart';
import 'package:hyperconnect_cms_app/Widgets/Friends_contact.dart';
import 'package:hyperconnect_cms_app/Widgets/Work_contacts.dart';
import 'package:hyperconnect_cms_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hyperconnect_cms_app/Views/MainScreen.dart';
import 'package:hyperconnect_cms_app/ContactOperation/AddContact.dart';
import 'package:hyperconnect_cms_app/main.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ""; // Initialize _searchQuery

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 800;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        title: const Text(
          "HyperConnect",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              iconSize: 30,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              onPressed: () {
                Scaffold.of(context)
                    .openEndDrawer(); // Opens the right-side drawer
              },
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.person_add, color: Colors.white),
              iconSize: 30,
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddContact()),
                );
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
                child: const Center(
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
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
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
              ListTile(
                leading: Icon(Icons.logout_outlined,
                    color: Theme.of(context).iconTheme.color),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                onTap: () async {
                  await AuthService().signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.blueGrey, width: 2),
            ),
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Trigger search when the search icon is tapped
                    setState(() {
                      _searchQuery = _searchController.text.trim();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: const Icon(Icons.search),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      // Update search query dynamically
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search Contact",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedIndex == 0
                ? AllContacts(
                    searchQuery: _searchQuery) // Pass _searchQuery dynamically
                : _selectedIndex == 1
                    ? Family(searchQuery: _searchQuery)
                    : _selectedIndex == 2
                        ? Friends(searchQuery: _searchQuery)
                        : Work(searchQuery: _searchQuery),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green, // Active icon color
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type:
            BottomNavigationBarType.fixed, // Ensures labels are always visible
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Family',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Work',
          ),
        ],
      ),
    );
  }
}

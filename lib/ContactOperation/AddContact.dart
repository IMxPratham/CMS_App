import 'package:hyperconnect_cms_app/Views/ContactScreen.dart';
import 'package:flutter/material.dart';
import 'package:hyperconnect_cms_app/services/database_services.dart';
import 'package:hyperconnect_cms_app/services/auth_service.dart';
import 'package:hyperconnect_cms_app/model/contactmodel.dart';
import 'package:flutter/services.dart';

class AddContact extends StatefulWidget {
  final Contact? contact; // Optional Contact object for editing

  const AddContact({Key? key, this.contact}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final DatabaseServices _databaseServices = DatabaseServices();

  final List<String> categories = ["Family", "Friends", "Work"];
  String? selectedCategory;

  final List<String> contactTypes = [
    "IN(+91)",
    "RU(+7)",
    "US(+1)",
    "UK(+44)",
    "AS(+61)"
  ];
  String? selectedCountryCode;

  final List<String> isFavourite = ["True", "False"];
  bool isFav = false;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with values from the passed Contact object or empty strings
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    _phoneController =
        TextEditingController(text: widget.contact?.phonenumber ?? '');

    // Set initial dropdown values
    selectedCategory = widget.contact?.category;
    selectedCountryCode = widget.contact?.countrycode;
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 800;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "HyperConnect",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: isLargeScreen ? screenWidth * 0.5 : screenWidth * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      iconSize: 40,
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        if (_nameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _phoneController.text.isEmpty ||
                            selectedCountryCode == null ||
                            selectedCategory == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill all fields")),
                          );
                          return;
                        }

                        if (widget.contact == null) {
                          // Add new contact
                          await _databaseServices.addContact(
                            _nameController.text,
                            _emailController.text,
                            selectedCountryCode!,
                            _phoneController.text,
                            selectedCategory!,
                            isFav,
                          );
                        } else {
                          // Edit existing contact
                          await _databaseServices.editContact(
                            widget.contact!.docId,
                            _nameController.text,
                            _emailController.text,
                            selectedCountryCode!,
                            _phoneController.text,
                            selectedCategory!,
                            isFav,
                          );
                        }

                        Navigator.pop(context); // Navigate back after saving
                      },
                      icon: const Icon(Icons.check),
                      iconSize: 40,
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueGrey,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 150,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                            child: DropdownButtonFormField<String>(
                              value: selectedCountryCode,
                              hint: const Text("Country Code"),
                              items: contactTypes.map((String code) {
                                return DropdownMenuItem<String>(
                                  value: code,
                                  child: Text(code),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCountryCode = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                labelText: "Country Code",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // Restrict input to digits only
                              ],
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        hint: const Text("Select Category"),
                        items: categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Category",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: DropdownButtonFormField<String>(
                        value: isFav ? "True" : "False",
                        hint: const Text("Is Favourite"),
                        items: isFavourite.map((String fav) {
                          return DropdownMenuItem<String>(
                            value: fav,
                            child: Text(fav),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            isFav = newValue ==
                                "True"; // Convert "True" to true and "False" to false
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Is Favourite",
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
    );
  }
}

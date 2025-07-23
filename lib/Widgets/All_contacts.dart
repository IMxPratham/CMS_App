import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hyperconnect_cms_app/model/contactmodel.dart';
import 'package:hyperconnect_cms_app/services/database_services.dart';
import 'package:hyperconnect_cms_app/ContactOperation/AddContact.dart';

class AllContacts extends StatefulWidget {
  final String searchQuery;
  const AllContacts({super.key, required this.searchQuery});

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;

  final DatabaseServices _databaseServices = DatabaseServices();

  void ShowContactDetails({
    required BuildContext context,
    required Contact contact,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Contact Details",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.maxFinite,
                child: Column(
                  children: [
                    // Profile avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[700],
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${contact.name}"),
                        Text("Phone Number: ${contact.phonenumber}"),
                        Text("Email: ${contact.email}"),
                        Text("Country Code: ${contact.countrycode}"),
                        Text("Category: ${contact.category}"),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Contact>>(
      stream: _databaseServices.contacts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Contact> contacts = snapshot.data!;
          if (widget.searchQuery.isNotEmpty) {
            contacts = contacts
                .where((contact) =>
                    contact.name
                        .toLowerCase()
                        .contains(widget.searchQuery.toLowerCase()) ||
                    contact.phonenumber.contains(widget.searchQuery))
                .toList();
          }
          // Separate favorite and non-favorite contacts
          List<Contact> favoriteContacts =
              contacts.where((contact) => contact.isFavourite).toList();
          List<Contact> nonFavoriteContacts =
              contacts.where((contact) => !contact.isFavourite).toList();

          // Sort both lists alphabetically
          favoriteContacts.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          nonFavoriteContacts.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          return ListView(
            children: [
              // Favourites Section
              if (favoriteContacts.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Favourites",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...favoriteContacts.map((contact) => buildContactTile(contact)),
              ],

              // All Contacts Section
              if (nonFavoriteContacts.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "All Contacts",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...nonFavoriteContacts
                    .map((contact) => buildContactTile(contact)),
              ],
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }
      },
    );
  }

  // Helper method to build a contact tile
  Widget buildContactTile(Contact contact) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 2,
        ),
      ),
      child: Slidable(
        key: ValueKey(contact.docId),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Delete",
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Contact"),
                      content: const Text(
                          "Are you sure you want to delete this contact?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(); // Close the dialog
                            await _databaseServices
                                .deleteContact(contact.docId);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: "Edit",
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddContact(
                        contact: contact), // Pass the selected contact
                  ),
                );
              },
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[500],
            child: Text(contact.name[0].toUpperCase(),
                style: TextStyle(fontSize: 30, color: Theme.of(context).textTheme.bodyLarge?.color)),
          ),
          title: Text(
            contact.name,
            style: const TextStyle(fontSize: 25),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Text(
            contact.phonenumber,
            style: const TextStyle(fontSize: 20),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  contact.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border, // Toggle icon
                  color: contact.isFavourite
                      ? Colors.red
                      : Colors.grey, // Toggle color
                ),
                onPressed: () async {
                  await _databaseServices.toggleFavourite(
                      contact.docId, contact.isFavourite);
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                color: Colors.grey,
                onPressed: () {
                  ShowContactDetails(
                    context: context,
                    contact: contact,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

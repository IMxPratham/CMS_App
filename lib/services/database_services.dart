import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hyperconnect_cms_app/model/contactmodel.dart';

class DatabaseServices {
  final CollectionReference contactCollection =
      FirebaseFirestore.instance.collection('contacts');

  User? user = FirebaseAuth.instance.currentUser;

  Stream<List<Contact>> get contacts {
    return contactCollection
        .where('uid', isEqualTo: user!.uid) // Filter by the current user's UID
        .snapshots()
        .map((snapshot) => _contactListFromSnapshot(snapshot));
  }
  // Function to Add contacts
  Future<DocumentReference?> addContact(String name, String email,
    String countrycode, String phonenumber, String category, bool isFavourite) async {
  // Check for duplicate contact
  final duplicateCheck = await contactCollection
      .where('uid', isEqualTo: user!.uid) // Filter by the current user's UID
      .where('phonenumber', isEqualTo: phonenumber) // Check for duplicate phone number
      .get();

  if (duplicateCheck.docs.isNotEmpty) {
    // If a duplicate is found, return null or throw an exception
    throw Exception("A contact with this phone number already exists.");
  }

  // If no duplicate is found, add the contact
  return await contactCollection.add({
    'name': name,
    'email': email,
    'countrycode': countrycode,
    'phonenumber': phonenumber,
    'category': category,
    'uid': user!.uid, // Add user ID to the document
    'isFavourite': isFavourite, // Default value for isFavourite
  });
}

//Function to Edit contacts
  Future<void> editContact(String docId, String name, String email,
      String countrycode, String phonenumber, String category,bool isFavourite) async {
    final editcontactCollection =
        FirebaseFirestore.instance.collection("contacts").doc(docId);
    return await editcontactCollection.update({
      'name': name,
      'email': email,
      'countrycode': countrycode,
      'phonenumber': phonenumber,
      'category': category,
      'isFavourite': isFavourite, // Default value for isFavourite
    });
  }

//Funcition to delete contacts
  Future<void> deleteContact(String docId) async {
    final deletecontactCollection =
        FirebaseFirestore.instance.collection("contacts").doc(docId);
    return await deletecontactCollection.delete();
  }

  Future<void> toggleFavourite(String docId, bool currentStatus) async {
  final contactDoc = FirebaseFirestore.instance.collection("contacts").doc(docId);
  return await contactDoc.update({
    'isFavourite': !currentStatus, // Toggle the current status
  });
}
}



List<Contact> _contactListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Contact(
      docId: doc.id,
      // Extracting the document ID from the snapshot
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      countrycode: doc['countrycode'] ?? '',
      phonenumber: doc['phonenumber'] ?? '',
      category: doc['category'] ?? '', 
      isFavourite: doc['isFavourite'] ?? false, // Default to false if not present
    );
  }).toList();
}
  // Function to get contacts
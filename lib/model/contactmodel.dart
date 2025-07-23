import 'package:cloud_firestore/cloud_firestore.dart';

class Contact{
  final String docId; // Document ID for the contact
  final String name;
  final String email;
  final String countrycode;
  final String phonenumber;
  final String category;
  final bool isFavourite;

  static var id;

  Contact({
    required this.docId, // Initialize the document ID
    required this.name,
    required this.email,
    required this.countrycode,
    required this.phonenumber,
    required this.category,
    required this.isFavourite,
  });
}
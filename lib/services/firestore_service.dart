// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gotaguig_admin/models/Destinations.dart';
import 'package:gotaguig_admin/models/Events.dart';
import 'package:gotaguig_admin/models/Reviews.dart';
import 'package:gotaguig_admin/models/Users.dart';

class FirestoreService {
  // FOR ADMIN LOGIN ONLY

  Future<bool> validateUser(String username, String password) async {
    try {
      // Reference to the 'admin' collection
      CollectionReference collection =
          FirebaseFirestore.instance.collection("admin");

      // Query the collection for documents where 'user' and 'password' match
      QuerySnapshot querySnapshot = await collection
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error fetching user: $e');
    }

    return false;
  }

  // END OF ADMIN LOGIN SECTION

  // FOR EVENTS ONLY

  Future<List<Events>?> getAllEvents() async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection("events");

      QuerySnapshot querySnapshot = await collection.get();

      List<Events> events = [];

      for (var doc in querySnapshot.docs) {
        try {
          DocumentSnapshot documentSnapshot =
              await collection.doc(doc.id).get();
          var data = documentSnapshot.data() as Map<String, dynamic>;

          if (data.isNotEmpty) {
            events.add(Events.fromSnapshot(data));
          }
        } catch (e) {
          print("Error processing document ${doc.id}: $e");
        }
      }

      return events.isNotEmpty ? events : null;
    } catch (e) {
      print("Error fetching data from Firestore: $e");
    }
    return null;
  }

  // Create a collection and document with specific fields
  Future<void> addEvent(
      String eventName, Timestamp eventDate, String eventDescription, File file,
      {String? eventID}) async {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a collection reference
    CollectionReference event = firestore.collection('events');

    DocumentReference docRef =
        eventID != null ? event.doc(eventID) : event.doc();

    String? imgDirectory = await uploadFile(file, docRef.id);

    // Add a new document with auto-generated ID
    await docRef.set({
      'event_id': docRef.id, // Store the auto-generated ID
      'event_name': eventName,
      'event_date': eventDate,
      'event_description': eventDescription,
      'image_directory': imgDirectory,
    }).then((_) {
      print("Event added");
    }).catchError((e) {
      print("Error adding user: $e");
    });
  }

  Future<String?> uploadFile(File file, String eventId) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('events/$eventId/event-$eventId.jpg');
      await storageRef.putFile(file);

      return storageRef.fullPath;
    } catch (e) {
      print('Upload failed: $e');
    }

    return null;
  }

  Future<String> getImageUrl(String imagePath) async {
    print("imagePath URL: $imagePath");
    String downloadURL =
        await FirebaseStorage.instance.ref(imagePath).getDownloadURL();

    print("Download URL: $downloadURL");
    return downloadURL;
  }

  Future<void> deleteDocumentAndFile(String documentId, String filePath) async {
    try {
      // Delete file from Firebase Storage
      await FirebaseStorage.instance.ref(filePath).delete();
      print('File deleted from Firebase Storage');

      // Delete the document from Firestore
      await FirebaseFirestore.instance
          .collection('events')
          .doc(documentId)
          .delete();
      print('Document deleted from Firestore');
    } catch (e) {
      print('Error deleting document or file: $e');
    }
  }

  // END OFF EVENTS SECTION

  // FOR uSER MANAGEMENT SECTION

  Future<List<Users>?> getAllUsers() async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection("users");

      QuerySnapshot querySnapshot = await collection.get();

      List<Users> users = [];

      for (var doc in querySnapshot.docs) {
        try {
          DocumentSnapshot documentSnapshot =
              await collection.doc(doc.id).get();
          var data = documentSnapshot.data() as Map<String, dynamic>;

          if (data.isNotEmpty) {
            users.add(Users.fromSnapshot(data));
          }
        } catch (e) {
          print("Error processing document ${doc.id}: $e");
        }
      }

      return users.isNotEmpty ? users : null;
    } catch (e) {
      print("Error fetching data from Firestore: $e");
    }
    return null;
  }

  Future<void> deleteUserData(String userID) async {
    try {
      /* // Delete profile picture from Firebase Storage
      await FirebaseStorage.instance.ref(filePath).delete();
      print('File deleted from Firebase Storage');*/

      // Delete the document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(userID).delete();
      print('Document deleted from Firestore');
    } catch (e) {
      print('Error deleting document or file: $e');
    }
  }

  // END OF USER MANAGEMENT SECTION

  // FOR REVIEWS AND FEEDBACKS SECTIONS

  Future<List<Reviews>?> getAllReviews() async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection("reviews & feedbacks");

      QuerySnapshot querySnapshot = await collection.get();

      List<Reviews> reviews = [];

      for (var doc in querySnapshot.docs) {
        try {
          DocumentSnapshot documentSnapshot =
              await collection.doc(doc.id).get();
          var data = documentSnapshot.data() as Map<String, dynamic>;

          if (data.isNotEmpty) {
            reviews.add(Reviews.fromSnapshot(data));
          }
        } catch (e) {
          print("Error processing document ${doc.id}: $e");
        }
      }

      print(reviews.toList());

      return reviews.isNotEmpty ? reviews : null;
    } catch (e) {
      print("Error fetching data from Firestore: $e");
    }
    return null;
  }

  // END OF REVIEWS AND FEEDBACKS SECTIONS

  // FOR MAP LOCATIONS

  Future<List<Destinations>?> getDestinations(String collectionName) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection(collectionName);

      QuerySnapshot querySnapshot = await collection.get();

      List<Destinations> destinations = [];

      for (var doc in querySnapshot.docs) {
        try {
          DocumentSnapshot documentSnapshot =
              await collection.doc(doc.id).get();
          var data = documentSnapshot.data() as Map<String, dynamic>;

          if (data.isNotEmpty) {
            destinations.add(Destinations.fromSnapshot(data));
          }
        } catch (e) {
          print("Error processing document ${doc.id}: $e");
        }
      }

      return destinations.isNotEmpty ? destinations : null;
    } catch (e) {
      print("Error fetching data from Firestore: $e");
    }
    return null;
  }

  Future<void> addNewLocation(
      String collectionName,
      String locationName,
      String locationAddress,
      String locationLatitude,
      String locationLongitude,
      String locationInfo,
      String locationLink,
      String locationContact,
      File banner,
      File customMarker,
      bool isPopular) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a collection reference
    CollectionReference collection = firestore.collection(collectionName);

    DocumentReference docRef = collection.doc();

    String bannerDirectory =
        "destinations/$collectionName/${docRef.id}/banner_image/";

    String? finalBannerDir =
        await uploadLocationImages(banner, bannerDirectory, "banner_image");

    String customMarkerDirectory =
        "destinations/$collectionName/${docRef.id}/custom_marker/";

    String? customMarkerDir = await uploadLocationImages(
        customMarker, customMarkerDirectory, "custom_marker");

    // Add a new document with auto-generated ID
    await docRef.set({
      // Store the auto-generated ID
      'site_address': locationAddress,
      'site_banner': finalBannerDir,
      'site_contact': locationContact,
      'site_info': locationInfo,
      'site_latitude': locationLatitude,
      'site_link': locationLink,
      'site_longitude': locationLongitude,
      'site_marker': customMarkerDir,
      'site_name': locationName,
      'site_popular': isPopular,
    }).then((_) {
      print("Location added");
    }).catchError((e) {
      print("Error adding location: $e");
    });
  }

  Future<void> updateLocation(
    String collectionName,
    String locationName,
    String locationAddress,
    String locationLatitude,
    String locationLongitude,
    String locationInfo,
    String locationLink,
    String locationContact,
    File banner,
    File customMarker,
    bool isPopular,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection(collectionName)
          .where('site_name', isEqualTo: locationName)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No document found with site_name: $locationName');
        return;
      }

      DocumentReference docRef = querySnapshot.docs.first.reference;

      Map<String, dynamic> updates = {};

      // Update fields only if new values are provided
      updates['site_address'] = locationAddress;
      updates['site_latitude'] = locationLatitude;
      updates['site_longitude'] = locationLongitude;
      updates['site_info'] = locationInfo;
      updates['site_link'] = locationLink;
      updates['site_contact'] = locationContact;
      updates['site_popular'] = isPopular;

      String bannerDirectory =
          "destinations/$collectionName/${docRef.id}/banner_image/";
      String? finalBannerDir =
          await uploadLocationImages(banner, bannerDirectory, "banner_image");
      if (finalBannerDir != null) updates['site_banner'] = finalBannerDir;

      String customMarkerDirectory =
          "destinations/$collectionName/${docRef.id}/custom_marker/";
      String? customMarkerDir = await uploadLocationImages(
          customMarker, customMarkerDirectory, "custom_marker");
      if (customMarkerDir != null) updates['site_marker'] = customMarkerDir;

      await docRef.update(updates);
      print('Location updated successfully');
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<String?> uploadLocationImages(
      File file, String imageDirectory, String fileName) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('$imageDirectory/$fileName.png');
      await storageRef.putFile(file);

      return storageRef.fullPath;
    } catch (e) {
      print('Upload failed: $e');
    }

    return null;
  }

  Future<void> deleteLocationDetails(String locationName, String collectionName,
      String bannerFilePath, String customMarkerFilePath) async {
    try {
      // Delete file from Firebase Storage
      await FirebaseStorage.instance.ref(bannerFilePath).delete();
      print('File deleted from Firebase Storage');

      await FirebaseStorage.instance.ref(customMarkerFilePath).delete();
      print('File deleted from Firebase Storage');

      // Delete the document from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('site_name', isEqualTo: locationName)
          .get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        await document.reference.delete();
      }

      print('Document deleted from Firestore');
    } catch (e) {
      print('Error deleting document or file: $e');
    }
  }

  // END OF MAP LOCATIONS
}

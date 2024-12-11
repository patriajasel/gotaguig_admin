// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  final String eventID;
  final String eventName;
  final Timestamp eventDate;
  final String eventDescription;
  final String imageDirectory;

  Events(
      {required this.eventID,
      required this.eventName,
      required this.eventDate,
      required this.eventDescription,
      required this.imageDirectory});

  factory Events.fromSnapshot(Map<String, dynamic> snapshot) {
    try {
      return Events(
        eventID: snapshot['event_id'] ?? '',
        eventName: snapshot['event_name'] ?? '',
        eventDate: snapshot['event_date'] ?? '',
        eventDescription: snapshot['event_description'] ?? '',
        imageDirectory: snapshot['image_directory'] ?? '',
      );
    } catch (e) {
      print("Error parsing snapshot: $e");
      rethrow;
    }
  }
}

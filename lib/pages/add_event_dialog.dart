// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gotaguig_admin/models/Events.dart';
import 'package:gotaguig_admin/services/firestore_service.dart';
import 'package:window_manager/window_manager.dart';

class EventDialog extends StatefulWidget {
  Events? event;
  String dialogTitle;
  Function rebuildState;
  EventDialog(
      {super.key,
      this.event,
      required this.dialogTitle,
      required this.rebuildState});

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  final TextEditingController eventTitle = TextEditingController();
  final TextEditingController eventDate = TextEditingController();
  final TextEditingController eventDescription = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedFileName;

  File? selectedFile;

  @override
  void initState() {
    super.initState();
    eventDate.text = "${selectedDate.toLocal()}".split(' ')[0];
    _getWindowWidth();

    if (widget.event != null) {
      eventTitle.text = widget.event!.eventName;
      eventDescription.text = widget.event!.eventDescription;
      selectedDate = widget.event!.eventDate.toDate();
      eventDate.text = selectedDate.toString();
    }
  }

  Future<void> _getWindowWidth() async {
    Size size = await windowManager.getSize();
    setState(() {
      windowWidth = size.width;
      windowHeight = size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(widget.dialogTitle),
          const Spacer(),
          IconButton(
              onPressed: () {
                setState(() {
                  selectedFile = null;
                  selectedFileName = null;
                  eventTitle.text = "";
                  eventDescription.text = "";
                  selectedDate = DateTime.now();
                  eventDate.text = selectedDate.toString();
                });
                widget.rebuildState();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      titleTextStyle: const TextStyle(
          fontFamily: "ConcertOne", color: Colors.black, fontSize: 30),
      content: SizedBox(
        height: windowHeight * 0.9,
        width: windowWidth * 0.5,
        child: Column(
          children: [
            SizedBox(
              height: windowHeight * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
              child: TextField(
                cursorColor: Colors.black,
                obscureText: false,
                controller: eventTitle,
                expands: false,
                decoration: InputDecoration(
                  labelText: "Event Title",
                  prefixIcon: const Icon(Icons.title, color: Colors.black),

                  // Label style size
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontFamily: "ConcertOne",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),

                  // Border Styles
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black, // White border for the enabled state
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors
                          .black, // White border when the field is focused
                      width: 2.0, // Optional: you can increase the border width
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.red, // Red border for the error state
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.red, // Red border when focused with error
                      width: 2.0,
                    ),
                  ),
                ),
                style: const TextStyle(
                    fontFamily: "ConcertOne",
                    color: Colors.black,
                    fontSize: 14), // Text color set to white
              ),
            ),

            // Event Date

            SizedBox(
              height: windowHeight * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
              child: TextField(
                // Allows the TextField to handle multiple lines
                cursorColor: Colors.black,
                controller: eventDate,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Event Date",
                  prefixIcon: const Icon(
                    Icons.event,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        openDatePicker();
                      },
                      icon: const Icon(Icons.calendar_month)),

                  // Label style
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontFamily: "ConcertOne",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),

                  // Border styles
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black, // Black border for the enabled state
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors
                          .black, // Black border when the field is focused
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.red, // Red border for the error state
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.red, // Red border when focused with error
                      width: 2.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),

            // Event Description

            SizedBox(
              height: windowHeight * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
              child: SizedBox(
                height:
                    300, // Set a fixed height for the TextField (adjust as needed)
                child: TextField(
                  minLines: 15,
                  maxLines:
                      null, // Allows the TextField to handle multiple lines
                  cursorColor: Colors.black,
                  controller: eventDescription,
                  scrollController: ScrollController(), // Enables scrolling
                  decoration: InputDecoration(
                    labelText: "Details",
                    alignLabelWithHint:
                        true, // Aligns label and icon to the top

                    // Label style
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontFamily: "ConcertOne",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),

                    // Border styles
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color:
                            Colors.black, // Black border for the enabled state
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors
                            .black, // Black border when the field is focused
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red, // Red border for the error state
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red, // Red border when focused with error
                        width: 2.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Upload Image
            SizedBox(
              height: windowHeight * 0.01,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
              child: Row(
                children: [
                  Text(selectedFileName ?? "No File Selected Yet"),
                  SizedBox(
                    width: windowWidth * 0.01,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        selectFile();
                      },
                      child: const Row(
                        children: [Icon(Icons.upload), Text("Upload Image")],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              if (widget.event != null) {
                FirestoreService().addEvent(
                    eventTitle.text,
                    Timestamp.fromDate(selectedDate),
                    eventDescription.text,
                    selectedFile!,
                    eventID: widget.event!.eventID);
              } else {
                FirestoreService().addEvent(
                    eventTitle.text,
                    Timestamp.fromDate(selectedDate),
                    eventDescription.text,
                    selectedFile!);
              }

              widget.rebuildState();
              Navigator.pop(context);
            },
            child: const Text("Save")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              setState(() {
                selectedFile = null;
                selectedFileName = null;
                eventTitle.text = "";
                eventDescription.text = "";
                selectedDate = DateTime.now();
                eventDate.text = selectedDate.toString();
              });
              widget.rebuildState();
              Navigator.pop(context);
            },
            child: const Text("Cancel"))
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Set the border radius here
      ),
    );
  }

  void openDatePicker() async {
    final DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));

    if (dateTime != null) {
      setState(() {
        selectedDate = dateTime;
        eventDate.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }

    setState(() {});
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Restrict to specific extensions
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false, // Ensure only one file is picked
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        selectedFileName = result.files.single.name;
      });
    } else {
      // Handle case where user cancels or selects an invalid file
      print('No valid file selected or selection canceled.');
    }
  }
}

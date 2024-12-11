import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gotaguig_admin/models/Events.dart';
import 'package:gotaguig_admin/pages/add_event_dialog.dart';
import 'package:gotaguig_admin/services/firestore_service.dart';
import 'package:window_manager/window_manager.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  List<Events> eventList = [];
  List<String> imageDirectory = [];

  File? selectedFile;
  String? selectedFileName;

  @override
  void initState() {
    super.initState();
    getAllEvents();
    _getWindowWidth();
    setState(() {});
  }

  Future<void> _getWindowWidth() async {
    Size size = await windowManager.getSize();
    setState(() {
      windowWidth = size.width;
      windowHeight = size.height;
    });
  }

  void getAllEvents() async {
    List<Events>? events = await FirestoreService().getAllEvents();

    if (events != null) {
      List<String> imageUrls = [];

      // Fetch image URLs for each event
      for (var event in events) {
        String imageUrl =
            await FirestoreService().getImageUrl(event.imageDirectory);
        if (imageUrl.isNotEmpty) {
          imageUrls.add(imageUrl);
        } else {
          imageUrls.add(
              ""); // Add empty string or a default value for missing images
        }
      }

      if (mounted) {
// Now that we have both event list and image URLs, update the state
        setState(() {
          eventList = events;
          imageDirectory = imageUrls; // Populate imageDirectory
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.red.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: const Text(
                  "Event's Manager",
                  style: TextStyle(fontFamily: "ConcertOne", fontSize: 30),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: windowHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EventDialog(
                            dialogTitle: "Add New Event",
                            rebuildState: rebuildState);
                      },
                    );
                    getAllEvents();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(width: windowWidth * 0.005),
                      const Text(
                        "Add Event",
                        style: TextStyle(
                            fontFamily: "ConcertOne",
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: windowWidth * 0.03)
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
            child: Divider(
              thickness: 4,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Table(
                        border: TableBorder.all(color: Colors.black),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                              decoration: BoxDecoration(
                                  color: Colors.redAccent.shade700),
                              children: const [
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Event Name",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "ConcertOne",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Event Description",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "ConcertOne",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "ConcertOne",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Actions",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "ConcertOne",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ))
                              ]),
                          ...List.generate(
                            eventList.length,
                            (index) {
                              return TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    eventList[index].eventName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    eventList[index].eventDescription,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    imageDirectory[index],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blueAccent.shade700,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                String eventID =
                                                    eventList[index].eventID;
                                                for (var event in eventList) {
                                                  if (event.eventID ==
                                                      eventID) {
                                                    return EventDialog(
                                                        dialogTitle:
                                                            "Edit Existing Event",
                                                        event: eventList[index],
                                                        rebuildState:
                                                            rebuildState);
                                                  }
                                                }

                                                return EventDialog(
                                                  dialogTitle:
                                                      "Edit Existing Event",
                                                  rebuildState: rebuildState,
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: windowWidth * 0.0025,
                                              ),
                                              const Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blueAccent.shade700,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onPressed: () {
                                            setState(() {
                                              FirestoreService()
                                                  .deleteDocumentAndFile(
                                                      eventList[index].eventID,
                                                      eventList[index]
                                                          .imageDirectory);
                                              // Refresh the event list after deletion
                                              getAllEvents();
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.delete,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: windowWidth * 0.0025,
                                              ),
                                              const Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ))
                              ]);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void rebuildState() {
    setState(() {
      getAllEvents();
    });
  }
}

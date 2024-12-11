import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gotaguig_admin/models/Destinations.dart';
import 'package:gotaguig_admin/pages/add_location_dialog.dart';
import 'package:gotaguig_admin/services/firestore_service.dart';
import 'package:window_manager/window_manager.dart';

class MapManagerPage extends StatefulWidget {
  const MapManagerPage({super.key});

  @override
  State<MapManagerPage> createState() => _MapManagerPageState();
}

class _MapManagerPageState extends State<MapManagerPage> {
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  List<Destinations> destinationList = [];
  List<String> imageDirectory = [];

  File? selectedFile;
  String? selectedFileName;

  List<String> filters = [
    "Tourist Spots",
    "Diners",
    "Malls",
    "Hotels",
    "Convenience Stores",
    "Banks",
    "Terminals",
    "Hospitals",
    "Churches",
    "Police",
    "LGU"
  ];

  String selectedFilter = "Tourist Spots";

  @override
  void initState() {
    super.initState();
    getDestinations(selectedFilter.toLowerCase());
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

  void getDestinations(String collectionName) async {
    List<Destinations>? destinations =
        await FirestoreService().getDestinations(collectionName.toLowerCase());

    if (destinations != null) {
      List<String> imageUrls = [];

      // Fetch image URLs for each event
      for (var destination in destinations) {
        String imageUrl =
            await FirestoreService().getImageUrl(destination.siteBanner);
        if (imageUrl.isNotEmpty) {
          imageUrls.add(imageUrl);
        } else {
          imageUrls.add(
              ""); // Add empty string or a default value for missing images
        }
      }

      // Now that we have both event list and image URLs, update the state
      if (mounted) {
        setState(() {
          // Populate imageDirectory

          destinationList = destinations;
          imageDirectory = imageUrls;
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
                  "Taguig Map Manager",
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
                        return LocationDialog(
                          dialogTitle: "Add New Location",
                        );
                      },
                    );
                    getDestinations(selectedFilter.toLowerCase());
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
                        "Add New Location",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  selectedFilter,
                  style: const TextStyle(
                      fontSize: 18,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
              FocusScope(
                canRequestFocus: false,
                child: PopupMenuButton(
                  onSelected: (value) {
                    setState(() {
                      selectedFilter = value;
                      getDestinations(selectedFilter.toLowerCase());
                    });
                  },
                  itemBuilder: (context) {
                    return filters.map((String item) {
                      return PopupMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList();
                  },
                ),
              ),
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
                    scrollDirection: Axis.vertical,
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
                                    "Location Name",
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
                                    "Address",
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
                                    "Latitude, Longitude",
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
                                    "Description",
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
                                    "Address",
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
                                    "Page Link",
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
                                    "Contact Details",
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
                            destinationList.length,
                            (index) {
                              return TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    destinationList[index].siteName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    destinationList[index].siteAddress,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    destinationList[index]
                                        .siteLatLng
                                        .toString(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    destinationList[index].siteInfo,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    destinationList[index].siteAddress,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    destinationList[index].siteLinks,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    destinationList[index].siteContact,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end, // Align to the right
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blueAccent.shade700,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            // Edit action
                                          },
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.edit,
                                                  size: 15,
                                                  color: Colors.white),
                                              SizedBox(width: 4.0),
                                              Text("Edit",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blueAccent.shade700,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () async {
                                            // Delete action

                                            await FirestoreService()
                                                .deleteLocationDetails(
                                                    destinationList[index]
                                                        .siteName,
                                                    selectedFilter,
                                                    destinationList[index]
                                                        .siteBanner,
                                                    destinationList[index]
                                                        .siteMarker);
                                          },
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.delete,
                                                  size: 15,
                                                  color: Colors.white),
                                              SizedBox(width: 4.0),
                                              Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
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
      getDestinations(selectedFilter.toLowerCase());
    });
  }
}

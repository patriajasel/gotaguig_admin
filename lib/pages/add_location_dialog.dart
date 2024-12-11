// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gotaguig_admin/services/firestore_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:window_manager/window_manager.dart';

class LocationDialog extends StatefulWidget {
  String dialogTitle;
  String? name;
  String? info;
  String? address;
  String? latitude;
  String? longitude;
  String? links;
  String? contact;
  String? locationType;
  LocationDialog({super.key, required this.dialogTitle});

  @override
  State<LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  static const taguigCity = LatLng(14.520445, 121.053886);
  final locationController = Location();

  double windowWidth = 0.0;
  double windowHeight = 0.0;

  final TextEditingController locationName = TextEditingController();
  final TextEditingController locationInfo = TextEditingController();
  final TextEditingController locationAddress = TextEditingController();
  final TextEditingController locationLatitude = TextEditingController();
  final TextEditingController locationLongitude = TextEditingController();
  final TextEditingController locationLinks = TextEditingController();
  final TextEditingController locationContact = TextEditingController();
  final TextEditingController selectedLocationType = TextEditingController();

  String? selectedImageBannerName;
  String? selectedCustomMarkerName;

  File? selectedBannerFile;
  File? selectedCustomMarkerFile;

  LatLng? _tappedLocation;

  List<String> locationType = [
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

  @override
  void initState() {
    super.initState();

    _getWindowWidth();

    setState(() {
      if (widget.name != null) {
        locationName.text = widget.name!;
        locationAddress.text = widget.address!;
        locationInfo.text = widget.info!;
        locationLatitude.text = widget.latitude!;
        locationLongitude.text = widget.longitude!;
        locationLinks.text = widget.links!;
        locationContact.text = widget.contact!;
        selectedLocationType.text = widget.locationType!;
      }
    });
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
                  selectedBannerFile = null;
                  selectedCustomMarkerFile = null;
                  selectedImageBannerName = null;
                  selectedCustomMarkerName = null;
                  locationName.text = "";
                  locationAddress.text = "";
                  locationInfo.text = "";
                  locationLatitude.text = "";
                  locationLongitude.text = "";
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      titleTextStyle: const TextStyle(
          fontFamily: "ConcertOne", color: Colors.black, fontSize: 30),
      content: SingleChildScrollView(
        child: SizedBox(
          width: windowWidth * 0.5,
          child: Column(
            children: [
              Container(
                height: 300,
                width: 500,
                decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: taguigCity,
                    initialZoom: 15.0,
                    onTap: (tapPosition, point) {
                      setState(() {
                        _tappedLocation = point;

                        locationLatitude.text = point.latitude.toString();

                        locationLongitude.text = point.longitude.toString();
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.app', // Replace with your package name
                    ),
                    if (_tappedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _tappedLocation!,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: windowHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
                child: TextField(
                  cursorColor: Colors.black,
                  obscureText: false,
                  controller: locationName,
                  expands: false,
                  decoration: InputDecoration(
                    labelText: "Location Name",
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
                        color:
                            Colors.black, // White border for the enabled state
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors
                            .black, // White border when the field is focused
                        width:
                            2.0, // Optional: you can increase the border width
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

              // Location Address

              SizedBox(
                height: windowHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
                child: TextField(
                  // Allows the TextField to handle multiple lines
                  cursorColor: Colors.black,
                  controller: locationAddress,
                  decoration: InputDecoration(
                    labelText: "Location Address",
                    prefixIcon: const Icon(
                      Icons.map,
                      color: Colors.black,
                    ),

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

              // Location Latitude and Longitude

              SizedBox(
                height: windowHeight * 0.01,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: locationLatitude,
                        decoration: InputDecoration(
                          labelText: "Latitude",
                          prefixIcon:
                              const Icon(Icons.pin_drop, color: Colors.black),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontFamily: "ConcertOne",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: locationLongitude,
                        decoration: InputDecoration(
                          labelText: "Longitude",
                          prefixIcon:
                              const Icon(Icons.pin_drop, color: Colors.black),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontFamily: "ConcertOne",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: windowHeight * 0.01,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.01),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Location Type",
                    prefixIcon:
                        const Icon(Icons.location_on, color: Colors.black),

                    // Label style
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
                        color: Colors.black, // Border color when not focused
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color when focused
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red, // Border color when error occurs
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color:
                            Colors.red, // Border color when focused with error
                        width: 2.0,
                      ),
                    ),
                  ),
                  dropdownColor:
                      Colors.white, // Background color of the dropdown
                  value: null, // Initial value, set as needed
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  items: locationType.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontFamily: "ConcertOne",
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle the change here
                    if (newValue != null) {
                      selectedLocationType.text =
                          newValue; // Update the text controller
                    }
                  },
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
                    controller: locationInfo,
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
                          color: Colors
                              .black, // Black border for the enabled state
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
                          color:
                              Colors.red, // Red border when focused with error
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

              SizedBox(
                height: windowHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
                child: TextField(
                  cursorColor: Colors.black,
                  obscureText: false,
                  controller: locationLinks,
                  expands: false,
                  decoration: InputDecoration(
                    labelText: "Related Link",
                    prefixIcon: const Icon(Icons.language, color: Colors.black),

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
                        color:
                            Colors.black, // White border for the enabled state
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors
                            .black, // White border when the field is focused
                        width:
                            2.0, // Optional: you can increase the border width
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

              SizedBox(
                height: windowHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
                child: TextField(
                  cursorColor: Colors.black,
                  obscureText: false,
                  controller: locationContact,
                  expands: false,
                  decoration: InputDecoration(
                    labelText: "Contact Details",
                    prefixIcon:
                        const Icon(Icons.contact_support, color: Colors.black),

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
                        color:
                            Colors.black, // White border for the enabled state
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors
                            .black, // White border when the field is focused
                        width:
                            2.0, // Optional: you can increase the border width
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

              // Upload Image
              SizedBox(
                height: windowHeight * 0.01,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
                child: Row(
                  children: [
                    Text(selectedCustomMarkerName ??
                        "No Custom Marker Selected Yet"),
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
                          selectBannerFile();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.upload),
                            Text("Upload Custom Marker")
                          ],
                        ))
                  ],
                ),
              ),

              SizedBox(
                height: windowHeight * 0.01,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.01),
                child: Row(
                  children: [
                    Text(selectedCustomMarkerName ??
                        "No Banner Image Selected Yet"),
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
                          selectBannerFile();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.upload),
                            Text("Upload Banner Image")
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              if (widget.name != null) {
                await FirestoreService()
                    .updateLocation(
                        selectedLocationType.text.toLowerCase(),
                        locationName.text,
                        locationAddress.text,
                        locationLatitude.text,
                        locationLongitude.text,
                        locationInfo.text,
                        locationLinks.text,
                        locationContact.text,
                        selectedBannerFile!,
                        selectedCustomMarkerFile!,
                        false)
                    .then(
                  (value) {
                    setState(() {
                      selectedBannerFile = null;
                      selectedCustomMarkerFile = null;
                      selectedImageBannerName = null;
                      selectedCustomMarkerName = null;
                      locationName.text = "";
                      locationAddress.text = "";
                      locationInfo.text = "";
                      locationLatitude.text = "";
                      locationLongitude.text = "";
                      locationLinks.text = "";
                      locationContact.text = "";

                      Navigator.pop(context);
                    });
                  },
                );
              } else {
                await FirestoreService()
                    .addNewLocation(
                        selectedLocationType.text.toLowerCase(),
                        locationName.text,
                        locationAddress.text,
                        locationLatitude.text,
                        locationLongitude.text,
                        locationInfo.text,
                        locationLinks.text,
                        locationContact.text,
                        selectedBannerFile!,
                        selectedCustomMarkerFile!,
                        false)
                    .then(
                  (value) {
                    setState(() {
                      selectedBannerFile = null;
                      selectedCustomMarkerFile = null;
                      selectedImageBannerName = null;
                      selectedCustomMarkerName = null;
                      locationName.text = "";
                      locationAddress.text = "";
                      locationInfo.text = "";
                      locationLatitude.text = "";
                      locationLongitude.text = "";
                      locationLinks.text = "";
                      locationContact.text = "";

                      Navigator.pop(context);
                    });
                  },
                );
              }
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
                selectedBannerFile = null;
                selectedCustomMarkerFile = null;
                selectedImageBannerName = null;
                selectedCustomMarkerName = null;
                locationName.text = "";
                locationAddress.text = "";
                locationInfo.text = "";
                locationLatitude.text = "";
                locationLongitude.text = "";
              });
              Navigator.pop(context);
            },
            child: const Text("Cancel"))
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Set the border radius here
      ),
    );
  }

  Future<void> selectCustomMarkerFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Restrict to specific extensions
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false, // Ensure only one file is picked
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedCustomMarkerFile = File(result.files.single.path!);
        selectedCustomMarkerName = result.files.single.name;
      });
    } else {
      // Handle case where user cancels or selects an invalid file
      print('No valid file selected or selection canceled.');
    }
  }

  Future<void> selectBannerFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Restrict to specific extensions
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: false, // Ensure only one file is picked
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedBannerFile = File(result.files.single.path!);
        selectedImageBannerName = result.files.single.name;
      });
    } else {
      // Handle case where user cancels or selects an invalid file
      print('No valid file selected or selection canceled.');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:gotaguig_admin/models/Reviews.dart';
import 'package:gotaguig_admin/services/firestore_service.dart';
import 'package:window_manager/window_manager.dart';

class ReviewsFeedbackPage extends StatefulWidget {
  const ReviewsFeedbackPage({super.key});

  @override
  State<ReviewsFeedbackPage> createState() => _ReviewsFeedbackPageState();
}

class _ReviewsFeedbackPageState extends State<ReviewsFeedbackPage> {
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  List<Reviews> reviewList = [];

  @override
  void initState() {
    super.initState();
    getAllReviews();
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

  void getAllReviews() async {
    List<Reviews>? reviews = await FirestoreService().getAllReviews();

    if (reviews != null) {
      setState(() {
        reviewList = reviews;
      });
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
          Container(
            margin: const EdgeInsets.all(20),
            child: const Text(
              "Reviews and Feedback Management",
              style: TextStyle(fontFamily: "ConcertOne", fontSize: 30),
            ),
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
                                    "User ID",
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
                                    "Full Name",
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
                                    "Email",
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
                                    "Mobile Number",
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
                                    "Reviews and Feedbacks",
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
                            reviewList.length,
                            (index) {
                              return TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    reviewList[index].userID,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    reviewList[index].name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    reviewList[index].email,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    reviewList[index].mobileNumber,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    reviewList[index].feedback,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.blueAccent.shade700,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () {
                                        setState(() {
                                          // Dialog section showing the feedback

                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController name =
                                                  TextEditingController(
                                                      text: reviewList[index]
                                                          .name);

                                              TextEditingController email =
                                                  TextEditingController(
                                                      text: reviewList[index]
                                                          .email);

                                              TextEditingController feedback =
                                                  TextEditingController(
                                                      text: reviewList[index]
                                                          .feedback);

                                              return AlertDialog(
                                                title: Row(
                                                  children: [
                                                    const Text(
                                                        "Reviews and Feedbacks"),
                                                    const Spacer(),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                            Icons.close))
                                                  ],
                                                ),
                                                titleTextStyle: const TextStyle(
                                                    fontFamily: "ConcertOne",
                                                    color: Colors.black,
                                                    fontSize: 30),
                                                content: SizedBox(
                                                  height: windowHeight * 0.6,
                                                  width: windowWidth * 0.5,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            windowHeight * 0.01,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    windowWidth *
                                                                        0.01),
                                                        child: TextField(
                                                          readOnly: true,
                                                          cursorColor:
                                                              Colors.black,
                                                          obscureText: false,
                                                          controller: name,
                                                          expands: false,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Full Name",
                                                            prefixIcon:
                                                                const Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .black),

                                                            // Label style size
                                                            labelStyle:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "ConcertOne",
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),

                                                            // Border Styles
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .black, // White border for the enabled state
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .black, // White border when the field is focused
                                                                width:
                                                                    2.0, // Optional: you can increase the border width
                                                              ),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .red, // Red border for the error state
                                                              ),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .red, // Red border when focused with error
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "ConcertOne",
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  14), // Text color set to white
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            windowHeight * 0.01,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    windowWidth *
                                                                        0.01),
                                                        child: TextField(
                                                          readOnly: true,
                                                          cursorColor:
                                                              Colors.black,
                                                          obscureText: false,
                                                          controller: email,
                                                          expands: false,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Email Address",
                                                            prefixIcon:
                                                                const Icon(
                                                                    Icons.email,
                                                                    color: Colors
                                                                        .black),

                                                            // Label style size
                                                            labelStyle:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "ConcertOne",
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),

                                                            // Border Styles
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .black, // White border for the enabled state
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .black, // White border when the field is focused
                                                                width:
                                                                    2.0, // Optional: you can increase the border width
                                                              ),
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .red, // Red border for the error state
                                                              ),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .red, // Red border when focused with error
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                          ),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "ConcertOne",
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  14), // Text color set to white
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            windowHeight * 0.01,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    windowWidth *
                                                                        0.01),
                                                        child: SizedBox(
                                                          height:
                                                              300, // Set a fixed height for the TextField (adjust as needed)
                                                          child: TextField(
                                                            readOnly: true,
                                                            minLines: 15,
                                                            maxLines:
                                                                null, // Allows the TextField to handle multiple lines
                                                            cursorColor:
                                                                Colors.black,
                                                            controller:
                                                                feedback,
                                                            scrollController:
                                                                ScrollController(), // Enables scrolling
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Details",
                                                              alignLabelWithHint:
                                                                  true, // Aligns label and icon to the top

                                                              // Label style
                                                              labelStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "ConcertOne",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),

                                                              // Border styles
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .black, // Black border for the enabled state
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .black, // Black border when the field is focused
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .red, // Red border for the error state
                                                                ),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .red, // Red border when focused with error
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.visibility,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: windowWidth * 0.0025,
                                          ),
                                          const Text(
                                            "View",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )),
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
      getAllReviews();
    });
  }
}

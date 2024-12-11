import 'package:flutter/material.dart';
import 'package:gotaguig_admin/models/Users.dart';
import 'package:gotaguig_admin/services/firestore_service.dart';
import 'package:window_manager/window_manager.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  List<Users> userList = [];

  @override
  void initState() {
    super.initState();
    getAllUsers();
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

  void getAllUsers() async {
    List<Users>? users = await FirestoreService().getAllUsers();
    if (mounted) {
      setState(() {
        userList = users!;
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
              "User Management",
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
                                    "Age",
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
                                    "Gender",
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
                            userList.length,
                            (index) {
                              return TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    userList[index].userID,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    userList[index].name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    userList[index].email,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    userList[index].age.toString(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    userList[index].gender,
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
                                          FirestoreService().deleteUserData(
                                              userList[index].userID);
                                          // Refresh the event list after deletion
                                          getAllUsers();
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            "Delete User",
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
      getAllUsers();
    });
  }
}

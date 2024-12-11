import 'package:flutter/material.dart';
import 'package:gotaguig_admin/pages/events_page.dart';
import 'package:gotaguig_admin/pages/map_manager_page.dart';
import 'package:gotaguig_admin/pages/reviews_feedback_page.dart';
import 'package:gotaguig_admin/pages/user_management.dart';
import 'package:window_manager/window_manager.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  int selectedIndex = 0;

  final List<Widget> screens = [
    const EventsPage(),
    const UserManagement(),
    const MapManagerPage(),
    const ReviewsFeedbackPage()
  ];

  @override
  void initState() {
    super.initState();
    _getWindowWidth();
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
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.shade700,
                    Colors.redAccent.shade700
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DrawerHeader(
                      child: Image.asset(
                    "lib/assets/logo/GoTaguig_Logo.png",
                    scale: 1,
                  )),
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: windowWidth * 0.015,
                        vertical: windowHeight * 0.015),
                    title: const Text(
                      "Event Manager",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "ConcertOne",
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: windowWidth * 0.015,
                        vertical: windowHeight * 0.015),
                    title: const Text(
                      "User Management",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "ConcertOne",
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    leading: const Icon(
                      Icons.pin_drop,
                      color: Colors.white,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: windowWidth * 0.015,
                        vertical: windowHeight * 0.015),
                    title: const Text(
                      "Taguig Map Manager",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "ConcertOne",
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                    leading: const Icon(
                      Icons.reviews,
                      color: Colors.white,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: windowWidth * 0.015,
                        vertical: windowHeight * 0.015),
                    title: const Text(
                      "Reviews & Feedbacks",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "ConcertOne",
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "ConcertOne",
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: screens[selectedIndex],
          ),
        ],
      ),
    );
  }
}

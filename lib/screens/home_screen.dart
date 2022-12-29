import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleatest/helpers/fetch_current_user_data.dart';
import 'package:eleatest/screens/about_us_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'connections_screen.dart';
import 'groups_screen.dart';
import 'login_screen.dart';
import 'questions_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'admin_screen.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  // Initialize the current index to 0
  int _currentIndex = 0;
  bool _isTopScreen = true;

  // Create a list of widgets for the bottom navigation bar

  // Create a list of icons for the bottom navigation bar
  final List<IconData> _icons = [
    Icons.person,
    Icons.group,
    Icons.question_answer,
  ];

  final List<String> _labels = [
    "Connections",
    "Groups",
    "Questions",
  ];

  final Widget loadingWidget = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isTopScreen) {
          return false;
        }
        setState(() {
          _isTopScreen = true;
          _currentIndex = 0;
        });
        return true;
      },
      child: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection('users').doc(_currentUserId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loadingWidget;
            }
            final currentUser = snapshot.data;
            if (currentUser == null) {
              return loadingWidget;
            }
            return FutureBuilder(
              future: fetchCurrentUserData(currentUser),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return loadingWidget;
                }
                final currentUser = snapshot.data;
                if (currentUser == null) {
                  return loadingWidget;
                }
                final List<Widget> screens = [
                  ConnectionsScreen(
                    currentUser: currentUser,
                  ),
                  GroupsScreen(
                    currentUser: currentUser,
                  ),
                  QuestionsScreen(
                    currentUser: currentUser,
                  ),
                  const TestScreen(),
                ];
                return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    title: const Text('Home'),
                    // Add a back button to the app bar
                    leading: _isTopScreen
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                    // Add a pop-out menu to the app bar
                    actions: [
                      PopupMenuButton<int>(
                        child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser["avatarUrl"])),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 1,
                            child: Text('Profile'),
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: Text('Settings'),
                          ),
                          const PopupMenuItem(
                            value: 3,
                            child: Text('Log Out'),
                          ),
                          const PopupMenuItem(
                            value: 4,
                            child: Text('Admin'),
                          ),
                          const PopupMenuItem(
                            value: 5,
                            child: Text('About us'),
                          )
                        ],
                        onSelected: (value) async {
                          if (value == 1) {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                maintainState: true,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ProfileScreen(
                                  currentUser: currentUser,
                                ),
                              ),
                            );
                          } else if (value == 2) {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                maintainState: true,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SettingsScreen(),
                              ),
                            );
                          } else if (value == 3) {
                            await _signOut();
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          } else if (value == 4) {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                maintainState: true,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const AdminScreen(),
                              ),
                            );
                          } else if (value == 5) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutUsScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  body: screens[_currentIndex],
                  bottomNavigationBar: BottomNavigationBar(
                    // Set the current index to the selected item's index
                    currentIndex: _currentIndex,
                    // Set the type of the bottom navigation bar
                    type: BottomNavigationBarType.fixed,
                    // Set the items of the bottom navigation bar
                    items: [
                      for (int i = 0; i < _labels.length; i++)
                        BottomNavigationBarItem(
                          icon: Icon(_icons[i]),
                          label: _labels[i],
                        ),
                    ],
                    // Set the onTap callback
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}

Future<void> _signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    debugPrint(e.toString());
  }
}

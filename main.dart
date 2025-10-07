/// F2025 MAD201-01 Cross Platform MA
/// Assignment 1 – Travel App
/// Author: Ishmeet Singh
/// Student ID: A00202436
///
/// Entry point of the Travel App.
/// Sets up app-wide state, bottom navigation, Drawer, dark mode toggle,
/// and navigation to Home, Details, and Profile screens.

import 'package:flutter/material.dart';
import 'models/destination.dart';
import 'repository/destination_repo.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/drawer_menu.dart';

void main() => runApp(const TravelApp());

class TravelApp extends StatefulWidget {
  const TravelApp({super.key});

  @override
  State<TravelApp> createState() => _TravelAppState();
}

class _TravelAppState extends State<TravelApp> {
  /// Repository holding all destinations
  final DestinationRepository repository = DestinationRepository();

  /// Tracks dark mode state
  bool _isDarkMode = false;

  /// Currently selected bottom navigation index
  int _currentIndex = 0;

  /// Toggle dark mode
  void toggleDarkMode(bool value) {
    setState(() => _isDarkMode = value);
  }

  /// Screens for BottomNavigationBar
  List<Widget> get _screens => [
    HomeScreen(repository: repository),
    const Center(child: Text('Bookings: No bookings yet')),
    ProfileScreen(repository: repository),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),

      /// Handle routes that need arguments
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/details':
            final destination = settings.arguments as Destination;
            return MaterialPageRoute(
              builder: (_) => DetailsScreen(
                destination: destination,
                repository: repository,
              ),
            );
          default:
            return null;
        }
      },

      home: Scaffold(
        /// Drawer
        drawer: const AppDrawer(),

        /// Show the current screen from BottomNavigationBar
        body: _screens[_currentIndex],

        /// BottomNavigationBar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

/// F2025 MAD201-01 Cross Platform MA
/// Assignment 1 – Travel App
/// Author: Ishmeet Singh
/// Student ID: A00202436
///
/// BottomNavigationBar widget for the Travel App.

import 'package:flutter/material.dart';

/// Reusable Bottom Navigation Bar
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

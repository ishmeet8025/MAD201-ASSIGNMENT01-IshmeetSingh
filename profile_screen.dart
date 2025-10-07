/// F2025 MAD201-01 Cross Platform MA
/// Assignment 1 – Travel App
/// Author: Ishmeet Singh
/// Student ID: A00202436
///
/// Profile Screen showing user info, tabs for visited destinations
/// and statistics (number of favorites and visited countries).

import 'package:flutter/material.dart';
import '../repository/destination_repo.dart';

class ProfileScreen extends StatelessWidget {
  final DestinationRepository repository;

  const ProfileScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final visited = repository
        .getAllDestinations()
        .where((d) => d.isVisited)
        .toList();
    final favorites = repository
        .getAllDestinations()
        .where((d) => d.isFavorite)
        .toList();
    final visitedCountries = repository.getVisitedCountries();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Info'),
              Tab(text: 'Visited'),
              Tab(text: 'Stats'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /// Tab 1: User Info
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://picsum.photos/200'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ishmeet Singh',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Traveler Level: Beginner'),
                ],
              ),
            ),

            /// Tab 2: Visited Destinations
            ListView.builder(
              itemCount: visited.length,
              itemBuilder: (context, index) {
                final d = visited[index];
                return ListTile(title: Text(d.name), subtitle: Text(d.country));
              },
            ),

            /// Tab 3: Statistics
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Favorites: ${favorites.length}'),
                  Text('Visited Countries: ${visitedCountries.length}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

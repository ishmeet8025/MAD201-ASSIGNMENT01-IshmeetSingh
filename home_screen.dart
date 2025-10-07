/// F2025 MAD201-01 Cross Platform MA
/// Assignment 1 – Travel App
/// Author: Ishmeet Singh
/// Student ID: A00202436
///
/// Home Screen displaying list of all destinations,
/// with search, sort, favorite toggle, and navigation to Details Screen.

import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../repository/destination_repo.dart';
import '../widgets/destination_card.dart';
import '../widgets/drawer_menu.dart';

class HomeScreen extends StatefulWidget {
  final DestinationRepository repository;

  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Destination> filteredDestinations = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredDestinations = widget.repository.getAllDestinations();
  }

  /// Filters destinations by name or country
  void _filterDestinations(String query) {
    setState(() {
      searchQuery = query;
      filteredDestinations = widget.repository.getAllDestinations().where((d) {
        return d.name.toLowerCase().contains(query.toLowerCase()) ||
            d.country.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  /// Sorts destinations by name (alphabetically)
  void _sortByName() {
    setState(() {
      filteredDestinations.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Destinations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            onPressed: _sortByName,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or country',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterDestinations,
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: filteredDestinations.length,
        itemBuilder: (context, index) {
          final destination = filteredDestinations[index];
          return DestinationCard(
            destination: destination,
            onFavorite: () {
              setState(() => widget.repository.toggleFavorite(destination));
            },
            onTap: () async {
              // Navigate to details and wait for updated destination
              await Navigator.pushNamed(
                context,
                '/details',
                arguments: destination,
              );
              setState(() {});
            },
          );
        },
      ),
    );
  }
}

/// F2025 MAD201-01 Cross Platform MA
/// Assignment 1 – Travel App
/// Author: Ishmeet Singh
/// Student ID: A00202436
///
/// Details Screen showing full info of a selected destination,
/// with buttons to mark as visited and add to favorites.

import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../repository/destination_repo.dart';

class DetailsScreen extends StatefulWidget {
  final Destination destination;
  final DestinationRepository repository;

  const DetailsScreen({
    super.key,
    required this.destination,
    required this.repository,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;

    return Scaffold(
      appBar: AppBar(title: Text(destination.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Image with "Visited" badge overlay using Stack
            Stack(
              children: [
                Image.network(
                  destination.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if (destination.isVisited)
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    destination.country,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(destination.description),
                  if (destination is TouristDestination) ...[
                    const SizedBox(height: 10),
                    Text('Rating: ${destination.rating}'),
                  ],
                  if (destination is CulturalDestination) ...[
                    const SizedBox(height: 10),
                    Text('Famous Food: ${destination.famousFood}'),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(
                            () => widget.repository.markVisited(destination),
                          );
                        },
                        child: const Text('Mark as Visited'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(
                            () => widget.repository.toggleFavorite(destination),
                          );
                        },
                        child: const Text('Add to Favorites'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

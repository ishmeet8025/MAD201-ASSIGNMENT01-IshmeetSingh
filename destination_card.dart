/// F2025 MAD201-01 Cross Platform MA
/// Assignment 1 – Travel App
/// Author: Ishmeet Singh
/// Student ID: A00202436
///
/// Reusable card widget to display a destination in the Home Screen.

import 'package:flutter/material.dart';
import '../models/destination.dart';

/// Card for displaying a single destination.
class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        /// Shows destination image
        leading: Image.network(
          destination.imageUrl,
          width: 80,
          fit: BoxFit.cover,
        ),

        /// Shows destination name and country
        title: Text('${destination.name} (${destination.country})'),

        /// Favorite star button
        trailing: IconButton(
          icon: Icon(destination.isFavorite ? Icons.star : Icons.star_border),
          onPressed: onFavorite,
        ),

        /// Navigate to details when tapped
        onTap: onTap,
      ),
    );
  }
}

/// F2025 MAD201-01 Cross Platform MA
/// Assignment 1 – Travel App
/// Author: Ishmeet Singh
/// Student ID: A00202436
///
/// This file contains the repository class for storing and managing destinations.

import '../models/destination.dart';

/// Repository class to manage travel destinations.
class DestinationRepository {
  /// List of all destinations.
  final List<Destination> _destinations = [
    TouristDestination(
      name: 'Paris',
      country: 'France',
      description: 'City of Light and love.',
      imageUrl: 'https://picsum.photos/400/200?1',
      rating: 4.8,
    ),
    CulturalDestination(
      name: 'Kyoto',
      country: 'Japan',
      description: 'Famous for temples and culture.',
      imageUrl: 'https://picsum.photos/400/200?2',
      famousFood: 'Sushi',
    ),
    TouristDestination(
      name: 'Istanbul',
      country: 'Turkey',
      description: 'A city where East meets West.',
      imageUrl: 'https://picsum.photos/400/200?3',
      rating: 4.7,
    ),
    CulturalDestination(
      name: 'New York',
      country: 'USA',
      description: 'The city that never sleeps.',
      imageUrl: 'https://picsum.photos/400/200?4',
      famousFood: 'Pizza',
    ),
  ];

  /// Returns all destinations.
  List<Destination> getAllDestinations() => _destinations;

  /// Toggles the favorite status of a destination.
  void toggleFavorite(Destination d) => d.isFavorite = !d.isFavorite;

  /// Marks a destination as visited.
  void markVisited(Destination d) => d.isVisited = true;

  /// Returns a set of countries that have been visited.
  Set<String> getVisitedCountries() =>
      _destinations.where((d) => d.isVisited).map((d) => d.country).toSet();
}

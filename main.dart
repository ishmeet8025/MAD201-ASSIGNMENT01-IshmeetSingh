// main.dart — MAD201 Assignment 1 (Ishmeet Singh - A00202436)
// Course: F2025 MAD201-01 Cross Platform MA
// Description: Travel app demonstrating Dart OOP, Flutter UI, state management, and navigation.

import 'package:flutter/material.dart';

void main() => runApp(TravelApp());

/// Represents a travel destination.
class Destination {
  final String name;
  final String country;
  final String description;
  final String imageUrl;
  bool isFavorite;
  bool isVisited;

  Destination({
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
    this.isVisited = false,
  });
}

/// Tourist destination with rating.
class TouristDestination extends Destination {
  final double rating;
  TouristDestination({
    required super.name,
    required super.country,
    required super.description,
    required super.imageUrl,
    required this.rating,
  });
}

/// Cultural destination with famous food.
class CulturalDestination extends Destination {
  final String famousFood;
  CulturalDestination({
    required super.name,
    required super.country,
    required super.description,
    required super.imageUrl,
    required this.famousFood,
  });
}

/// Repository class for managing destinations.
class DestinationRepository {
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
      description:
          'A city where East meets West, rich with history and culture.',
      imageUrl: 'https://picsum.photos/400/200?3',
      rating: 4.7,
    ),
    CulturalDestination(
      name: 'New York',
      country: 'USA',
      description:
          'The city that never sleeps, full of energy and skyscrapers.',
      imageUrl: 'https://picsum.photos/400/200?4',
      famousFood: 'New York-style Pizza',
    ),
    TouristDestination(
      name: 'Rome',
      country: 'Italy',
      description: 'Home to ancient ruins, beautiful art, and rich cuisine.',
      imageUrl: 'https://picsum.photos/400/200?5',
      rating: 4.6,
    ),
  ];

  List<Destination> getAllDestinations() => _destinations;

  void toggleFavorite(Destination d) {
    d.isFavorite = !d.isFavorite;
  }

  void markVisited(Destination d) {
    d.isVisited = true;
  }

  Set<String> getVisitedCountries() {
    return _destinations
        .where((d) => d.isVisited)
        .map((d) => d.country)
        .toSet();
  }
}

/// Root app state class
class TravelApp extends StatefulWidget {
  @override
  State<TravelApp> createState() => _TravelAppState();
}

class _TravelAppState extends State<TravelApp> {
  final DestinationRepository repository = DestinationRepository();
  bool _isDarkMode = false;

  void toggleDarkMode(bool value) {
    setState(() => _isDarkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(repository: repository),
        '/bookings': (context) => const BookingsScreen(),
        '/profile': (context) => ProfileScreen(repository: repository),
        '/about': (context) => const AboutScreen(),
        '/settings': (context) =>
            SettingsScreen(onToggle: toggleDarkMode, value: _isDarkMode),
      },
    );
  }
}

/// Home screen showing destinations
class HomeScreen extends StatefulWidget {
  final DestinationRepository repository;
  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    var destinations = widget.repository
        .getAllDestinations()
        .where(
          (d) =>
              d.name.toLowerCase().contains(query.toLowerCase()) ||
              d.country.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Destinations')),
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search destinations...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: destinations.length,
              itemBuilder: (context, i) {
                var d = destinations[i];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      d.imageUrl,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text('${d.name} (${d.country})'),
                    trailing: IconButton(
                      icon: Icon(d.isFavorite ? Icons.star : Icons.star_border),
                      onPressed: () => setState(() {
                        widget.repository.toggleFavorite(d);
                      }),
                    ),
                    onTap: () async {
                      var updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(
                            destination: d,
                            repository: widget.repository,
                          ),
                        ),
                      );
                      if (updated != null) setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Details screen
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
    var d = widget.destination;
    return Scaffold(
      appBar: AppBar(title: Text(d.name)),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Image.network(d.imageUrl, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 12),
              Text(d.description),
              if (d is TouristDestination)
                Text('Rating: ${(d as TouristDestination).rating}')
              else if (d is CulturalDestination)
                Text('Famous Food: ${(d as CulturalDestination).famousFood}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.repository.markVisited(d);
                  });
                  Navigator.pop(context, d);
                },
                child: const Text('Mark as Visited'),
              ),
              ElevatedButton(
                onPressed: () =>
                    setState(() => widget.repository.toggleFavorite(d)),
                child: const Text('Add to Favorites'),
              ),
            ],
          ),
          if (d.isVisited)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.all(6),
                child: const Text(
                  'Visited',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Profile screen with tabs
class ProfileScreen extends StatelessWidget {
  final DestinationRepository repository;
  const ProfileScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    var visited = repository
        .getAllDestinations()
        .where((d) => d.isVisited)
        .toList();
    var favorites = repository
        .getAllDestinations()
        .where((d) => d.isFavorite)
        .toList();

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
        bottomNavigationBar: BottomNavBar(),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://picsum.photos/100'),
                  ),
                  Text('Traveler: Ishmeet Singh'),
                  Text('Level: Explorer'),
                ],
              ),
            ),
            ListView(
              children: visited
                  .map((d) => ListTile(title: Text(d.name)))
                  .toList(),
            ),
            Center(
              child: Text(
                'Favorites: ${favorites.length}\nVisited Countries: ${repository.getVisitedCountries().length}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bookings')),
    body: const Center(child: Text('No bookings yet')),
    bottomNavigationBar: BottomNavBar(),
  );
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('About')),
    body: const Center(child: Text('Travel App by Ishmeet Singh (A00202436)')),
  );
}

class SettingsScreen extends StatelessWidget {
  final Function(bool) onToggle;
  final bool value;
  const SettingsScreen({
    super.key,
    required this.onToggle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: SwitchListTile(
      title: const Text('Dark Mode'),
      value: value,
      onChanged: onToggle,
    ),
  );
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            'Menu',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
        ListTile(
          title: const Text('Help'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help is on the way!')),
            );
          },
        ),
        ListTile(
          title: const Text('About'),
          onTap: () => Navigator.pushNamed(context, '/about'),
        ),
      ],
    ),
  );
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getIndex(context),
      onTap: (i) {
        switch (i) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/bookings');
            break;
          case 2:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  int _getIndex(BuildContext context) {
    var route = ModalRoute.of(context)?.settings.name;
    if (route == '/bookings') return 1;
    if (route == '/profile') return 2;
    return 0;
  }
}

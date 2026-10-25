
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Running Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LocationPage(),
    );
  }
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String locationMessage = 'Press the button to get your location';
  bool isLoading = false;

  Future<void> getLocation() async {
    setState(() {
      isLoading = true;
      locationMessage = 'Getting your location...';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          locationMessage = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          locationMessage = 'Location permission was denied.';
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationMessage = 'Location permission is permanently denied.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        locationMessage =
            'Latitude: ${position.latitude}\n'
            'Longitude: ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        locationMessage = 'Could not get location: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Running Game'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on,
                size: 64,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: isLoading ? null : getLocation,
                icon: const Icon(Icons.my_location),
                label: Text(
                  isLoading ? 'Getting Location...' : 'Get My Location',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                locationMessage,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

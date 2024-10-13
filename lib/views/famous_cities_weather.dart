import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/famous_city.dart';
import '/screens/weather_detail_screen.dart';
import '/widgets/city_weather_tile.dart';

class FamousCitiesWeather extends StatelessWidget {
  const FamousCitiesWeather({
    super.key,
  });

  Future<void> _deleteLocation(BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance.collection('famous_cities').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete location')),
      );
    }
  }

  Future<void> _editLocation(BuildContext context, FamousCity city) async {
    final nameController = TextEditingController(text: city.name);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Location'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('famous_cities').doc(city.id).update({
                    'name': nameController.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update location')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('famous_cities').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final famousCities = snapshot.data!.docs
            .map((doc) => FamousCity.fromDocument(doc))
            .toList();

        if (famousCities.isEmpty) {
          return const Center(
            child: Text('No famous cities available'),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: famousCities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final city = famousCities[index];

            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WeatherDetailScreen(
                      cityName: city.name,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  CityWeatherTile(
                    index: index,
                    city: city,
                  ),
                  Positioned(
                    top: 5,
                    right: 45,  // Adjusted for both edit and delete buttons
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editLocation(context, city),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteLocation(context, city.id),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


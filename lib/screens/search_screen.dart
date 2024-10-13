import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/famous_city.dart';
import '/constants/text_styles.dart';
import '/views/gradient_container.dart';
import '/widgets/round_text_field.dart';
import '/views/famous_cities_weather.dart';
import '/constants/app_colors.dart'; // สำหรับสีเพิ่มเติม

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late Stream<QuerySnapshot> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchResults = FirebaseFirestore.instance.collection('famous_cities').snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchResults = FirebaseFirestore.instance
          .collection('famous_cities')
          .where('name', isGreaterThanOrEqualTo: _searchController.text)
          .where('name', isLessThanOrEqualTo: '${_searchController.text}\uf8ff')
          .snapshots();
    });
  }

  Future<void> _addLocation(BuildContext context) async {
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Location'),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightBlue, // เปลี่ยนสีให้เข้ากับธีม
              ),
              onPressed: () async {
                final name = nameController.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No results found: Please enter a valid location name')),
                  );
                } else {
                  try {
                    await FirebaseFirestore.instance.collection('famous_cities').add({
                      'name': name,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location added successfully')),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add location')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightBlue, // เปลี่ยนสีให้เข้ากับธีม
              ),
              onPressed: () async {
                final name = nameController.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No results found: Please enter a valid location name')),
                  );
                } else {
                  try {
                    await FirebaseFirestore.instance.collection('famous_cities').doc(city.id).update({
                      'name': name,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location updated successfully')),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update location')),
                    );
                  }
                }
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
    return GradientContainer(
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Pick Location',
            style: TextStyles.h1,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Find the area or city that you want to know the detailed weather info at this time',
          style: TextStyles.subtitleText,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: RoundTextField(
                controller: _searchController,
                onChanged: (value) => _onSearchChanged(),
              ),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightBlue, // เปลี่ยนสีให้เข้ากับธีม
              ),
              onPressed: () => _addLocation(context),
              child: const Text('Add Location'),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _searchResults,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final cities = snapshot.data!.docs.map((doc) => FamousCity.fromDocument(doc)).toList();
              if (cities.isEmpty) {
                return const Center(
                  child: Text(
                    'No results found',
                    style: TextStyles.subtitleText,
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal, // เลื่อนในแนวนอน
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  var city = cities[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,  // ลดขนาดความกว้างของการ์ดเมือง
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(
                          city.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'light rain',  // แสดงสถานะสภาพอากาศหรือข้อมูลอื่น ๆ
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editLocation(context, city),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await FirebaseFirestore.instance.collection('famous_cities').doc(city.id).delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${city.name} deleted successfully')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const FamousCitiesWeather(),
      ],
    );
  }
}

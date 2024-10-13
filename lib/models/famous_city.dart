/*
// List of famous cities as a constant
List<FamousCity> famousCities = const [
  FamousCity(name: 'Tokyo', lat: 35.6833, lon: 139.7667),
  FamousCity(name: 'New Delhi', lat: 28.5833, lon: 77.2),
  FamousCity(name: 'Paris', lat: 48.85, lon: 2.3333),
  FamousCity(name: 'London', lat: 51.4833, lon: -0.0833),
  FamousCity(name: 'New York', lat: 40.7167, lon: -74.0167),
  FamousCity(name: 'Tehran', lat: 35.6833, lon: 51.4167),
];*/
/*------------------------------------------------------------------------------*/

import 'package:cloud_firestore/cloud_firestore.dart';

class FamousCity {
  final String id;
  final String name;

  FamousCity({
    required this.id,
    required this.name,
  });

  // แปลงจาก Firestore document เป็น FamousCity object
  factory FamousCity.fromDocument(DocumentSnapshot doc) {
    return FamousCity(
      id: doc.id,
      name: doc['name'],
    );
  }

  // แปลงจาก FamousCity object เป็น Map สำหรับบันทึกใน Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}




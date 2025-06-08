import 'package:meta/meta.dart';

@immutable
class StudioModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String openHours;
  final String description;
  final String imageUrl;

  const StudioModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.openHours,
    required this.description,
    required this.imageUrl,
  });

  factory StudioModel.fromJson(Map<String, dynamic> json) {
    return StudioModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String? ?? '',
      openHours: json['open_hours'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'open_hours': openHours,
      'description': description,
      'image_url': imageUrl,
    };
  }
} 
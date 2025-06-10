import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

@immutable
class StudioModel {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String description;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final double? latitude;
  final double? longitude;
  final List<String> images;
  final Map<String, String> hours;
  final double? distance;

  const StudioModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.isFavorite,
    this.latitude,
    this.longitude,
    required this.images,
    required this.hours,
    this.distance,
  });

  bool get isOpen {
    final now = DateTime.now();
    final days = ['월', '화', '수', '목', '금', '토', '일'];
    final currentDay = days[now.weekday - 1];
    final currentHours = hours[currentDay];

    if (currentHours == null || currentHours == '휴무') return false;

    final timeRanges = currentHours.split(',');
    for (var range in timeRanges) {
      final times = range.trim().split('-');
      if (times.length != 2) continue;

      final openTime = _parseTime(times[0].trim());
      final closeTime = _parseTime(times[1].trim());
      final currentTime = now.hour * 60 + now.minute;

      if (currentTime >= openTime && currentTime <= closeTime) {
        return true;
      }
    }
    return false;
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  factory StudioModel.fromJson(Map<String, dynamic> json) {
    final studioImages = (json['studio_images'] as List<dynamic>?)?.map((img) => img['image_url'] as String).toList() ?? [];
    final studioHours = (json['studio_hours'] as List<dynamic>?)?.fold<Map<String, String>>({}, (map, hour) {
      map[hour['day'] as String] = hour['hours'] as String;
      return map;
    }) ?? {};

    return StudioModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      isFavorite: json['is_favorite'] as bool? ?? false,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      images: studioImages,
      hours: studioHours,
      distance: json['distance'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'description': description,
      'rating': rating,
      'review_count': reviewCount,
      'is_favorite': isFavorite,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'hours': hours,
      'distance': distance,
    };
  }

  StudioModel copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? description,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    double? latitude,
    double? longitude,
    List<String>? images,
    Map<String, String>? hours,
    double? distance,
  }) {
    return StudioModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      images: images ?? this.images,
      hours: hours ?? this.hours,
      distance: distance ?? this.distance,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudioModel &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.phone == phone &&
        other.description == description &&
        other.rating == rating &&
        other.reviewCount == reviewCount &&
        other.isFavorite == isFavorite &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        listEquals(other.images, images) &&
        mapEquals(other.hours, hours) &&
        other.distance == distance;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      address,
      phone,
      description,
      rating,
      reviewCount,
      isFavorite,
      latitude,
      longitude,
      Object.hashAll(images),
      Object.hashAll(hours.entries),
      distance,
    );
  }
} 
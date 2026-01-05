/// Service model representing cleaning services
class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String duration; // e.g., "2 hours"
  final String category;
  final String? imageUrl;
  final bool isAvailable;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    this.imageUrl,
    this.isAvailable = true,
  });

  /// Create a copy with updated fields
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? duration,
    String? category,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }

  /// Create from map
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      duration: map['duration'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'],
      isAvailable: map['isAvailable'] ?? true,
    );
  }
}

/// Booking model representing service bookings
class BookingModel {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final double servicePrice;
  final DateTime bookingDate;
  final String address;
  final String? notes;
  final BookingStatus status;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.bookingDate,
    required this.address,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  /// Create a copy with updated fields
  BookingModel copyWith({
    String? id,
    String? userId,
    String? serviceId,
    String? serviceName,
    double? servicePrice,
    DateTime? bookingDate,
    String? address,
    String? notes,
    BookingStatus? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      bookingDate: bookingDate ?? this.bookingDate,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'servicePrice': servicePrice,
      'bookingDate': bookingDate.toIso8601String(),
      'address': address,
      'notes': notes,
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from map
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      serviceId: map['serviceId'] ?? '',
      serviceName: map['serviceName'] ?? '',
      servicePrice: (map['servicePrice'] ?? 0).toDouble(),
      bookingDate: DateTime.parse(map['bookingDate']),
      address: map['address'] ?? '',
      notes: map['notes'],
      status: _statusFromString(map['status'] ?? 'pending'),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  /// Parse status from string
  static BookingStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'bookingstatus.pending':
      case 'pending':
        return BookingStatus.pending;
      case 'bookingstatus.accepted':
      case 'accepted':
        return BookingStatus.accepted;
      case 'bookingstatus.ongoing':
      case 'ongoing':
        return BookingStatus.ongoing;
      case 'bookingstatus.completed':
      case 'completed':
        return BookingStatus.completed;
      case 'bookingstatus.cancelled':
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'bookingstatus.rejected':
      case 'rejected':
        return BookingStatus.rejected;
      default:
        return BookingStatus.pending;
    }
  }
}

/// Enum for booking status
enum BookingStatus {
  pending,
  accepted,
  ongoing,
  completed,
  cancelled,
  rejected,
}

/// Extension for booking status helpers
extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.ongoing:
        return 'Ongoing';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.rejected:
        return 'Rejected';
    }
  }
}

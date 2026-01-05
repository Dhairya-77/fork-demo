/// User model representing both consumers and admins
class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String address;
  final String userType; // 'consumer' or 'admin'
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.address,
    required this.userType,
    this.profileImage,
  });

  /// Create a copy of the user with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? mobile,
    String? email,
    String? address,
    String? userType,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      userType: userType ?? this.userType,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'userType': userType,
      'profileImage': profileImage,
    };
  }

  /// Create from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      userType: map['userType'] ?? 'consumer',
      profileImage: map['profileImage'],
    );
  }
}

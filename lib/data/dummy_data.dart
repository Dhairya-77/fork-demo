import 'package:home_cleaning_demo/models/user_model.dart';
import 'package:home_cleaning_demo/models/service_model.dart';
import 'package:home_cleaning_demo/models/booking_model.dart';
import 'package:home_cleaning_demo/models/notification_model.dart';

/// Global data storage for the app
/// This simulates a local database using Dart Lists
class DummyData {
  // ============ USERS ============
  /// List of registered users (both consumers and admins)
  static List<UserModel> users = [
    // Admin users
    UserModel(
      id: 'admin1',
      name: 'Rajesh Kumar',
      mobile: '9999999999',
      email: 'rajesh@homeclean.com',
      address: 'Shop No. 12, MG Road, Connaught Place, New Delhi - 110001',
      userType: 'admin',
    ),
    UserModel(
      id: 'admin2',
      name: 'Priya Sharma',
      mobile: '8888888888',
      email: 'priya@homeclean.com',
      address: '45, Brigade Road, Bangalore, Karnataka - 560001',
      userType: 'admin',
    ),
    // Consumer users
    UserModel(
      id: 'user1',
      name: 'Amit Patel',
      mobile: '1234567890',
      email: 'amit.patel@gmail.com',
      address: 'Flat 402, Orchid Apartments, Andheri West, Mumbai, Maharashtra - 400058',
      userType: 'consumer',
    ),
    UserModel(
      id: 'user2',
      name: 'Sneha Reddy',
      mobile: '9876543210',
      email: 'sneha.reddy@gmail.com',
      address: 'House No. 23, Banjara Hills, Hyderabad, Telangana - 500034',
      userType: 'consumer',
    ),
    UserModel(
      id: 'user3',
      name: 'Vikram Singh',
      mobile: '5555555555',
      email: 'vikram.singh@gmail.com',
      address: 'A-204, DLF Phase 2, Sector 25, Gurgaon, Haryana - 122002',
      userType: 'consumer',
    ),
  ];

  /// List of admin mobile numbers for quick authentication check
  static List<String> adminMobileNumbers = [
    '9999999999',
    '8888888888',
  ];

  // ============ SERVICES ============
  /// List of available cleaning services
  static List<ServiceModel> services = [
    ServiceModel(
      id: 'service1',
      name: 'Kitchen Cleaning',
      description: 'Thorough cleaning of kitchen including appliances, cabinets, countertops and floor',
      price: 1200.00,
      duration: '2 hours',
      category: 'Kitchen',
      imageUrl: '🍳',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'service2',
      name: 'Bathroom Cleaning',
      description: 'Complete bathroom sanitization including tiles, fixtures, and deep cleaning',
      price: 800.00,
      duration: '1.5 hours',
      category: 'Bathroom',
      imageUrl: '🚿',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'service3',
      name: 'Home Cleaning',
      description: 'General cleaning of your entire home including all rooms and common areas',
      price: 2000.00,
      duration: '3 hours',
      category: 'General',
      imageUrl: '🏠',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'service4',
      name: 'Window Cleaning',
      description: 'Professional window cleaning for all windows in your home',
      price: 1000.00,
      duration: '2 hours',
      category: 'Windows',
      imageUrl: '🪟',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'service5',
      name: 'Chimney Cleaning',
      description: 'Kitchen chimney cleaning and maintenance service',
      price: 900.00,
      duration: '1.5 hours',
      category: 'Appliances',
      imageUrl: '🏭',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'service6',
      name: 'Floor Cleaning',
      description: 'Deep floor cleaning and polishing for all types of flooring',
      price: 1500.00,
      duration: '2.5 hours',
      category: 'Floor',
      imageUrl: '🧽',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'service7',
      name: 'Deep Cleaning',
      description: 'Comprehensive deep cleaning of entire house including all corners and hard-to-reach areas',
      price: 3500.00,
      duration: '4-5 hours',
      category: 'Deep Clean',
      imageUrl: '🧹',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'service8',
      name: 'Sofa Cleaning',
      description: 'Professional sofa and upholstery cleaning with fabric care',
      price: 1300.00,
      duration: '2 hours',
      category: 'Furniture',
      imageUrl: '🛋️',
      isAvailable: true,
    ),
    ServiceModel(
      id: 'service9',
      name: 'Furniture Cleaning',
      description: 'Complete furniture cleaning including wooden and upholstered items',
      price: 1800.00,
      duration: '2.5 hours',
      category: 'Furniture',
      imageUrl: '🪑',
      isAvailable: true,
    ),
  ];

  // ============ BOOKINGS ============
  /// List of all bookings
  static List<BookingModel> bookings = [
    // Sample bookings for testing
    BookingModel(
      id: 'booking1',
      userId: 'user1',
      serviceId: 'service3',
      serviceName: 'Home Cleaning',
      servicePrice: 2000.00,
      bookingDate: DateTime.now().add(Duration(days: 2)),
      address: 'Flat 402, Orchid Apartments, Andheri West, Mumbai, Maharashtra - 400058',
      notes: 'Please bring eco-friendly cleaning products',
      status: BookingStatus.pending,
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
    ),
    BookingModel(
      id: 'booking2',
      userId: 'user2',
      serviceId: 'service1',
      serviceName: 'Kitchen Cleaning',
      servicePrice: 1200.00,
      bookingDate: DateTime.now().add(Duration(days: 1)),
      address: 'House No. 23, Banjara Hills, Hyderabad, Telangana - 500034',
      notes: null,
      status: BookingStatus.accepted,
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    BookingModel(
      id: 'booking3',
      userId: 'user3',
      serviceId: 'service6',
      serviceName: 'Floor Cleaning',
      servicePrice: 1500.00,
      bookingDate: DateTime.now().subtract(Duration(days: 5)),
      address: 'A-204, DLF Phase 2, Sector 25, Gurgaon, Haryana - 122002',
      notes: 'Living room and bedroom floors only',
      status: BookingStatus.completed,
      createdAt: DateTime.now().subtract(Duration(days: 7)),
    ),
  ];

  // ============ NOTIFICATIONS ============
  /// List of all notifications
  static List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif1',
      title: 'Booking Confirmed',
      message: 'Your Home Cleaning booking has been confirmed for tomorrow',
      type: 'booking',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: 'notif2',
      title: 'Special Offer!',
      message: 'Get 20% off on Deep Cleaning this weekend. Book now!',
      type: 'promotion',
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
      isRead: false,
    ),
    NotificationModel(
      id: 'notif3',
      title: 'Service Completed',
      message: 'Your Kitchen Cleaning service has been completed successfully',
      type: 'booking',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: 'notif4',
      title: 'New Service Available',
      message: 'We now offer Chimney Cleaning services in your area',
      type: 'system',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      isRead: true,
    ),
    NotificationModel(
      id: 'notif5',
      title: 'Booking Reminder',
      message: 'Your Sofa Cleaning service is scheduled for tomorrow at 10 AM',
      type: 'booking',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      isRead: true,
    ),
  ];

  // ============ HELPER METHODS ============

  /// Find user by mobile number
  static UserModel? findUserByMobile(String mobile) {
    try {
      return users.firstWhere((user) => user.mobile == mobile);
    } catch (e) {
      return null;
    }
  }

  /// Check if mobile number is admin
  static bool isAdminMobile(String mobile) {
    return adminMobileNumbers.contains(mobile);
  }

  /// Add new user
  static void addUser(UserModel user) {
    users.add(user);
  }

  /// Update user
  static void updateUser(UserModel updatedUser) {
    final index = users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      users[index] = updatedUser;
    }
  }

  /// Add new booking
  static void addBooking(BookingModel booking) {
    bookings.add(booking);
  }

  /// Update booking
  static void updateBooking(BookingModel updatedBooking) {
    final index = bookings.indexWhere((booking) => booking.id == updatedBooking.id);
    if (index != -1) {
      bookings[index] = updatedBooking;
    }
  }

  /// Get bookings for a specific user
  static List<BookingModel> getUserBookings(String userId) {
    return bookings.where((booking) => booking.userId == userId).toList();
  }

  /// Get service by ID
  static ServiceModel? getServiceById(String serviceId) {
    try {
      return services.firstWhere((service) => service.id == serviceId);
    } catch (e) {
      return null;
    }
  }

  /// Get user by ID
  static UserModel? getUserById(String userId) {
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  /// Get pending bookings count
  static int getPendingBookingsCount() {
    return bookings.where((booking) => booking.status == BookingStatus.pending).length;
  }

  /// Get monthly bookings count
  static int getMonthlyBookingsCount() {
    final now = DateTime.now();
    return bookings.where((booking) {
      return booking.createdAt.year == now.year &&
          booking.createdAt.month == now.month;
    }).length;
  }

  /// Calculate monthly earnings
  static double getMonthlyEarnings() {
    final now = DateTime.now();
    return bookings.where((booking) {
      return booking.status == BookingStatus.completed &&
          booking.createdAt.year == now.year &&
          booking.createdAt.month == now.month;
    }).fold(0.0, (sum, booking) => sum + booking.servicePrice);
  }

  /// Get unread notifications count
  static int getUnreadNotificationsCount() {
    return notifications.where((notif) => !notif.isRead).length;
  }

  /// Mark notification as read
  static void markNotificationAsRead(String notificationId) {
    final index = notifications.indexWhere((notif) => notif.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }

  /// Mark all notifications as read
  static void markAllNotificationsAsRead() {
    notifications = notifications.map((notif) => notif.copyWith(isRead: true)).toList();
  }

  /// Generate unique ID
  static String generateId(String prefix) {
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
  }
}

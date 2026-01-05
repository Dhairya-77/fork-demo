import 'package:flutter/material.dart';
import 'package:home_cleaning_demo/colors/app_colors.dart';
import 'package:home_cleaning_demo/data/dummy_data.dart';
import 'package:home_cleaning_demo/models/booking_model.dart';
import 'package:home_cleaning_demo/screens/admin/bookings/admin_booking_screen.dart';
import 'package:home_cleaning_demo/screens/admin/bookings/admin_booking_history_screen.dart';
import 'package:home_cleaning_demo/screens/admin/profile/admin_profile_screen.dart';
import 'package:home_cleaning_demo/screens/common/notification_screen.dart';

/// Admin home screen with dashboard
class AdminHomeScreen extends StatefulWidget {
  final String userId;

  const AdminHomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  /// Get pending bookings
  List<BookingModel> get _pendingBookings {
    return DummyData.bookings
        .where((booking) => booking.status == BookingStatus.pending)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Handle accept booking
  void _handleAcceptBooking(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Accept Booking'),
        content: Text('Accept this booking request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedBooking =
                  booking.copyWith(status: BookingStatus.accepted);
              DummyData.updateBooking(updatedBooking);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking accepted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: Text('Accept'),
          ),
        ],
      ),
    );
  }

  /// Handle reject booking
  void _handleRejectBooking(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Booking'),
        content: Text('Are you sure you want to reject this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedBooking =
                  booking.copyWith(status: BookingStatus.rejected);
              DummyData.updateBooking(updatedBooking);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking rejected'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('Reject'),
          ),
        ],
      ),
    );
  }

  /// Build dashboard content
  Widget _buildDashboard() {
    final newBookingsCount = DummyData.getPendingBookingsCount();
    final monthlyBookings = DummyData.getMonthlyBookingsCount();
    final monthlyEarnings = DummyData.getMonthlyEarnings();

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          floating: true,
          backgroundColor: AppColors.primary,
          title: Text(
            'Admin Dashboard',
            style: TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: AppColors.textWhite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats cards
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.pending_actions,
                        title: 'New Bookings',
                        value: newBookingsCount.toString(),
                        color: AppColors.pending,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_month,
                        title: 'Monthly Bookings',
                        value: monthlyBookings.toString(),
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _StatCard(
                  icon: Icons.trending_up,
                  title: 'Monthly Earnings',
                  value: '₹${monthlyEarnings.toStringAsFixed(2)}',
                  color: AppColors.success,
                ),
                SizedBox(height: 24),

                // Pending bookings section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pending Bookings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (_pendingBookings.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.pending,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_pendingBookings.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12),

                // Pending bookings list
                if (_pendingBookings.isEmpty)
                  Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 48,
                            color: AppColors.success,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No pending bookings',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...(_pendingBookings.map((booking) => _PendingBookingCard(
                        booking: booking,
                        onAccept: () => _handleAcceptBooking(booking),
                        onReject: () => _handleRejectBooking(booking),
                      ))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Get screen based on current index
  Widget _getScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return AdminBookingScreen();
      case 2:
        return AdminProfileScreen(userId: widget.userId);
      default:
        return _buildDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _getScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.cardBackground,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pending booking card widget
class _PendingBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _PendingBookingCard({
    Key? key,
    required this.booking,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = DummyData.getUserById(booking.userId);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (user != null) ...[
                        SizedBox(height: 4),
                        Text(
                          '${user.name} • ${user.mobile}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  '₹${booking.servicePrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                SizedBox(width: 6),
                Text(
                  '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: 16),
                Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    booking.address,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (booking.notes != null) ...[
              SizedBox(height: 8),
              Text(
                'Note: ${booking.notes}',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReject,
                    icon: Icon(Icons.close, size: 18),
                    label: Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.textWhite,
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAccept,
                    icon: Icon(Icons.check, size: 18),
                    label: Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.textWhite,
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

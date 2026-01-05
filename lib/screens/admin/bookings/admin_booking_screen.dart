import 'package:flutter/material.dart';
import 'package:home_cleaning_demo/colors/app_colors.dart';
import 'package:home_cleaning_demo/data/dummy_data.dart';
import 'package:home_cleaning_demo/models/booking_model.dart';
import 'package:home_cleaning_demo/screens/common/widgets/empty_state.dart';
import 'package:home_cleaning_demo/screens/admin/bookings/admin_booking_history_screen.dart';

/// Admin booking screen showing accepted and ongoing bookings
class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({Key? key}) : super(key: key);

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Get accepted bookings
  List<BookingModel> get _acceptedBookings {
    return DummyData.bookings
        .where((booking) => booking.status == BookingStatus.accepted)
        .toList()
      ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  }

  /// Get ongoing bookings
  List<BookingModel> get _ongoingBookings {
    return DummyData.bookings
        .where((booking) => booking.status == BookingStatus.ongoing)
        .toList()
      ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  }

  /// Show booking details
  void _showBookingDetails(BookingModel booking) {
    final user = DummyData.getUserById(booking.userId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: 'Service', value: booking.serviceName),
              _DetailRow(
                label: 'Price',
                value: '₹${booking.servicePrice.toStringAsFixed(2)}',
              ),
              _DetailRow(
                label: 'Date',
                value:
                    '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}',
              ),
              _DetailRow(label: 'Status', value: booking.status.displayName),
              if (user != null) ...[
                _DetailRow(label: 'Customer', value: user.name),
                _DetailRow(label: 'Mobile', value: user.mobile),
              ],
              _DetailRow(label: 'Address', value: booking.address),
              if (booking.notes != null)
                _DetailRow(label: 'Notes', value: booking.notes!),
            ],
          ),
        ),
        actions: [
          if (booking.status == BookingStatus.accepted)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _markAsOngoing(booking);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ongoing,
              ),
              child: Text('Mark as Ongoing'),
            ),
          if (booking.status == BookingStatus.ongoing)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _markAsCompleted(booking);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.completed,
              ),
              child: Text('Mark as Completed'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Mark booking as ongoing
  void _markAsOngoing(BookingModel booking) {
    final updatedBooking = booking.copyWith(status: BookingStatus.ongoing);
    DummyData.updateBooking(updatedBooking);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking marked as ongoing'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  /// Mark booking as completed
  void _markAsCompleted(BookingModel booking) {
    final updatedBooking = booking.copyWith(status: BookingStatus.completed);
    DummyData.updateBooking(updatedBooking);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking completed'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'All Bookings',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: AppColors.textWhite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminBookingHistoryScreen(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textWhite,
          labelColor: AppColors.textWhite,
          unselectedLabelColor: AppColors.textWhite.withOpacity(0.7),
          tabs: [
            Tab(text: 'Accepted (${_acceptedBookings.length})'),
            Tab(text: 'Ongoing (${_ongoingBookings.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Accepted bookings
          _acceptedBookings.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.check_circle_outline,
                  title: 'No Accepted Bookings',
                  message: 'Accepted bookings will appear here',
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _acceptedBookings.length,
                  itemBuilder: (context, index) {
                    return _BookingCard(
                      booking: _acceptedBookings[index],
                      onTap: () => _showBookingDetails(_acceptedBookings[index]),
                    );
                  },
                ),

          // Ongoing bookings
          _ongoingBookings.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.pending_actions,
                  title: 'No Ongoing Bookings',
                  message: 'Ongoing bookings will appear here',
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _ongoingBookings.length,
                  itemBuilder: (context, index) {
                    return _BookingCard(
                      booking: _ongoingBookings[index],
                      onTap: () => _showBookingDetails(_ongoingBookings[index]),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

/// Booking card widget
class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const _BookingCard({
    Key? key,
    required this.booking,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.accepted:
        return AppColors.accepted;
      case BookingStatus.ongoing:
        return AppColors.ongoing;
      default:
        return AppColors.textSecondary;
    }
  }

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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.serviceName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(booking.status),
                      ),
                    ),
                    child: Text(
                      booking.status.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(booking.status),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (user != null)
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                    SizedBox(width: 6),
                    Text(
                      '${user.name} • ${user.mobile}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: AppColors.textSecondary),
                  SizedBox(width: 6),
                  Text(
                    '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '₹${booking.servicePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detail row widget
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

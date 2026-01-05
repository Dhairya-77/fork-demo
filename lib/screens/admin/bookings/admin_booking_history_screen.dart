import 'package:flutter/material.dart';
import 'package:home_cleaning_demo/colors/app_colors.dart';
import 'package:home_cleaning_demo/data/dummy_data.dart';
import 'package:home_cleaning_demo/models/booking_model.dart';
import 'package:home_cleaning_demo/screens/common/widgets/empty_state.dart';

/// Admin booking history screen
class AdminBookingHistoryScreen extends StatefulWidget {
  const AdminBookingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AdminBookingHistoryScreen> createState() =>
      _AdminBookingHistoryScreenState();
}

class _AdminBookingHistoryScreenState extends State<AdminBookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Get completed bookings
  List<BookingModel> get _completedBookings {
    return DummyData.bookings
        .where((booking) => booking.status == BookingStatus.completed)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get cancelled bookings
  List<BookingModel> get _cancelledBookings {
    return DummyData.bookings
        .where((booking) => booking.status == BookingStatus.cancelled)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get rejected bookings
  List<BookingModel> get _rejectedBookings {
    return DummyData.bookings
        .where((booking) => booking.status == BookingStatus.rejected)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
              _DetailRow(
                label: 'Booked On',
                value:
                    '${booking.createdAt.day}/${booking.createdAt.month}/${booking.createdAt.year}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking History',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textWhite,
          labelColor: AppColors.textWhite,
          unselectedLabelColor: AppColors.textWhite.withOpacity(0.7),
          isScrollable: true,
          tabs: [
            Tab(text: 'Completed (${_completedBookings.length})'),
            Tab(text: 'Cancelled (${_cancelledBookings.length})'),
            Tab(text: 'Rejected (${_rejectedBookings.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Completed bookings
          _completedBookings.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.check_circle,
                  title: 'No Completed Bookings',
                  message: 'Completed bookings will appear here',
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _completedBookings.length,
                  itemBuilder: (context, index) {
                    return _BookingCard(
                      booking: _completedBookings[index],
                      onTap: () =>
                          _showBookingDetails(_completedBookings[index]),
                    );
                  },
                ),

          // Cancelled bookings
          _cancelledBookings.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.cancel,
                  title: 'No Cancelled Bookings',
                  message: 'Cancelled bookings will appear here',
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _cancelledBookings.length,
                  itemBuilder: (context, index) {
                    return _BookingCard(
                      booking: _cancelledBookings[index],
                      onTap: () =>
                          _showBookingDetails(_cancelledBookings[index]),
                    );
                  },
                ),

          // Rejected bookings
          _rejectedBookings.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.block,
                  title: 'No Rejected Bookings',
                  message: 'Rejected bookings will appear here',
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _rejectedBookings.length,
                  itemBuilder: (context, index) {
                    return _BookingCard(
                      booking: _rejectedBookings[index],
                      onTap: () => _showBookingDetails(_rejectedBookings[index]),
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
      case BookingStatus.completed:
        return AppColors.completed;
      case BookingStatus.cancelled:
        return AppColors.cancelled;
      case BookingStatus.rejected:
        return AppColors.rejected;
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

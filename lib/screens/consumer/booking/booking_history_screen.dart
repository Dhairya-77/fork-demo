import 'package:flutter/material.dart';
import 'package:home_cleaning_demo/colors/app_colors.dart';
import 'package:home_cleaning_demo/data/dummy_data.dart';
import 'package:home_cleaning_demo/models/booking_model.dart';
import 'package:home_cleaning_demo/screens/common/widgets/empty_state.dart';

/// Booking history screen showing all bookings
class BookingHistoryScreen extends StatefulWidget {
  final String userId;

  const BookingHistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
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

  /// Get user bookings
  List<BookingModel> get _userBookings {
    return DummyData.getUserBookings(widget.userId);
  }

  /// Get ongoing bookings
  List<BookingModel> get _ongoingBookings {
    return _userBookings.where((booking) {
      return booking.status == BookingStatus.pending ||
          booking.status == BookingStatus.accepted ||
          booking.status == BookingStatus.ongoing;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get history bookings
  List<BookingModel> get _historyBookings {
    return _userBookings.where((booking) {
      return booking.status == BookingStatus.completed ||
          booking.status == BookingStatus.cancelled ||
          booking.status == BookingStatus.rejected;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Show booking details dialog
  void _showBookingDetails(BookingModel booking) {
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
          if (booking.status == BookingStatus.pending ||
              booking.status == BookingStatus.accepted)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _cancelBooking(booking);
              },
              child: Text('Cancel Booking', style: TextStyle(color: AppColors.error)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Cancel booking
  void _cancelBooking(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedBooking =
                  booking.copyWith(status: BookingStatus.cancelled);
              DummyData.updateBooking(updatedBooking);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('Yes, Cancel'),
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
        title: Text(
          'My Bookings',
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
          tabs: [
            Tab(text: 'Ongoing'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Ongoing tab
          _ongoingBookings.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.calendar_today,
                  title: 'No Ongoing Bookings',
                  message: 'You don\'t have any ongoing bookings',
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

          // History tab
          _historyBookings.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.history,
                  title: 'No Booking History',
                  message: 'Your booking history will appear here',
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _historyBookings.length,
                  itemBuilder: (context, index) {
                    return _BookingCard(
                      booking: _historyBookings[index],
                      onTap: () => _showBookingDetails(_historyBookings[index]),
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
      case BookingStatus.pending:
        return AppColors.pending;
      case BookingStatus.accepted:
        return AppColors.accepted;
      case BookingStatus.ongoing:
        return AppColors.ongoing;
      case BookingStatus.completed:
        return AppColors.completed;
      case BookingStatus.cancelled:
        return AppColors.cancelled;
      case BookingStatus.rejected:
        return AppColors.rejected;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  // Service name
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
                  // Status badge
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
              // Booking details
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
              if (booking.notes != null) ...[
                SizedBox(height: 8),
                Text(
                  booking.notes!,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Detail row widget for dialog
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

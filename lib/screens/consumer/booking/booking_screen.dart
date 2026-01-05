import 'package:flutter/material.dart';
import 'package:home_cleaning_demo/colors/app_colors.dart';
import 'package:home_cleaning_demo/data/dummy_data.dart';
import 'package:home_cleaning_demo/models/service_model.dart';
import 'package:home_cleaning_demo/models/booking_model.dart';
import 'package:home_cleaning_demo/models/user_model.dart';
import 'package:home_cleaning_demo/screens/common/widgets/custom_button.dart';
import 'package:home_cleaning_demo/screens/common/widgets/custom_textfield.dart';

/// Booking screen for creating new service bookings
class BookingScreen extends StatefulWidget {
  final String userId;
  final ServiceModel service;

  const BookingScreen({
    Key? key,
    required this.userId,
    required this.service,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill address from user profile
    final user = DummyData.getUserById(widget.userId);
    if (user != null) {
      _addressController.text = user.address;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  /// Select date for booking
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textWhite,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Handle booking confirmation
  void _handleBooking() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a booking date'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      _showConfirmationDialog();
    }
  }

  /// Show confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Confirm Booking'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: ${widget.service.name}'),
            SizedBox(height: 4),
            Text('Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
            SizedBox(height: 4),
            Text('Price: ₹${widget.service.price.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text(
              'Are you sure you want to book this service?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  /// Confirm and save booking
  void _confirmBooking() {
    setState(() {
      _isLoading = true;
    });

    // Create booking
    final booking = BookingModel(
      id: DummyData.generateId('booking'),
      userId: widget.userId,
      serviceId: widget.service.id,
      serviceName: widget.service.name,
      servicePrice: widget.service.price,
      bookingDate: _selectedDate!,
      address: _addressController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    // Save to local storage
    DummyData.addBooking(booking);

    // Simulate network delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back
      Navigator.pop(context);
    });
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
          'Book Service',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service details card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Service icon
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        widget.service.imageUrl ?? '🧹',
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Service name
                    Text(
                      widget.service.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    // Service description
                    Text(
                      widget.service.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textWhite.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    // Service details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _DetailChip(
                          icon: Icons.access_time,
                          label: widget.service.duration,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.cardBackground.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '₹${widget.service.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Booking form
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date picker
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: AppColors.primary),
                            SizedBox(width: 12),
                            Text(
                              _selectedDate == null
                                  ? 'Choose a date'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: TextStyle(
                                fontSize: 15,
                                color: _selectedDate == null
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios,
                                size: 16, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Address field
                    CustomTextField(
                      controller: _addressController,
                      label: 'Service Address',
                      hint: 'Enter complete address',
                      prefixIcon: Icons.location_on,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Notes field
                    CustomTextField(
                      controller: _notesController,
                      label: 'Additional Notes (Optional)',
                      hint: 'Any special instructions or requirements',
                      prefixIcon: Icons.note,
                      maxLines: 4,
                    ),
                    SizedBox(height: 32),

                    // Book button
                    CustomButton(
                      text: 'Book Now',
                      onPressed: _handleBooking,
                      isLoading: _isLoading,
                      icon: Icons.check_circle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detail chip widget
class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBackground.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.textWhite),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}

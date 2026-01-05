import 'package:flutter/material.dart';
import 'package:home_cleaning_demo/colors/app_colors.dart';
import 'package:home_cleaning_demo/data/dummy_data.dart';
import 'package:home_cleaning_demo/models/user_model.dart';
import 'package:home_cleaning_demo/models/service_model.dart';
import 'package:home_cleaning_demo/screens/consumer/booking/booking_screen.dart';
import 'package:home_cleaning_demo/screens/consumer/booking/booking_history_screen.dart';
import 'package:home_cleaning_demo/screens/consumer/profile/consumer_profile_screen.dart';
import 'package:home_cleaning_demo/screens/common/notification_screen.dart';

/// Consumer home screen with services grid
class ConsumerHomeScreen extends StatefulWidget {
  final String userId;

  const ConsumerHomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ConsumerHomeScreen> createState() => _ConsumerHomeScreenState();
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  int _currentIndex = 0;
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<ServiceModel> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _filteredServices = DummyData.services;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Get current user
  UserModel? get _currentUser => DummyData.getUserById(widget.userId);

  /// Filter services based on search and category
  void _filterServices() {
    setState(() {
      _filteredServices = DummyData.services.where((service) {
        // Search filter
        final searchTerm = _searchController.text.toLowerCase();
        final matchesSearch = service.name.toLowerCase().contains(searchTerm) ||
            service.description.toLowerCase().contains(searchTerm);

        // Category filter
        final matchesCategory =
            _selectedCategory == 'All' || service.category == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  /// Get unique categories
  List<String> get _categories {
    final categories = DummyData.services
        .map((service) => service.category)
        .toSet()
        .toList();
    return ['All', ...categories];
  }

  /// Build home content
  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          floating: true,
          backgroundColor: AppColors.primary,
          title: Text(
            'Home Cleaning Services',
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

        // Search bar
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _filterServices(),
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ),

        // Category filter
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        _filterServices();
                      });
                    },
                    backgroundColor: AppColors.cardBackground,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Services grid
        _filteredServices.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
                      SizedBox(height: 16),
                      Text(
                        'No services found',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final service = _filteredServices[index];
                      return _ServiceCard(
                        service: service,
                        onTap: () => _navigateToBooking(service),
                      );
                    },
                    childCount: _filteredServices.length,
                  ),
                ),
              ),
      ],
    );
  }

  /// Navigate to booking screen
  void _navigateToBooking(ServiceModel service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          userId: widget.userId,
          service: service,
        ),
      ),
    );
  }

  /// Get screen based on current index
  Widget _getScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return BookingHistoryScreen(userId: widget.userId);
      case 2:
        return ConsumerProfileScreen(userId: widget.userId);
      default:
        return _buildHomeContent();
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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
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

/// Service card widget
class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const _ServiceCard({
    Key? key,
    required this.service,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
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
            // Service icon/image
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Text(
                  service.imageUrl ?? '🧹',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service name
                        Text(
                          service.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        // Duration
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 11, color: AppColors.textSecondary),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                service.duration,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Price
                    Text(
                      '₹${service.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

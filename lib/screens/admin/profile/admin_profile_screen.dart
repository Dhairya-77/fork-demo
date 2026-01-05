import 'package:flutter/material.dart';
import 'package:home_cleaning_demo/colors/app_colors.dart';
import 'package:home_cleaning_demo/data/dummy_data.dart';
import 'package:home_cleaning_demo/models/user_model.dart';
import 'package:home_cleaning_demo/screens/common/widgets/custom_button.dart';
import 'package:home_cleaning_demo/screens/common/widgets/custom_textfield.dart';
import 'package:home_cleaning_demo/screens/auth/login_screen.dart';

/// Admin profile screen
class AdminProfileScreen extends StatefulWidget {
  final String userId;

  const AdminProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  /// Load user data
  void _loadUserData() {
    final user = DummyData.getUserById(widget.userId);
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _addressController.text = user.address;
      _mobileController.text = user.mobile;
    }
  }

  /// Handle save
  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(Duration(seconds: 1), () {
        final user = DummyData.getUserById(widget.userId);
        if (user != null) {
          final updatedUser = user.copyWith(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            address: _addressController.text.trim(),
          );

          DummyData.updateUser(updatedUser);

          setState(() {
            _isLoading = false;
            _isEditing = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      });
    }
  }

  /// Handle logout
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = DummyData.getUserById(widget.userId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Admin Profile',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.textWhite),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: user == null
          ? Center(child: Text('User not found'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        // Profile image
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.warning.withOpacity(0.2),
                            child: Icon(
                              Icons.admin_panel_settings,
                              size: 50,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.warning),
                          ),
                          child: Text(
                            'ADMIN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          user.mobile,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textWhite.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile form
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name field
                          CustomTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Enter your name',
                            prefixIcon: Icons.person,
                            enabled: _isEditing,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Mobile field (read-only)
                          CustomTextField(
                            controller: _mobileController,
                            label: 'Mobile Number',
                            hint: 'Mobile number',
                            prefixIcon: Icons.phone,
                            enabled: false,
                          ),
                          SizedBox(height: 16),

                          // Email field
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'Enter email',
                            prefixIcon: Icons.email,
                            enabled: _isEditing,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Address field
                          CustomTextField(
                            controller: _addressController,
                            label: 'Address',
                            hint: 'Enter address',
                            prefixIcon: Icons.location_on,
                            enabled: _isEditing,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 32),

                          // Action buttons
                          if (_isEditing) ...[
                            CustomButton(
                              text: 'Save Changes',
                              onPressed: _handleSave,
                              isLoading: _isLoading,
                              icon: Icons.check,
                            ),
                            SizedBox(height: 12),
                            CustomButton(
                              text: 'Cancel',
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                  _loadUserData();
                                });
                              },
                              backgroundColor: AppColors.textSecondary,
                            ),
                          ] else ...[
                            CustomButton(
                              text: 'Logout',
                              onPressed: _handleLogout,
                              backgroundColor: AppColors.error,
                              icon: Icons.logout,
                            ),
                          ],
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

import 'package:flutter/material.dart';
import 'package:home_cleaning_demo/colors/app_colors.dart';
import 'package:home_cleaning_demo/data/dummy_data.dart';
import 'package:home_cleaning_demo/models/user_model.dart';
import 'package:home_cleaning_demo/screens/common/widgets/custom_button.dart';
import 'package:home_cleaning_demo/screens/common/widgets/custom_textfield.dart';
import 'package:home_cleaning_demo/screens/consumer/home/consumer_home_screen.dart';
import 'package:home_cleaning_demo/screens/admin/home/admin_home_screen.dart';

/// Registration screen for new users
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
 _addressController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Send OTP
  void _sendOTP() {
    if (_formKey.currentState!.validate()) {
      final mobile = _mobileController.text.trim();
      
      // Check if mobile is admin mobile
      if (DummyData.isAdminMobile(mobile)) {
        _showErrorDialog('This mobile number is reserved for admin. Please use a different number.');
        return;
      }
      
      // Check if user already exists
      final existingUser = DummyData.findUserByMobile(mobile);
      if (existingUser != null) {
        _showErrorDialog('Mobile number already registered. Please login.');
        return;
      }
      
      setState(() {
        _otpSent = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent to $mobile (Use: 123456)'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  /// Handle registration
  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (!_otpSent) {
        _sendOTP();
        return;
      }
      
      // Validate OTP
      if (_otpController.text.trim() != '123456') {
        _showErrorDialog('Invalid OTP. Please enter 123456');
        return;
      }
      
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      Future.delayed(Duration(seconds: 1), () {
        final mobile = _mobileController.text.trim();

        // Create new consumer user (no admin registration)
        final newUser = UserModel(
          id: DummyData.generateId('user'),
          name: _nameController.text.trim(),
          mobile: mobile,
          email: _emailController.text.trim(),
          address: _addressController.text.trim(),
          userType: 'consumer', // Always consumer
        );

        // Add to local storage
        DummyData.addUser(newUser);

        // Navigate to consumer home screen
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConsumerHomeScreen(userId: newUser.id),
          ),
        );
      });
    }
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Register',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Fill in the details to create your account',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 32),

                // Name field
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Mobile field
                CustomTextField(
                  controller: _mobileController,
                  label: 'Mobile Number',
                  hint: 'Enter your 10-digit mobile number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    if (value.length != 10) {
                      return 'Mobile number must be 10 digits';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Email field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email address',
                  prefixIcon: Icons.email,
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
                  hint: 'Enter your complete address',
                  prefixIcon: Icons.location_on,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    if (value.length < 10) {
                      return 'Please enter complete address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                // OTP field (shows after validation)
                if (_otpSent) ...[
                  CustomTextField(
                    controller: _otpController,
                    label: 'OTP',
                    hint: 'Enter 6-digit OTP',
                    prefixIcon: Icons.lock_outline,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                ],
                SizedBox(height: 16),

                // Register button
                CustomButton(
                  text: _otpSent ? 'Verify & Register' : 'Send OTP',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 24),

                // Info message
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, 
                        color: AppColors.success, 
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Registration is for consumers only. Admin accounts are pre-configured.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:home_cleaning_demo/colors/app_colors.dart';
import 'package:home_cleaning_demo/data/dummy_data.dart';
import 'package:home_cleaning_demo/models/user_model.dart';
import 'package:home_cleaning_demo/screens/common/widgets/custom_button.dart';
import 'package:home_cleaning_demo/screens/common/widgets/custom_textfield.dart';
import 'package:home_cleaning_demo/screens/consumer/home/consumer_home_screen.dart';
import 'package:home_cleaning_demo/screens/admin/home/admin_home_screen.dart';
import 'package:home_cleaning_demo/screens/auth/register_screen.dart';

/// Login screen for authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Send OTP
  void _sendOTP() {
    if (_mobileController.text.trim().length == 10 && 
        RegExp(r'^[0-9]+$').hasMatch(_mobileController.text.trim())) {
      final mobile = _mobileController.text.trim();
      final user = DummyData.findUserByMobile(mobile);
      
      if (user != null) {
        setState(() {
          _otpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent to $mobile (Use: 123456)'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        _showErrorDialog('Mobile number not registered. Please register first.');
      }
    }
  }

  /// Handle login button press
  void _handleLogin() {
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
        final user = DummyData.findUserByMobile(mobile);

        if (user != null) {
          _navigateToHome(user);
        } else {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('Mobile number not registered. Please register first.');
        }
      });
    }
  }

  /// Demo login for consumer
  void _demoLoginConsumer() {
    final user = DummyData.getUserById('user1');
    if (user != null) {
      _navigateToHome(user);
    }
  }

  /// Demo login for admin
  void _demoLoginAdmin() {
    final user = DummyData.getUserById('admin1');
    if (user != null) {
      _navigateToHome(user);
    }
  }

  /// Navigate to appropriate home screen based on user type
  void _navigateToHome(UserModel user) {
    setState(() {
      _isLoading = false;
    });

    if (user.userType == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminHomeScreen(userId: user.id),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConsumerHomeScreen(userId: user.id),
        ),
      );
    }
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
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

  /// Navigate to registration screen
  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App logo/icon
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cleaning_services,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Welcome text
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Login to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48),

                  // Mobile number field
                  CustomTextField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    hint: 'Enter your 10-digit mobile number',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    enabled: !_otpSent,
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
                  
                  // OTP field (shows after mobile is validated)
                  if (_otpSent) ...[
                    SizedBox(height: 20),
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
                  ],
                  SizedBox(height: 32),

                  // Login button
                  CustomButton(
                    text: _otpSent ? 'Verify & Login' : 'Send OTP',
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 24),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      InkWell(
                        onTap: _navigateToRegister,
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.divider)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.divider)),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Demo login buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _demoLoginConsumer,
                          icon: Icon(Icons.person, size: 18),
                          label: Text('Consumer\nDemo'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _demoLoginAdmin,
                          icon: Icon(Icons.admin_panel_settings, size: 18),
                          label: Text('Admin\nDemo'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppColors.warning),
                            foregroundColor: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Demo credentials info
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, 
                              color: AppColors.info, 
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Demo Credentials',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Admin: 9999999999\nConsumer: 1234567890\nOTP: 123456',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            height: 1.5,
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
      ),
    );
  }
}

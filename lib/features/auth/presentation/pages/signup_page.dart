import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/auth/presentation/state/auth_state.dart';
import 'package:lost_n_found/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';
import 'package:lost_n_found/features/batch/presentation/view_model/batch_viewmodel.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/utils/snackbar_utils.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  String? _selectedBatch;
  String _selectedCountryCode = '+977'; // Default Nepal

  final List<Map<String, String>> _countryCodes = [
    {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
    {'code': '+86', 'name': 'China', 'flag': '🇨🇳'},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(batchViewModelProvider.notifier).getAllBatches();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_agreedToTerms) {
      SnackbarUtils.showError(context, 'Please agree to the Terms & Conditions');
      return;
    }

    if (_formKey.currentState!.validate()) {
      await ref.read(authViewModelProvider.notifier).register(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            username: _emailController.text.trim().split('@').first,
            password: _passwordController.text.trim(),
            phoneNumber: '$_selectedCountryCode${_phoneController.text.trim()}',
            batchId: _selectedBatch,
          );
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final batchState = ref.watch(batchViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(context, 'Registration successful! Please login.');
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.of(context).pop();
        });
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: context.softShadow,
            ),
            child: Icon(Icons.arrow_back, color: context.textPrimary, size: 20),
          ),
          onPressed: _navigateToLogin,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header Section
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(50),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_add_rounded, size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Join Us Today',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: context.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your account to get started',
                          style: TextStyle(fontSize: 14, color: context.textSecondary.withAlpha(180)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Full Name Field
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (value) => (value == null || value.length < 3) ? 'Name must be at least 3 characters' : null,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Number Row - FIX APPLIED HERE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 105, // Increased slightly to give more room
                        child: DropdownButtonFormField<String>(
                          value: _selectedCountryCode,
                          isExpanded: true, // Prevents overflow inside the dropdown
                          decoration: const InputDecoration(
                            labelText: 'Code',
                            contentPadding: EdgeInsets.symmetric(horizontal: 8), // Tighter padding
                          ),
                          items: _countryCodes.map((country) {
                            return DropdownMenuItem(
                              value: country['code'],
                              child: Text(
                                '${country['flag']} ${country['code']}',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedCountryCode = val!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            counterText: '',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: (value) => (value == null || value.length != 10) ? 'Enter 10 digit number' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Batch Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedBatch,
                    isExpanded: true, // Also added here to prevent long batch name overflows
                    decoration: InputDecoration(
                      labelText: 'Select Batch',
                      hintText: batchState.status == BatchStatus.loading ? 'Loading...' : 'Choose your batch',
                      prefixIcon: const Icon(Icons.school_rounded),
                    ),
                    items: batchState.batches.map((batch) {
                      return DropdownMenuItem<String>(
                        value: batch.batchId,
                        child: Text(batch.batchName),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedBatch = value),
                    validator: (value) => value == null ? 'Please select your batch' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) => (value == null || value.length < 6) ? 'Min 6 characters required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    validator: (value) => (value != _passwordController.text) ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 20),

                  // Terms & Conditions
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(color: context.textSecondary, fontSize: 13),
                            children: [
                              TextSpan(text: 'Terms & Conditions', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              const TextSpan(text: ' and '),
                              TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  GradientButton(
                    text: 'Create Account',
                    onPressed: _handleSignup,
                    isLoading: authState.status == AuthStatus.loading,
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ', style: TextStyle(color: context.textSecondary)),
                      GestureDetector(
                        onTap: _navigateToLogin,
                        child: Text('Login', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
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
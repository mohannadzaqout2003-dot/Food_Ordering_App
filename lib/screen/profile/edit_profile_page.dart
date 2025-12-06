
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/localization/app_string.dart';
import 'package:restaurant_app/provider/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _loading = false;
  bool _initialLoading = true;
  bool _isPicking = false;

  String? _photoUrl;
  File? _localImageFile;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _initialLoading = false;
      });
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;

        final firstName = data['firstName'] as String?;
        final lastName = data['lastName'] as String?;
        final phone = data['phone'] as String?;
        final photoUrl = data['photoUrl'] as String?;

        if (firstName != null && firstName.isNotEmpty) {
          _firstNameController.text = firstName;
        } else if (user.displayName != null && user.displayName!.isNotEmpty) {
          final parts = user.displayName!.trim().split(' ');
          _firstNameController.text = parts.first;
        } else {
          _firstNameController.text = user.email?.split('@').first ?? '';
        }

        if (lastName != null && lastName.isNotEmpty) {
          _lastNameController.text = lastName;
        } else if (user.displayName != null && user.displayName!.isNotEmpty) {
          final parts = user.displayName!.trim().split(' ');
          if (parts.length > 1) {
            _lastNameController.text = parts.sublist(1).join(' ');
          }
        }

        _phoneController.text = phone ?? '';
        _photoUrl = photoUrl;
      } else {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          final parts = user.displayName!.trim().split(' ');
          _firstNameController.text = parts.first;
          if (parts.length > 1) {
            _lastNameController.text = parts.sublist(1).join(' ');
          }
        } else {
          _firstNameController.text = user.email?.split('@').first ?? '';
          _lastNameController.text = '';
        }
        _phoneController.text = '';
        _photoUrl = null;
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _initialLoading = false;
      });
    }
  }

  Future<void> _pickImageFrom(ImageSource source) async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 70);

      if (picked != null) {
        setState(() {
          _localImageFile = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    } finally {
      _isPicking = false;
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFrom(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFrom(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _uploadImageIfNeeded(String uid) async {
    if (_localImageFile == null) return _photoUrl;

    final ref = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(uid)
        .child('avatar.jpg');

    final uploadTask = await ref.putFile(_localImageFile!);
    final url = await uploadTask.ref.getDownloadURL();
    return url;
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    try {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phone = _phoneController.text.trim();

      if (firstName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('First name cannot be empty')),
        );
        setState(() => _loading = false);
        return;
      }

      final fullName = lastName.isNotEmpty ? '$firstName $lastName' : firstName;

      await user.updateDisplayName(fullName);

      final photoUrl = await _uploadImageIfNeeded(user.uid);

      await _firestore.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': user.email,
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final authProvider = context.read<AuthProvider>();
      await authProvider.refreshUser();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'edit_profile_title')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: isDark ? theme.cardColor : Colors.brown[100],
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 45.r,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: _localImageFile != null
                                    ? FileImage(_localImageFile!)
                                    : (_photoUrl != null
                                              ? NetworkImage(_photoUrl!)
                                              : null)
                                          as ImageProvider<Object>?,
                                child:
                                    (_localImageFile == null &&
                                        _photoUrl == null)
                                    ? Icon(
                                        Icons.person,
                                        size: 45.r,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: InkWell(
                                  onTap: _showImageSourceActionSheet,
                                  child: Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 18.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                isDark ? 0.15 : 0.85,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'Replace Profile Image',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? colorScheme.onSurface
                                    : colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: AppStrings.t(context, 'edit_profile_first_name'),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16.h),

            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: AppStrings.t(context, 'edit_profile_last_name'),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 16.h),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: AppStrings.t(context, 'edit_profile_phone'),

                prefixIcon: Icon(Icons.phone),
              ),
            ),

            SizedBox(height: 30.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: _loading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        AppStrings.t(context, 'edit_profile_save'),

                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Legal',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Terms of Service
            _buildLegalItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms and conditions',
              onTap: () {
                _showLegalDocument(
                  context,
                  'Terms of Service',
                  _getTermsOfService(),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Privacy Policy
            _buildLegalItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              onTap: () {
                _showLegalDocument(
                  context,
                  'Privacy Policy',
                  _getPrivacyPolicy(),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Licenses
            _buildLegalItem(
              icon: Icons.copyright_outlined,
              title: 'Open Source Licenses',
              subtitle: 'Third-party software licenses',
              onTap: () {
                _showLegalDocument(
                  context,
                  'Open Source Licenses',
                  _getLicenses(),
                );
              },
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF7FDFB8).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF7FDFB8),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLegalDocument(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: SingleChildScrollView(
              child: Text(
                content,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _getTermsOfService() {
    return '''
TERMS OF SERVICE

Last updated: ${DateTime.now().year}

1. ACCEPTANCE OF TERMS
By using this Math App, you agree to these Terms of Service.

2. USE OF THE SERVICE
You may use this app for personal, educational purposes only.

3. USER ACCOUNTS
You are responsible for maintaining the confidentiality of your account.

4. PROHIBITED USES
You may not use the service for any illegal or unauthorized purpose.

5. INTELLECTUAL PROPERTY
All content in this app is owned by us or our licensors.

6. LIMITATION OF LIABILITY
We are not liable for any damages arising from your use of the app.

7. CHANGES TO TERMS
We reserve the right to modify these terms at any time.

8. CONTACT
For questions about these terms, contact us at support@mathapp.com
''';
  }

  String _getPrivacyPolicy() {
    return '''
PRIVACY POLICY

Last updated: ${DateTime.now().year}

1. INFORMATION WE COLLECT
We collect information you provide when creating an account and using our services.

2. HOW WE USE INFORMATION
- To provide and improve our services
- To communicate with you
- To ensure security

3. INFORMATION SHARING
We do not sell or share your personal information with third parties.

4. DATA SECURITY
We implement appropriate security measures to protect your information.

5. YOUR RIGHTS
You have the right to access, update, or delete your personal information.

6. COOKIES
We use cookies to improve your experience and analyze usage.

7. CHILDREN'S PRIVACY
Our service is not intended for children under 13.

8. CHANGES TO POLICY
We may update this policy and will notify you of significant changes.

9. CONTACT
For privacy questions, contact us at privacy@mathapp.com
''';
  }

  String _getLicenses() {
    return '''
OPEN SOURCE LICENSES

This app uses the following open source software:

Flutter Framework
Copyright (c) 2017 The Flutter Authors
Licensed under the BSD 3-Clause License

HTTP Package
Copyright (c) 2014, the Dart project authors
Licensed under the BSD 3-Clause License

Shared Preferences
Copyright (c) 2017 The Flutter Authors
Licensed under the BSD 3-Clause License

Material Design Icons
Copyright (c) Google Inc.
Licensed under the Apache License 2.0

For complete license texts, visit:
https://opensource.org/licenses/
''';
  }
}

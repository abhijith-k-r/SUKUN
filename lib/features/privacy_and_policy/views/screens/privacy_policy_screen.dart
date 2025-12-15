import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(r.w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Last Updated: November 2025',
                style: textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.grey500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'At Grande Electricals, we value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your information when you visit our website (grandelectricals.com).',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('1. Information We Collect'),
              const SizedBox(height: 8),
              Text(
                'We may collect the following types of information:',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                context,
                'Personal information like name, email, phone number, or address.',
              ),
              _buildBulletPoint(
                context,
                'Non-personal data such as browser type, device information, and pages visited.',
              ),
              _buildBulletPoint(
                context,
                'Order and payment details when you make a purchase.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('2. How We Use Your Information'),
              const SizedBox(height: 8),
              Text('We use your information to:', style: textTheme.bodyLarge),
              const SizedBox(height: 8),
              _buildBulletPoint(context, 'Process and manage your orders.'),
              _buildBulletPoint(
                context,
                'Improve our website and customer service.',
              ),
              _buildBulletPoint(
                context,
                'Send order updates or promotional messages (if you agree).',
              ),
              _buildBulletPoint(
                context,
                'Ensure website security and prevent fraudulent activities.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('3. Cookies'),
              const SizedBox(height: 8),
              Text(
                'We use cookies to enhance your browsing experience. You can choose to disable cookies in your browser settings, but some features of the site may not work properly without them.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('4. Data Protection'),
              const SizedBox(height: 8),
              Text(
                'We take reasonable steps to protect your personal information from unauthorized access, alteration, or disclosure. However, no method of online transmission is 100% secure.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('5. Sharing Your Information'),
              const SizedBox(height: 8),
              Text(
                'We do not sell or rent your personal information. We may share data only with trusted third parties that help operate our business, such as payment processors or delivery partners — and only when necessary.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('6. Third-Party Links'),
              const SizedBox(height: 8),
              Text(
                'Our website may contain links to external sites. We are not responsible for the privacy policies or content of those websites.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('7. Your Rights'),
              const SizedBox(height: 8),
              Text(
                'You have the right to access, update, or delete your personal information. To make such requests, please contact us using the email address below.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('8. Updates to This Policy'),
              const SizedBox(height: 8),
              Text(
                'We may update this Privacy Policy from time to time. Any changes will be reflected on this page with the updated date shown above.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('9. Contact Us'),
              const SizedBox(height: 8),
              Text(
                'If you have questions or concerns about this Privacy Policy, please contact us:',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'info@grandelectricals.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  static Widget _buildBulletPoint(BuildContext context, String text) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: textTheme.bodyLarge),
          Expanded(child: Text(text, style: textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

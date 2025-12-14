import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textThem = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(AppColors.black, BlendMode.color),
            image: AssetImage('assets/bg_sing_in_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Frequently Asked Questions',
                          style: textThem.headlineLarge?.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Find answers to common questions about our services and organization.',
                          style: textThem.bodyMedium?.copyWith(
                            color: Colors.teal[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // FAQ Items
                  const FAQItem(
                    question: 'What is the mission of Al-Huda?',
                    answer:
                        'Al-Huda\'s mission is to promote Islamic knowledge and understanding through education, community service, and outreach programs.',
                  ),
                  const FAQItem(
                    question: 'How can I donate to Al-Huda?',
                    answer:
                        'You can donate through our website, mobile app, or by visiting our office. We accept various payment methods including credit cards, bank transfers, and cash donations.',
                  ),
                  const FAQItem(
                    question: 'What types of services does Al-Huda offer?',
                    answer:
                        'Al-Huda offers educational programs, community services, religious guidance, youth programs, and various outreach activities.',
                  ),
                  const FAQItem(
                    question: 'Is Al-Huda a non-profit organization?',
                    answer:
                        'Yes, Al-Huda is a registered non-profit organization dedicated to serving the community and promoting Islamic education.',
                  ),
                  const FAQItem(
                    question: 'How can I volunteer with Al-Huda?',
                    answer:
                        'To volunteer, you can fill out our volunteer application form on the website, contact our office directly, or attend our volunteer orientation sessions held monthly.',
                  ),
                  SizedBox(height: r.hLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black54,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.teal[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

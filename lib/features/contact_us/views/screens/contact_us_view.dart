import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textThem = Theme.of(context).textTheme;
    return Scaffold(
      // backgroundColor: AppColors.accentYellow,
      appBar: AppBar(
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: r.w * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: textThem.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.hLarge),
            Text(
              "We're here to help and answer any question you might have. We look forward to hearing from you.",
            ),
            SizedBox(height: r.hLarge),
            // ! Email Contact Us Cart
            buildContactUsCard(
              r,
              textThem,
              CupertinoIcons.mail,
              'Email',
              'support@gmaile.com',
            ),

            // ! Phone Contact Us Cart
            buildContactUsCard(
              r,
              textThem,
              CupertinoIcons.phone,
              'Phone',
              '+1 (555) 123-4567',
            ),
            SizedBox(height: r.hLarge),
            Text(
              "We'd love to hear from you! Let's get in touch",
              style: textThem.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: r.hLarge),
            // ! User Name Text Form Field
            buildCustomTextFormField(
              textThem,
              'Username',
              'Enter Your Name...',
              CupertinoIcons.person,
            ),
            SizedBox(height: r.hLarge),

            // ! User Email TEXt FORM FIELD
            buildCustomTextFormField(
              textThem,
              'Email',
              'Enter Your Email...',
              CupertinoIcons.mail,
            ),
            SizedBox(height: r.hLarge),

            // ! User PHONE NUMBER TEXt FORM FIELD
            buildCustomTextFormField(
              textThem,
              'Phone Number',
              'Enter Your Phone number...',
              CupertinoIcons.phone,
            ),
            SizedBox(height: r.hLarge),
            // ! Custom TEXTFORM FIELD FOR MESSAGE
            buildCustomMessageFormField(textThem, 'Message', ''),

            SizedBox(height: r.hLarge),

            ElevatedButton(onPressed: () {}, child: Text('Send Message')),

            SizedBox(height: r.hLarge),
          ],
        ),
      ),
    );
  }

  // ! Custom TEXTFORM FIELD FOR MESSAGE
  Widget buildCustomMessageFormField(
    TextTheme textThem,
    String label,
    String hintText,
  ) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text(label, style: textThem.bodyMedium),
          TextFormField(
            minLines: 5,
            maxLines: 10,
            // style: textThem.bodyMedium?.copyWith(color: AppColors.black),
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: hintText,

              hintStyle: textThem.bodySmall?.copyWith(color: AppColors.black),
              filled: true,
              // fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ! Custom TEXTFORM FIELD
  Widget buildCustomTextFormField(
    TextTheme textThem,
    String label,
    String hintText,
    IconData? icon,
  ) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text(label, style: textThem.bodyMedium),
          TextFormField(
            // style: textThem.bodyMedium?.copyWith(color: AppColors.black),
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: hintText,

              hintStyle: textThem.bodySmall?.copyWith(color: AppColors.black),
              filled: true,
              // fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              prefixIcon: Icon(icon),
            ),
          ),
        ],
      ),
    );
  }

  //  ! CONTACT US CARD
  Widget buildContactUsCard(
    Responsive r,
    TextTheme textThem,
    IconData? icon,
    String title,
    String subTitle,
  ) {
    return Card(
      color: AppColors.primaryGreen,
      child: Padding(
        padding: EdgeInsets.all(r.w * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: r.w * 0.15,
              height: r.w * 0.15,
              decoration: BoxDecoration(
                color: AppColors.grey500,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textThem.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subTitle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

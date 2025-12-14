// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/theme/app_typography.dart';
import 'package:sukun/features/auth/views/screens/log_in_screen.dart';
import 'package:sukun/features/auth/views/screens/otp_verify_view.dart';

class SingUpScreen extends StatelessWidget {
  const SingUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),
        backgroundColor: AppColors.white,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_sign_up_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 342,
            height: 564,
            decoration: BoxDecoration(
              color: AppColors.accentYellow,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: r.hMedium),
                  Text(
                    'CREATE AN \nACCOUNT',
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: r.titleSize,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: r.hSmall),
                  // ! User Name Text Form Field
                  SizedBox(
                    width: r.fieldWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text('Username', style: textTheme.bodyMedium),
                        TextFormField(
                          style: textTheme.bodyMedium,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Enter Your Name...',
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: AppColors.black,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.person,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: r.hMedium),

                  // ! Phone Number TextForm Field
                  SizedBox(
                    width: r.fieldWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text('Phone', style: textTheme.bodyMedium),
                        TextFormField(
                          style: textTheme.bodyMedium,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Enter Phone Number...',
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: AppColors.black,
                            ),
                            filled: true,
                            fillColor: AppColors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.phone,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: r.hSmall),
                        // ! Accept Check Box With Terms & condition
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              fillColor: MaterialStateProperty.all(
                                AppColors.white,
                              ),
                              side: BorderSide(color: AppColors.white),
                              checkColor: AppColors.black,
                              value: true,
                              onChanged: (value) {},
                            ),
                            Text(
                              'Accept Terms & conditions',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ! Sign Up Button
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtpVerifyView()),
                    ),
                    child: Container(
                      width: r.fieldWidth,
                      height: r.fieldHeight,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign up',
                              style: AppTypography.button.copyWith(
                                fontSize: r.buttonTextSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: r.hSmall),
                  // ! Divider
                  DividerOr(),
                  SizedBox(height: r.hSmall),
                  GoogleAuth(ontap: () {}),
                  SizedBox(height: r.hSmall),
                  // ! If User Already Registered got to sing in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an accoun?',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
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

// ! Divider With Or
class DividerOr extends StatelessWidget {
  const DividerOr({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 1, color: AppColors.black)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'or',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.black),
            ),
          ),
          const Expanded(child: Divider(thickness: 1, color: AppColors.black)),
        ],
      ),
    );
  }
}

// ! Google User Sign In Button
class GoogleAuth extends StatelessWidget {
  final VoidCallback? ontap;
  const GoogleAuth({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return InkWell(
      onTap: ontap,
      child: Container(
        width: r.fieldWidth,
        height: r.googleHeight,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/google_Icon.png', width: r.w * 0.08),

            SizedBox(width: r.w * 0.05),
            Text(
              'Signup  with Google',
              style: AppTypography.button.copyWith(
                fontSize: r.buttonTextSize,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

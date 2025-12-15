// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/theme/app_typography.dart';
import 'package:sukun/features/auth/views/screens/sing_up_screen.dart';
import 'package:sukun/features/bottom_navbar/views/screen/main_screen.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

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
            image: AssetImage('assets/bg_sing_in_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 342,
            height: 564,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: r.hLarge),
               
                  Text(
                    'LOGIN NOW',
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: r.titleSize,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: r.hMedium),

                  // ! Phone Number TextForm Field
                  SizedBox(
                    width: r.fieldWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text('Phone'),
                        TextFormField(
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.black,
                          ),
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Enter Phone Number...',
                            hintStyle: textTheme.bodySmall?.copyWith(
                              color: AppColors.black,
                            ),
                            filled: true,
                            fillColor: Colors.white,
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
                                Colors.white,
                              ),
                              side: BorderSide(color: Colors.white),
                              checkColor: Colors.black,
                              value: true,
                              onChanged: (value) {},
                            ),
                            Text('Accept Terms & conditions'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: r.hSmall),

                  // ! Login Button
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    ),
                    child: Container(
                      width: r.fieldWidth,
                      height: r.fieldHeight,
                      decoration: BoxDecoration(
                        color: AppColors.accentYellow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log In',
                              style: AppTypography.button.copyWith(
                                fontSize: r.buttonTextSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: r.hMedium),
                  // ! Divider
                  DividerOr(),
                  SizedBox(height: r.hMedium),
                  GoogleAuth(ontap: () {}),
                  SizedBox(height: r.hLarge),
                  // ! If User Already Registered got to sing in
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Dont have an Account? Register',
                        style: textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTypography.button.copyWith(
                            color: AppColors.white,
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

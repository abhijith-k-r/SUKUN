// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/theme/app_typography.dart';

class OtpVerifyView extends StatelessWidget {
  const OtpVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textThem = Theme.of(context).textTheme;
    // final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    final mode = Theme.of(context).brightness;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Fix overflow
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: r.w * 0.05,
                  // vertical: r.w * 0.2,
                ),
                child: Card(
                  color: mode == Brightness.dark
                      ? AppColors.black
                      : AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppBar(
                          backgroundColor: mode == Brightness.dark
                              ? AppColors.black
                              : AppColors.white,
                          title: Text(
                            'Change number',
                            style: textThem.bodyMedium,
                          ),
                        ),

                        SizedBox(height: r.hMedium),

                        Text(
                          'Enter Verification Code',
                          style: textThem.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: r.hSmall),

                        Text(
                          'We sent a 6-digit code to your phone',
                          style: textThem.bodySmall,
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: r.hMedium),

                        Padding(
                          padding: EdgeInsets.only(left: r.w * 0.05),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'One-Time Password',
                              style: textThem.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: r.hLarge),

                        // ! Custom OTP Fields
                        CustomOtpFields(
                          onOtpCompleted: (String otp) {
                            // Handle complete OTP via BLoC
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Verification Code"),
                                content: Text('Code entered is $otp'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        SizedBox(height: r.hLarge),

                        Text(
                          'check your messages for the code',
                          style: textThem.bodySmall,
                        ),

                        SizedBox(height: r.hLarge),
                        // ! Verify Code Button
                        GestureDetector(
                          onTap: () {},
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
                                    'Verify Code',
                                    style: AppTypography.button.copyWith(
                                      fontSize: r.buttonTextSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: r.hLarge),
                        Text('Resend Code in 31s', style: textThem.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ! Custom OTP Implementation (Stateless, BLoC-ready)
class CustomOtpFields extends StatefulWidget {
  final Function(String) onOtpCompleted;

  const CustomOtpFields({super.key, required this.onOtpCompleted});

  @override
  State<CustomOtpFields> createState() => _CustomOtpFieldsState();
}

class _CustomOtpFieldsState extends State<CustomOtpFields> {
  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (_) => TextEditingController());
    focusNodes = List.generate(6, (_) => FocusNode());

    // !  Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textThem = Theme.of(context).textTheme;

    final mode = Theme.of(context).brightness;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: TextFormField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,

              decoration: InputDecoration(
                counterText: '',
                // Underline only - NO outline borders
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: mode == Brightness.dark
                        ? Colors.white70
                        : Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primaryGreen,
                    width: 2.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: mode == Brightness.dark
                        ? Colors.white24
                        : Colors.grey.shade300,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.shade400),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: mode == Brightness.dark
                        ? Colors.white12
                        : Colors.grey.shade200,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                isDense: true,
              ),
              onChanged: (value) {
                if (value.length == 1 && index < 5) {
                  focusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                  focusNodes[index - 1].requestFocus();
                }

                // Check if all fields are filled
                if (controllers.every((c) => c.text.isNotEmpty)) {
                  String otp = controllers.map((c) => c.text).join();
                  widget.onOtpCompleted(otp);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

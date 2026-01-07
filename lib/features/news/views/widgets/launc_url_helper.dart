import 'package:flutter/material.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/widgets/custom_snackbar_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchNewsUrl(BuildContext context, String? url) async {
  if (url == null || url.isEmpty) {
    customSnackBar(context, 'No URL available', Icons.cancel, AppColors.error);

    return;
  }

  final uri = Uri.parse(url);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('Launch error: $e');
    if (context.mounted) {
      customSnackBar(
        context,
        'Cannot open link',
        Icons.cancel,
        AppColors.error,
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppHelper {
  AppHelper._();

  static Future<void> makePhoneCall(
    String phoneNumber,
    BuildContext context,
  ) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s-]'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanNumber);
    try {
      if (cleanNumber != "") {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch phone app'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  static Future<void> sendEmail(String email, BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Healthcare App - Contact'},
    );
    try {
      if (email != "") {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch email app'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

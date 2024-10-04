import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:razor_expense_tracker_new/src/settings/widgets/privacy_policy_dialog.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        8,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Privacy Policy',
          style: Theme.of(context).textTheme.bodyLarge,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              //Open Dialog
              showDialog<dynamic>(
                context: context,
                builder: (context) {
                  return PolicyDialog(mdFileName: 'privacy_policy.md');
                },
              );
            },
        ),
      ),
    );
  }
}

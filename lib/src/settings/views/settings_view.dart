import 'package:flutter/material.dart';
import 'package:razor_expense_tracker_new/src/settings/widgets/privacy_policy.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
            PrivacyPolicy(),
            ],
          ),
        ),
      ),
    );
  }
}

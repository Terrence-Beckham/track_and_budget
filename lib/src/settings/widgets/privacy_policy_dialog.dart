import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({required this.mdFileName, this.radius = 8, super.key})
      : assert(
          mdFileName.contains('.md'),
          'The file must contain the .md extension',
        );
  final double radius;
  final String mdFileName;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              // ignore: inference_failure_on_instance_creation
              future: Future.delayed(const Duration(milliseconds: 150))
                  .then((value) => rootBundle.loadString('assets/$mdFileName')),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Markdown(data: snapshot.data.toString());
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

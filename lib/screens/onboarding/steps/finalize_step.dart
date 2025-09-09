import 'package:flutter/material.dart';

class FinalizeStep extends StatelessWidget {
  final VoidCallback onFinish;
  const FinalizeStep({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Colors.green,
          ),
          const SizedBox(height: 32),
          Text(
            'You\'re All Set!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'You have successfully entered all the required information. Press the button below to generate your smart portfolio.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: onFinish,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Finish & View Portfolio', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

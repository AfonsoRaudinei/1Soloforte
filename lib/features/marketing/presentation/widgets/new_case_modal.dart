import 'package:flutter/material.dart';

class NewCaseModal extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const NewCaseModal({super.key, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text('New Case Modal Placeholder ($latitude, $longitude)'),
    );
  }
}

class NewCaseSuccessModal extends StatelessWidget {
  final double latitude;
  final double longitude;

  const NewCaseSuccessModal({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'New Case Success Placeholder (Lat: $latitude, Lng: $longitude)',
      ),
    );
  }
}

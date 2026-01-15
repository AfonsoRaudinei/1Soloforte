import 'package:flutter/material.dart';

class OnlineStatusBadge extends StatelessWidget {
  final bool isOnline;

  const OnlineStatusBadge({super.key, this.isOnline = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isOnline ? Icons.wifi : Icons.wifi_off,
        color: isOnline ? Colors.green : Colors.grey,
        size: 20,
      ),
    );
  }
}

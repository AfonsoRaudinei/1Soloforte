// import 'dart:io';
// import 'package:dio/io.dart'; // Breaks web
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

/// SSL Certificate Pinning Service
/// Protects against Man-in-the-Middle (MITM) attacks
class SslPinningService {
  // Certificate SHA-256 hashes (public key pinning)
  // TODO: Replace with your actual certificate hashes
  static const List<String> certificateHashes = [
    // Primary certificate
    'YOUR_PRIMARY_CERT_SHA256_HASH_HERE',
    // Backup certificate (for rotation)
    'YOUR_BACKUP_CERT_SHA256_HASH_HERE',
  ];

  /// Configure SSL pinning for Dio client
  static void configurePinning(Dio dio) {
    if (kIsWeb) return; // Web handles SSL automatically
    // Native implementation commented out to avoid web build errors for now
    // In a real project, use conditional imports (.stub.dart vs .io.dart)

    /*
    if (dio.httpClientAdapter is! IOHttpClientAdapter) {
      // throw Exception('SSL pinning only works with IOHttpClientAdapter');
      return; 
    }

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
          client.badCertificateCallback = (cert, host, port) {
            // Extract public key from certificate
            final certDer = cert.der;
            final certHash = sha256.convert(certDer).toString();

            // Check if certificate hash matches any of our pinned hashes
            final isValid = certificateHashes.contains(certHash);

            if (!isValid) {
              print('⚠️ SSL Pinning: Certificate validation failed!');
              print('   Host: $host:$port');
              print('   Received hash: $certHash');
              print('   Expected one of: ${certificateHashes.join(', ')}');
            } else {
              print('✅ SSL Pinning: Certificate validated successfully');
            }

            return isValid;
          };

          return client;
        };
    */
  }

  /// Get certificate hash from URL (for setup)
  static Future<String> getCertificateHash(String url) async {
    if (kIsWeb) return "Not supported on Web";

    // final uri = Uri.parse(url);
    // final socket = await SecureSocket.connect( ...

    return "Not supported";
  }
}

/// Exception thrown when SSL pinning fails
class SslPinningException implements Exception {
  final String message;
  final String? receivedHash;
  final List<String> expectedHashes;

  SslPinningException(
    this.message, {
    this.receivedHash,
    required this.expectedHashes,
  });

  @override
  String toString() {
    return 'SslPinningException: $message\n'
        'Received: $receivedHash\n'
        'Expected: ${expectedHashes.join(', ')}';
  }
}

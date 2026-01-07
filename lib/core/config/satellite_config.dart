class SatelliteConfig {
  // Sentinel Hub Credentials
  static const String sentinelInstanceId =
      '9184f2f5-0b21-4343-93ec-0d18a851ae6a';
  // Note: The 'secret' provided might be for a different auth flow,
  // but instanceId is sufficient for OGC WMS/WCS if configured for public/referenced access.
  static const String sentinelSecret = 'DciQhd8EPR97GNWJoQiIX4nDUjXjLqCl';

  // Planet Credentials (Backup/Alternative)
  static const String planetApiKey1 = 'PLAKb8483b02c49547d5a4dc349cb2c3d40f';
  static const String planetApiKey2 = 'Z2JCYA8NE59M9B5VAQ13YS8U';
}

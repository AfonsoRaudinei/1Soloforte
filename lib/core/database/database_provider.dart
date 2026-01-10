import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soloforte_app/core/interfaces/service_interfaces.dart';
import 'database_service.dart';
import 'database_helper.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
IDatabaseService databaseService(DatabaseServiceRef ref) {
  return DatabaseServiceImpl(DatabaseHelper.instance);
}

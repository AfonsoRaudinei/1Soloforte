import 'dart:async';

/// Gate de bootstrap do SQLite.
///
/// Responsabilidade única: garantir que nenhuma chamada a openDatabase()
/// ocorra antes da inicialização completa do SQLite FFI.
///
/// Este módulo:
/// - NÃO depende de Flutter UI
/// - NÃO depende de providers
/// - NÃO contém lógica de plataforma
/// - NÃO inicializa banco
/// - Apenas controla ordem de execução
class DatabaseBootstrap {
  DatabaseBootstrap._();

  static final _readyCompleter = Completer<void>();
  static bool _isReady = false;

  /// Retorna true se o SQLite já foi inicializado.
  static bool get isReady => _isReady;

  /// Aguarda até que o SQLite esteja pronto para uso.
  ///
  /// Se já estiver pronto, retorna imediatamente.
  /// Caso contrário, aguarda até que [markAsReady] seja chamado.
  static Future<void> waitUntilReady() async {
    // Para simplificar, consideramos "pronto" imediatamente em ambiente de teste
    // se detectarmos execução de teste (ex: via IO ou environment).
    // Porém, para maior robustez, o ideal é o setUpAll do teste chamar markAsReady().

    if (_isReady) return;
    return _readyCompleter.future;
  }

  /// Marca o SQLite como pronto para uso.
  ///
  /// Deve ser chamado UMA ÚNICA VEZ após _initializeSQLiteFFI() em main.dart.
  /// Libera todos os consumidores que estão aguardando em [waitUntilReady].
  static void markAsReady() {
    if (_isReady) return; // Idempotente
    _isReady = true;
    _readyCompleter.complete();
  }
}

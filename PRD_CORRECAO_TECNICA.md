# 📋 PRD - PLANO DE CORREÇÃO TÉCNICA SOLOFORTE

**Documento:** Product Requirements Document - Correção Técnica  
**Versão:** 1.0  
**Data:** 07/01/2026  
**Autor:** Auditoria Técnica Automatizada  
**Status:** 🔴 AÇÃO IMEDIATA NECESSÁRIA

---

## 📌 SUMÁRIO EXECUTIVO

### Contexto
O aplicativo SoloForte passou por uma auditoria técnica completa que identificou **271 issues**, problemas de segurança críticos, e uma cobertura de testes próxima de zero. Este PRD define o roadmap de correções necessárias para atingir qualidade de produção.

### Objetivo
Corrigir dívida técnica, vulnerabilidades de segurança, e preparar a base de código para escala, mantendo o app funcional durante o processo.

### Métricas de Sucesso
| Métrica | Atual | Meta |
|---------|-------|------|
| Warnings no `flutter analyze` | 271 | 0 |
| Cobertura de testes | ~0% | 30% |
| Arquivos > 500 linhas | 15 | 0 |
| `print()` em código | 44 | 0 |
| Vulnerabilidades de segurança | 3 | 0 |

---

## 🚨 FASE 1: CRÍTICO (Sprint 1-2 / Prazo: 2 semanas)

### 1.1 [P0] Remover Credenciais Hardcoded

**Prioridade:** 🔴 CRÍTICA - BLOCKER PARA PRODUÇÃO

**Problema:**  
Credenciais de teste expostas no código-fonte em `auth_service.dart`:
```dart
final Map<String, Map<String, String>> _mockUsers = {
  'teste@soloforte.com': {
    'password': 'senha123456',  // ⚠️ SENHA EM PLAINTEXT
    ...
  },
};
```

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| SEC-001 | Remover todas as senhas hardcoded do código | Zero ocorrências de `password:` com valores literais |
| SEC-002 | Criar sistema de ambiente para credenciais mock | Arquivo `.env` ignorado pelo git, lido via `flutter_dotenv` |
| SEC-003 | Modo demo controlado remotamente | Feature flag via Firebase Remote Config |
| SEC-004 | Separar AuthService de MockAuthService | Classes distintas, mock só injetado em dev |

**Arquivos Afetados:**
- `lib/features/auth/data/auth_service.dart`
- `lib/features/auth/data/mock_auth_repository.dart`

**Estimativa:** 3 dias

---

### 1.2 [P0] Corrigir BuildContext Após Async Gaps

**Prioridade:** 🔴 CRÍTICA - CAUSA CRASHES

**Problema:**  
Uso de `BuildContext` após operações assíncronas pode causar crashes se o widget foi desmontado.

**Arquivos com o problema:**
1. `lib/features/analysis/presentation/analysis_wizard_screen.dart:128`
2. `lib/features/clients/presentation/screens/client_form_screen.dart:84`
3. `lib/features/privacy/presentation/privacy_policy_screen.dart:124`
4. `lib/features/scanner/presentation/scanner_screen.dart:203`

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| BUG-001 | Verificar `mounted` antes de usar context após await | Padrão: `if (!mounted) return;` após cada `await` |
| BUG-002 | Usar `BuildContext` com WidgetRef quando possível | Em ConsumerWidget, preferir `ref` para navegação |

**Padrão de Correção:**
```dart
// ❌ ERRADO
Future<void> _handleSubmit() async {
  await someAsyncOperation();
  Navigator.of(context).pop(); // Crash se widget desmontado
}

// ✅ CORRETO
Future<void> _handleSubmit() async {
  await someAsyncOperation();
  if (!mounted) return;
  Navigator.of(context).pop();
}
```

**Estimativa:** 1 dia

---

### 1.3 [P0] Substituir print() por Logger

**Prioridade:** 🔴 ALTA - SEGURANÇA + PERFORMANCE

**Problema:**  
44 chamadas `print()` em código de produção:
- Vazamento de informações sensíveis
- Impacto em performance
- Não rastreável em produção

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| LOG-001 | Criar `LoggerService` central | Singleton com níveis: debug, info, warning, error |
| LOG-002 | Integrar com Sentry para produção | Erros enviados automaticamente |
| LOG-003 | Substituir todos os `print()` | `flutter analyze` não reportar `avoid_print` |
| LOG-004 | Desabilitar logs verbose em release | Apenas error/warning em produção |

**Implementação:**
```dart
// lib/core/services/logger_service.dart
class LoggerService {
  static void debug(String message, [Object? error, StackTrace? stack]) {
    if (kDebugMode) debugPrint('[DEBUG] $message');
  }
  
  static void error(String message, Object error, [StackTrace? stack]) {
    if (kDebugMode) debugPrint('[ERROR] $message: $error');
    Sentry.captureException(error, stackTrace: stack);
  }
}
```

**Estimativa:** 2 dias

---

### 1.4 [P0] Atualizar APIs Depreciadas

**Prioridade:** 🟡 MÉDIA - COMPATIBILIDADE FUTURA

**Problema:**  
80+ ocorrências de `withOpacity` depreciado e outras APIs antigas.

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| DEP-001 | Substituir `withOpacity` por `withValues` | Zero warnings de `deprecated_member_use` para withOpacity |
| DEP-002 | Atualizar `Radio.groupValue/onChanged` para `RadioGroup` | Zero warnings relacionados |
| DEP-003 | Atualizar `Share.shareXFiles` para `SharePlus` | Zero warnings relacionados |
| DEP-004 | Regenerar arquivos Freezed/JSON | `dart run build_runner build --delete-conflicting-outputs` |

**Padrão de Substituição:**
```dart
// ❌ DEPRECIADO
Colors.black.withOpacity(0.5)

// ✅ CORRETO
Colors.black.withValues(alpha: 0.5)
```

**Estimativa:** 1 dia

---

### 1.5 [P1] Corrigir Código Morto e Variáveis Não Usadas

**Prioridade:** 🟡 MÉDIA - QUALIDADE DE CÓDIGO

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| CLEAN-001 | Remover campos não usados | Zero `unused_field` warnings |
| CLEAN-002 | Remover variáveis locais não usadas | Zero `unused_local_variable` warnings |
| CLEAN-003 | Remover código morto | Zero `dead_code` warnings |
| CLEAN-004 | Remover underscores desnecessários | Zero `unnecessary_underscores` warnings |

**Arquivos Prioritários:**
- `lib/features/clients/presentation/screens/client_form_screen.dart` (`_selectedAvatar`)
- `lib/features/support/presentation/chat_screen.dart` (`_isAgentTyping`)
- `lib/features/support/presentation/support_home_screen.dart` (dead code linhas 275, 279)
- `lib/features/reports/presentation/wizard/personalization_step.dart` (`sections`)
- `lib/features/occurrences/presentation/widgets/occurrence_list_view.dart` (dead code)

**Estimativa:** 1 dia

---

## ⚠️ FASE 2: IMPORTANTE (Sprint 3-4 / Prazo: 4 semanas)

### 2.1 [P1] Refatorar God Classes

**Prioridade:** 🟡 ALTA - MANUTENIBILIDADE

**Problema:**  
Arquivos com excesso de responsabilidades:

| Arquivo | Linhas | Complexidade |
|---------|--------|--------------|
| `report_service.dart` | 1.471 | God Class |
| `image_editor_screen.dart` | 911 | Tela massiva |
| `occurrence_report_modal.dart` | 838 | Modal gigante |
| `settings_screen.dart` | 829 | Tela massiva |
| `new_occurrence_screen.dart` | 705 | Tela grande |

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| REFAC-001 | Dividir `report_service.dart` em 3+ services | Cada service < 400 linhas |
| REFAC-002 | Extrair widgets de `settings_screen.dart` | Tela principal < 300 linhas |
| REFAC-003 | Componentizar `occurrence_report_modal.dart` | Modal < 400 linhas |
| REFAC-004 | Extrair widgets de `new_occurrence_screen.dart` | Tela < 400 linhas |

**Estrutura Sugerida para ReportService:**
```
lib/features/reports/application/
├── report_service.dart          # Orquestrador (< 200 linhas)
├── pdf_generator_service.dart   # Geração de PDFs (< 400 linhas)
├── report_data_service.dart     # Coleta de dados (< 300 linhas)
└── report_share_service.dart    # Compartilhamento (< 200 linhas)
```

**Estimativa:** 8 dias

---

### 2.2 [P1] Implementar Injeção de Dependência

**Prioridade:** 🟡 ALTA - TESTABILIDADE

**Problema:**  
Singletons globais impedem testes:
```dart
// ❌ Atual - Impossível mockar
final DatabaseHelper _dbHelper = DatabaseHelper.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
```

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| DI-001 | Criar interfaces para serviços externos | `IAuthService`, `IDatabaseService` |
| DI-002 | Injetar dependências via Provider | Zero uso de `.instance` singleton |
| DI-003 | Repositories recebem dependências via construtor | Construtor explícito, não instanciação interna |

**Padrão de Implementação:**
```dart
// lib/core/database/database_service.dart
abstract class IDatabaseService {
  Future<Database> get database;
}

class DatabaseService implements IDatabaseService {
  @override
  Future<Database> get database async { ... }
}

// Provider
final databaseServiceProvider = Provider<IDatabaseService>((ref) {
  return DatabaseService();
});

// Repository usando DI
class AreasRepository {
  final IDatabaseService _dbService;
  
  AreasRepository(this._dbService); // Injeção via construtor
}
```

**Estimativa:** 5 dias

---

### 2.3 [P1] Padronizar Gerenciamento de Estado

**Prioridade:** 🟡 ALTA - CONSISTÊNCIA

**Problema:**  
259 usos de `setState` misturados com Riverpod.

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| STATE-001 | Documentar quando usar setState vs Riverpod | ADR (Architecture Decision Record) criado |
| STATE-002 | Converter telas principais para Riverpod puro | `LoginScreen`, `HomeScreen`, `SettingsScreen` |
| STATE-003 | setState apenas para estado efêmero local | Animações, focus, hover - máximo 50 usos |

**Definição:**
- **Riverpod**: Estado que atravessa widgets, estado de feature, cache
- **setState**: Animações locais, estado que morre com o widget

**Estimativa:** 6 dias

---

### 2.4 [P1] Criar Estrutura de Testes Básica

**Prioridade:** 🔴 ALTA - CONFIABILIDADE

**Problema:**  
Cobertura atual ~0%. Testes existentes falham por setup incorreto.

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| TEST-001 | Corrigir setup de database para testes | Inicializar `databaseFactoryFfi` no setUp |
| TEST-002 | Criar testes unitários para AuthService | Mínimo 5 testes cobrindo login, logout, register |
| TEST-003 | Criar testes unitários para ApiClient | Mínimo 5 testes cobrindo interceptors |
| TEST-004 | Criar testes para AreasRepository | Mínimo 3 testes cobrindo CRUD |
| TEST-005 | Atingir 15% cobertura | `flutter test --coverage` reporta ≥15% |

**Setup de Test:**
```dart
// test/test_setup.dart
void setupTestEnvironment() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

// test/unit/auth_service_test.dart
void main() {
  setUpAll(() => setupTestEnvironment());
  
  group('AuthService', () {
    test('should login with valid credentials', () async {
      // ...
    });
  });
}
```

**Estimativa:** 8 dias

---

### 2.5 [P2] Tratamento de Erro Centralizado

**Prioridade:** 🟡 MÉDIA - ROBUSTEZ

**Problema:**  
Cada service trata erros de forma diferente. Fallback silencioso mascara bugs.

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| ERR-001 | Criar hierarquia de exceções | `AppException` com subtipos |
| ERR-002 | Handler global em main.dart | `FlutterError.onError` e `PlatformDispatcher.onError` |
| ERR-003 | Remover fallback silencioso de Auth | Erros propagados corretamente |
| ERR-004 | UI de erro consistente | Widget reutilizável para estados de erro |

**Hierarquia de Exceções:**
```dart
// lib/core/error/exceptions.dart
sealed class AppException implements Exception {
  final String message;
  final Object? originalError;
  
  AppException(this.message, [this.originalError]);
}

class NetworkException extends AppException {
  NetworkException([String? message]) : super(message ?? 'Erro de conexão');
}

class AuthException extends AppException {
  AuthException([String? message]) : super(message ?? 'Erro de autenticação');
}

class ValidationException extends AppException {
  final Map<String, String> fieldErrors;
  ValidationException(this.fieldErrors) : super('Dados inválidos');
}
```

**Estimativa:** 4 dias

---

## 🔮 FASE 3: EVOLUÇÃO (Sprint 5-8 / Prazo: 8 semanas)

### 3.1 [P2] Completar Clean Architecture

**Prioridade:** 🟡 MÉDIA - ESCALABILIDADE

**Problema:**  
10+ features só têm `presentation/`, sem `data/` ou `domain/`.

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| ARCH-001 | Adicionar domain/data para settings | Provider, models, repository |
| ARCH-002 | Adicionar domain/data para dashboard | Separar lógica de HomeScreen |
| ARCH-003 | Padronizar localização de Providers | Sempre em `presentation/providers/` |
| ARCH-004 | Criar UseCases para operações de negócio | Mínimo 1 UseCase por feature core |

**Estimativa:** 10 dias

---

### 3.2 [P2] Dark Mode e Responsividade

**Prioridade:** 🟢 MÉDIA - UX

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| UI-001 | Criar `darkTheme` em AppTheme | Tema escuro completo |
| UI-002 | Implementar toggle de tema | Persistido em SharedPreferences |
| UI-003 | Criar breakpoints responsivos | Mobile, Tablet, Desktop |
| UI-004 | Adaptar HomeScreen para tablet | Layout side-by-side |

**Estimativa:** 6 dias

---

### 3.3 [P2] Aumentar Cobertura de Testes

**Prioridade:** 🟡 MÉDIA - CONFIABILIDADE

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| TEST-010 | Widget tests para telas principais | LoginScreen, HomeScreen, SettingsScreen |
| TEST-011 | Testes de integração para fluxo de auth | Login → Dashboard → Logout |
| TEST-012 | Atingir 30% cobertura | `flutter test --coverage` reporta ≥30% |

**Estimativa:** 10 dias

---

### 3.4 [P3] Acessibilidade

**Prioridade:** 🟢 BAIXA - COMPLIANCE

**Requisitos:**

| ID | Requisito | Critério de Aceite |
|----|-----------|-------------------|
| A11Y-001 | Adicionar Semantics em botões e imagens | Screen readers funcionam |
| A11Y-002 | Testar com TalkBack/VoiceOver | Navegação por voz funcional |
| A11Y-003 | Contraste de cores WCAG AA | Verificar com ferramenta de acessibilidade |

**Estimativa:** 5 dias

---

## 📊 CRONOGRAMA CONSOLIDADO

```
                    JANEIRO 2026                      FEVEREIRO 2026           MARÇO 2026
            S1      S2      S3      S4      S1      S2      S3      S4      S1      S2
            ┌───────────────┬───────────────────────────────┬───────────────────────────┐
FASE 1      │███████████████│                               │                           │
(Crítico)   │  2 semanas    │                               │                           │
            ├───────────────┼───────────────────────────────┤                           │
FASE 2      │               │███████████████████████████████│                           │
(Importante)│               │         4 semanas             │                           │
            ├───────────────┼───────────────────────────────┼───────────────────────────┤
FASE 3      │               │                               │███████████████████████████│
(Evolução)  │               │                               │        8 semanas          │
            └───────────────┴───────────────────────────────┴───────────────────────────┘
```

---

## 📋 CHECKLIST DE ENTREGA

### Fase 1 - Go/No-Go para Produção
- [ ] SEC-001 a SEC-004: Credenciais removidas
- [ ] BUG-001 a BUG-002: BuildContext corrigido
- [ ] LOG-001 a LOG-004: Logger implementado
- [ ] DEP-001 a DEP-004: APIs atualizadas
- [ ] CLEAN-001 a CLEAN-004: Código limpo
- [ ] `flutter analyze` zero warnings críticos

### Fase 2 - Pronto para Escalar
- [ ] REFAC-001 a REFAC-004: God classes refatoradas
- [ ] DI-001 a DI-003: Injeção de dependência
- [ ] STATE-001 a STATE-003: Estado padronizado
- [ ] TEST-001 a TEST-005: 15% cobertura
- [ ] ERR-001 a ERR-004: Tratamento de erros

### Fase 3 - Maturidade
- [ ] ARCH-001 a ARCH-004: Clean Architecture
- [ ] UI-001 a UI-004: Dark mode + Responsivo
- [ ] TEST-010 a TEST-012: 30% cobertura
- [ ] A11Y-001 a A11Y-003: Acessibilidade

---

## 🔧 COMANDOS ÚTEIS

```bash
# Verificar status atual
flutter analyze

# Regenerar arquivos gerados
dart run build_runner build --delete-conflicting-outputs

# Rodar testes com cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Buscar prints no código
grep -r "print(" lib --include="*.dart" | wc -l

# Buscar arquivos grandes
find lib -name "*.dart" -exec wc -l {} + | sort -rn | head -20

# Buscar TODOs pendentes
grep -r "TODO\|FIXME" lib --include="*.dart"
```

---

## 📞 RESPONSÁVEIS

| Área | Responsável | Backup |
|------|-------------|--------|
| Segurança (Fase 1) | Lead Dev | CTO |
| Testes (Fase 2) | QA Lead | Dev Senior |
| Arquitetura (Fase 3) | Arquiteto | Lead Dev |

---

## 📝 NOTAS DE REVISÃO

| Versão | Data | Autor | Mudanças |
|--------|------|-------|----------|
| 1.0 | 07/01/2026 | Auditoria | Versão inicial |

---

**APROVAÇÃO:**

| Papel | Nome | Data | Assinatura |
|-------|------|------|------------|
| Product Owner | ___________ | ___/___/2026 | _________ |
| Tech Lead | ___________ | ___/___/2026 | _________ |
| QA Lead | ___________ | ___/___/2026 | _________ |

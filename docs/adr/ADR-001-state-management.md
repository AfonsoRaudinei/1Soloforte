# ADR-001: State Management Standards

## Status
**Accepted** | Date: 2026-01-07

## Context

O projeto SoloForte atualmente utiliza uma mistura de `setState` (259 usos) com `Riverpod` para gerenciamento de estado. Isso causa inconsistência no código e dificulta a manutenção.

Precisamos definir claramente quando usar cada abordagem.

## Decision

### Usar Riverpod para:

1. **Estado de Feature/Domínio**
   - Estado de autenticação
   - Lista de áreas, clientes, ocorrências
   - Cache de dados
   - Estado compartilhado entre múltiplos widgets

2. **Estado que precisa persistir**
   - Preferências do usuário
   - Dados carregados do backend/banco
   - Resultados de operações assíncronas

3. **Estado que pode ser testado**
   - Qualquer lógica de negócio
   - Transformações de dados
   - Validações complexas

### Usar setState para:

1. **Estado puramente visual/efêmero**
   - Animações e transições
   - Estado de hover/focus
   - Controladores de TextField (apenas se local)
   - Expansão/colapso de widgets
   - Tabs temporários

2. **Estado que morre com o widget**
   - Loading indicators locais
   - Estados de UI que não afetam outros widgets
   - Toggles visuais temporários

## Padrões de Implementação

### Padrão Riverpod para Features

```dart
// lib/features/example/application/example_provider.dart

@riverpod
class ExampleNotifier extends _$ExampleNotifier {
  @override
  AsyncValue<ExampleState> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final data = await ref.read(exampleRepositoryProvider).getData();
      state = AsyncValue.data(ExampleState(items: data));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
```

### Padrão setState para UI Efêmera

```dart
class _MyWidgetState extends State<MyWidget> {
  // ✅ OK: Estado puramente visual
  bool _isExpanded = false;
  bool _isHovering = false;
  
  // ❌ EVITAR: Estado de domínio
  // List<Item> _items = []; // Use Riverpod!
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        height: _isExpanded ? 200 : 100,
        // ...
      ),
    );
  }
}
```

### Checklist para Decidir

| Pergunta | setState | Riverpod |
|----------|----------|----------|
| O estado é compartilhado entre widgets? | ❌ | ✅ |
| O estado precisa sobreviver à navegação? | ❌ | ✅ |
| O estado vem de uma fonte externa (API, DB)? | ❌ | ✅ |
| O estado precisa ser testado isoladamente? | ❌ | ✅ |
| É apenas animação/transição visual? | ✅ | ❌ |
| O estado morre quando o widget é destruído? | ✅ | ❌ |

## Consequences

### Positivos
- Código mais consistente e previsível
- Mais fácil de testar (estado em Riverpod é isolável)
- Performance melhor (Riverpod só rebuilda quando necessário)
- Separação clara entre UI e lógica de negócio

### Negativos
- Curva de aprendizado para quem não conhece Riverpod
- Mais código boilerplate em alguns casos
- Transição gradual (código existente precisa ser migrado)

## Migration Plan

1. **Fase 1**: Documentar decisão (este ADR)
2. **Fase 2**: Converter telas críticas (Login, Home, Settings)
3. **Fase 3**: Novos features seguem padrão obrigatoriamente
4. **Fase 4**: Migração gradual do código legado

## References

- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter State Management](https://docs.flutter.dev/data-and-backend/state-mgmt)

# Criando uma Nova Tela no SoloForte

## 🚦 ANTES DE COMEÇAR — Perguntas Obrigatórias

### 1. A tela fica dentro do ShellRoute (`/map`)?

**✔️ SIM** → ❌ **NÃO use `Scaffold` nem `AppBar`**  
**✔️ NÃO** → ✅ **`Scaffold` + `AppBar` são obrigatórios**

Para confirmar, veja se sua rota será adicionada dentro do bloco `ShellRoute` em `lib/core/router.dart`.

---

### 2. É um modal/dialog?

**✔️ SIM** → Pode usar `AppBar`, mas deve conter em **cada linha**:
```dart
return Scaffold( // ci: allow-appbar
  appBar: AppBar( // ci: allow-appbar
    title: Text('Título'),
  ),
  body: ...
);
```

**✔️ NÃO** → Siga a regra da pergunta 1.

---

## 📝 Templates de Código

### Template A: Tela DENTRO do ShellRoute

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MinhaTelaScreen extends ConsumerWidget {
  const MinhaTelaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Spacing opcional para compensar ausência de AppBar
            SizedBox(height: topPadding > 0 ? 8 : 16),
            
            // HEADER INLINE (se necessário)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Título da Tela',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            
            // SEU CONTEÚDO AQUI
            Expanded(
              child: ListView(
                children: [
                  // ...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Template B: Tela FORA do ShellRoute

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MinhaTelaScreen extends ConsumerWidget {
  const MinhaTelaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Título da Tela'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // SEU CONTEÚDO AQUI
          ],
        ),
      ),
    );
  }
}
```

---

### Template C: Modal com AppBar

```dart
import 'package:flutter/material.dart';

class MeuModal extends StatelessWidget {
  const MeuModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // ci: allow-appbar
      backgroundColor: Colors.white,
      appBar: AppBar( // ci: allow-appbar
        title: const Text('Título do Modal'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // CONTEÚDO DO MODAL
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## ✅ Checklist Antes do PR

Antes de abrir o Pull Request, **OBRIGATORIAMENTE**:

- [ ] Verifiquei se a rota está dentro ou fora do `ShellRoute`
- [ ] Rodei `dart scripts/audit_shell_route.dart` localmente
- [ ] O CI passou sem erros
- [ ] Não adicionei `AppBar` em telas do mapa (exceto modais marcados)
- [ ] Testei visualmente a navegação no browser/emulador

---

## 🚨 Lembrete Final

**O CI é a autoridade final.**  
Se ele falhar, o código não entra. Sem exceções.

Leia a [Regra Canônica](regra_shellroute.md) para mais detalhes.

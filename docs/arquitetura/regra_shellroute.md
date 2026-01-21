# Regra de Navegação do Mapa (ShellRoute)

## 🎯 Regra Oficial

**Toda tela renderizada dentro do `ShellRoute` (`/map`) NÃO PODE conter `Scaffold` nem `AppBar`.**

O `DashboardLayout` é o único responsável por navegação persistente.

### ⚠️ Exceção Única

Modais/overlays podem usar `AppBar` **somente** se marcados explicitamente com:

```dart
// ci: allow-appbar
```

---

## 🧠 Filosofia de Design

> No SoloForte, o mapa é o sistema operacional.  
> O resto são aplicativos rodando em cima dele.

O mapa ocupa a tela inteira. Qualquer `AppBar` estrutural quebra essa premissa e causa:
- ❌ Duplicação visual de navegação
- ❌ Perda de espaço vertical
- ❌ Confusão de hierarquia de UI
- ❌ Bugs de layout ao navegar

---

## 📍 Como Identificar se Sua Rota Está no ShellRoute

Abra `lib/core/router.dart` e procure:

```dart
ShellRoute(
  builder: (context, state, child) {
    return DashboardLayout(child: child);
  },
  routes: [
    // SE SUA ROTA ESTÁ AQUI → PROIBIDO AppBar/Scaffold
    GoRoute(path: '/map', ...),
    GoRoute(path: '/map/occurrences', ...),
    GoRoute(path: '/map/clients', ...),
    // ...
  ],
),
```

Se a rota usa `parentNavigatorKey: _rootNavigatorKey`, ela está **FORA** do Shell → `AppBar` é obrigatório.

---

## ✅ Exemplos Corretos

### Tela DENTRO do ShellRoute
```dart
class ClientListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context) {
    return Container( // ❌ NÃO Scaffold
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // SEU CONTEÚDO AQUI
          ],
        ),
      ),
    );
  }
}
```

### Modal com AppBar (Legítimo)
```dart
class PhotoGalleryModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // ci: allow-appbar
      appBar: AppBar( // ci: allow-appbar
        title: Text('Galeria'),
      ),
      body: ...
    );
  }
}
```

### Tela FORA do ShellRoute
```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // ✅ OBRIGATÓRIO aqui
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ...
    );
  }
}
```

---

## 🚨 Sem "Depende". Sem "Acho que". Sem Exceção Criativa.

Esta regra não tem zona cinza. O CI (`dart scripts/audit_shell_route.dart`) é a autoridade final.

**CI falhou → PR não entra.**

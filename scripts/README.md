
# 🛡️ Scripts de Auditoria CI/CD - SoloForte

Este diretório contém scripts de verificação automática para garantir a integridade arquitetural do projeto.

## 1. Auditoria de ShellRoute (`audit_shell_route.dart`)

### 🎯 Objetivo
Garantir que nenhuma tela renderizada dentro do `ShellRoute` (`/map` e sub-rotas) possua seus próprios `Scaffold` ou `AppBar`. A presença desses widgets quebra a persistência do layout principal (`DashboardLayout`) e causa bugs de navegação/UX.

### 🚫 O que é proibido
Se uma tela for listada como filha do `ShellRoute` no `router.dart`, ela **NÃO PODE** conter:
- `Scaffold(`
- `AppBar(`
- `appBar:`

### ✅ Exceções Permitidas (Whitelist)
Se um `Scaffold` ou `AppBar` estiver dentro de um `showDialog`, `showModalBottomSheet`, ou qualquer widget que seja inequivocamente um overlay/modal, você deve adicionar o seguinte comentário **na mesma linha** para silenciar o erro:

```dart
return Scaffold( // ci: allow-appbar
  appBar: AppBar( // ci: allow-appbar
    ...
  ),
  ...
)
```

### 🚀 Como Rodar

#### Localmente:
Na raiz do projeto:
```bash
dart scripts/audit_shell_route.dart
```

**Resultado esperado (sucesso):**
```
✅ SUCESSO: Todas as telas do ShellRoute estão em conformidade.
```

**Resultado esperado (falha):**
```
🔴 FALHA DE CI: Foram encontradas X violações da Regra do ShellRoute.
---------------------------------------------------
   ❌ client_list_screen.dart:37 (Scaffold em ClientListScreen)
      Linhagem: "return Scaffold("
---------------------------------------------------
```

#### No CI (GitHub Actions):
O workflow `.github/workflows/audit_architecture.yml` executa automaticamente este script em cada PR.

Para outros sistemas de CI:

**GitLab CI:**
```yaml
audit_architecture:
  stage: test
  script:
    - dart scripts/audit_shell_route.dart
```

**CircleCI:**
```yaml
- run:
    name: Audit Architecture
    command: dart scripts/audit_shell_route.dart
```

### 🔴 Exemplo de Falha
```text
❌ home_screen.dart:2530 (AppBar detectado em HomeScreen)
   Line: "appBar: AppBar("
```

**Como corrigir:**
1. Se for uma tela do ShellRoute: remova o `Scaffold`/`AppBar`
2. Se for um modal legítimo: adicione `// ci: allow-appbar` na linha

### 📚 Documentação Completa

Para entender a regra arquitetural por trás deste script, leia:

📖 **[Regra Canônica do ShellRoute](../docs/arquitetura/regra_shellroute.md)**  
📖 **[Guia de Novas Telas](../docs/arquitetura/novas_telas.md)**

---

## 🚨 Regra de Ouro

**O CI é a autoridade final.**  
Se `dart scripts/audit_shell_route.dart` falhar, o PR não entra. Sem exceções.

---

*Este script é um mecanismo de defesa para impedir regressões na arquitetura de navegação.*

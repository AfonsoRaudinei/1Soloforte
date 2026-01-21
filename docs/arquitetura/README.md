# 📐 Arquitetura SoloForte

## 🛡️ Regras Fundamentais

### 1. Regra do ShellRoute (OBRIGATÓRIA)

**O mapa é o sistema operacional. O resto são aplicativos.**

- ❌ Telas dentro do `ShellRoute` (`/map`) **NÃO PODEM** ter `Scaffold` ou `AppBar`
- ✅ O `DashboardLayout` é o único dono da navegação persistente
- ⚠️ Modais podem ter `AppBar` se marcados com `// ci: allow-appbar`

📖 **Leia mais:** [Regra Canônica do ShellRoute](regra_shellroute.md)

---

## 🧩 Criando Novas Telas

Antes de criar uma nova tela, consulte:

📖 **[Guia de Novas Telas](novas_telas.md)**

**Perguntas obrigatórias:**
1. A tela fica em `/map`? → Sem `Scaffold`/`AppBar`
2. É um modal? → Pode ter `AppBar` com comentário de bypass

---

## 🧪 CI de Auditoria

Antes de abrir um PR, **SEMPRE** rode localmente:

```bash
dart scripts/audit_shell_route.dart
```

**✅ Sucesso:**
```
✅ SUCESSO: Todas as telas do ShellRoute estão em conformidade.
```

**❌ Falha:**
```
🔴 FALHA DE CI: Foram encontradas X violações...
```

O CI do GitHub bloqueia automaticamente PRs com violações.

---

## 📋 Estrutura de Rotas

```
/                           → Landing (público)
/login                      → Login (público)
/map                        → ShellRoute (DashboardLayout)
  ├─ /map/occurrences       → Lista de Ocorrências
  ├─ /map/clients           → Lista de Clientes
  ├─ /map/calendar          → Agenda
  └─ ...

/map/settings               → FORA do Shell (tem AppBar)
/map/clients/:id            → FORA do Shell (tem AppBar)
/occurrences/new            → FORA do Shell (tem AppBar)
...
```

**Regra:** Se está DENTRO do `ShellRoute`, herda o layout do mapa.

---

## 🚨 Bloqueios Automáticos

O CI rejeitará automaticamente PRs que:

1. Adicionem `AppBar` em telas do `ShellRoute` sem bypass
2. Adicionem `Scaffold` em telas do `ShellRoute`
3. Quebrem a regra canônica de navegação

**Sem exceções. Sem "depois a gente arruma".**

---

## 📚 Documentos Relacionados

- [Regra Canônica do ShellRoute](regra_shellroute.md)
- [Guia de Novas Telas](novas_telas.md)
- [Template de Pull Request](../.github/pull_request_template.md)

---

**💡 Filosofia:** Código grande, mas governável. Regras claras, CI implacável, time alinhado.

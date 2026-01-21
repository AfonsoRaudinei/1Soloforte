# 📚 SoloForte - Índice de Documentação

Bem-vindo à documentação técnica do SoloForte. Este índice centraliza todas as regras, guias e referências do projeto.

---

## 🏗️ Arquitetura

### Regras Fundamentais
- **[Regra Canônica do ShellRoute](arquitetura/regra_shellroute.md)** ⭐ OBRIGATÓRIO
  - Por que o mapa não pode ter AppBars
  - Como identificar se sua tela está no ShellRoute
  - Exemplos corretos e incorretos

### Guias Práticos
- **[Criando Novas Telas](arquitetura/novas_telas.md)**
  - Templates de código prontos
  - Perguntas obrigatórias antes de começar
  - Checklist de PR

- **[README de Arquitetura](arquitetura/README.md)**
  - Visão geral do sistema
  - Estrutura de rotas
  - Bloqueios automáticos do CI

---

## 🛠️ Scripts e CI

- **[Scripts de Auditoria](../scripts/README.md)**
  - Como rodar `dart scripts/audit_shell_route.dart`
  - Integração com GitHub Actions, GitLab CI, CircleCI
  - Interpretação de erros

- **[Workflow de CI](.github/workflows/audit_architecture.yml)**
  - Configuração do GitHub Actions
  - Bloqueio automático de PRs

---

## 📋 Templates

- **[Template de Pull Request](../.github/pull_request_template.md)**
  - Checklist arquitetural obrigatório
  - Seções padrão de PR

---

## 🧠 Filosofia do Projeto

> **No SoloForte, o mapa é o sistema operacional.**  
> O resto são aplicativos rodando em cima dele.

Essa filosofia guia todas as decisões arquiteturais:
- ✅ Mapa fullscreen sem interrupções
- ✅ Navegação unificada via DashboardLayout
- ✅ Modais explicitamente marcados
- ✅ CI como autoridade final

---

## 🚨 Regras de Ouro

1. **Tela no ShellRoute → Sem Scaffold/AppBar**
2. **Modal com AppBar → Marcado com `// ci: allow-appbar`**
3. **CI falhou → PR não entra**

**Sem "depende". Sem "acho que". Sem exceção criativa.**

---

## 🆘 Precisa de Ajuda?

1. Leia primeiro: [Regra Canônica do ShellRoute](arquitetura/regra_shellroute.md)
2. Consulte: [Guia de Novas Telas](arquitetura/novas_telas.md)
3. Rode: `dart scripts/audit_shell_route.dart`
4. Se ainda tiver dúvidas, abra uma issue com o label `arquitetura`

---

**💡 Lembre-se:** Código grande, mas governável. Regras claras, CI implacável, time alinhado.

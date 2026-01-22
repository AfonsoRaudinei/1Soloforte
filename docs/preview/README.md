# Baseline Visual Canônico - SoloForte (Hard Mode)

**Data de Captura:** 22 de Janeiro de 2026  
**Versão da Arquitetura:** Hard Mode (ShellRoute aprovado)  
**Status:** ✅ Validado e Aprovado

---

## 📋 Propósito

Este diretório contém o **baseline visual oficial** do SoloForte após a implementação e validação da arquitetura Hard Mode. Estes screenshots servem como:

1. **Padrão de Verdade Visual** → Qualquer desvio futuro deve ser comparado contra estas imagens
2. **Documentação Imutável** → Registro fotográfico da implementação correta
3. **Governança Arquitetural** → Prova visual de conformidade com as regras estabelecidas

---

## 🛡️ Regras Arquiteturais Validadas

### ✅ Fluxo Aberto (ShellRoute)
Telas filhas de `/map` **NÃO possuem**:
- ❌ AppBar
- ❌ BottomNavigationBar
- ❌ Barras de navegação estruturais

Navegação é controlada exclusivamente por:
- ✅ FAB (Floating Action Button)
- ✅ Drawer
- ✅ Elementos contextuais da própria tela

### ✅ Fluxo Fechado (Fora do ShellRoute)
Telas navegadas via `_rootNavigatorKey` **POSSUEM**:
- ✅ AppBar com botão de voltar
- ✅ Título centralizado
- ✅ Isolamento visual do mapa

---

## 📸 Screenshots Oficiais

| # | Arquivo | Rota | Tipo de Fluxo | Validação |
|---|---------|------|---------------|-----------|
| 01 | `01_map_home.png` | `/map` | Aberto | ✅ Sem AppBar, mapa fullscreen, FAB visível |
| 02 | `02_map_reports.png` | `/map/reports` | Aberto | ✅ Sem AppBar, abas encostando no topo |
| 03 | `03_map_occurrences.png` | `/map/occurrences` | Aberto | ✅ Sem AppBar, filtros no topo |
| 04 | `04_map_calendar.png` | `/map/calendar` | Aberto | ✅ Sem AppBar, calendário fullscreen |
| 05 | `05_closed_flow_example.png` | `/map/settings` | **Fechado** | ✅ **COM AppBar** e botão voltar |

---

## 🔒 Política de Imutabilidade

**ESTAS IMAGENS SÃO IMUTÁVEIS.**

- ❌ Não podem ser alteradas sem aprovação formal
- ❌ Não podem ser deletadas
- ✅ Podem ser referenciadas em auditorias
- ✅ Podem ser usadas em comparações de regressão visual

Qualquer divergência futura entre a aplicação e estas imagens deve ser:
1. **Intencional e documentada**, OU
2. **Tratada como regressão arquitetural**

---

## 🏆 Governança Fechada

Este baseline marca o fechamento oficial do ciclo de governança Hard Mode:

| Pilar | Status |
|-------|--------|
| Regra Arquitetural | ✅ Codificada (`scripts/audit_shell_route.dart`) |
| CI/CD | ✅ Automatizado (`.github/workflows/audit.yml`) |
| Conformidade Técnica | ✅ Validado (14/14 telas) |
| Build Funcional | ✅ Aprovado |
| Baseline Visual | ✅ **ESTE DOCUMENTO** |

**A arquitetura SoloForte agora se auto-defende.**

---

## 📝 Notas Técnicas

- **Renderizador:** Chrome (Web)
- **Porta:** 8080
- **Modo:** Debug
- **Resolução:** Viewport padrão do Chrome
- **Autenticação:** Modo Demo

---

**Assinatura Digital:** Baseline capturado automaticamente via browser_subagent  
**Commit Hash:** _[será preenchido após commit]_

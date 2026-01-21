# Baseline Visual — ShellRoute Hard Mode

Este diretório contém o estado visual oficial do SoloForte após a institucionalização da regra:

> **Telas dentro do ShellRoute (`/map`) NÃO possuem AppBar.**

## 🎯 Objetivo
Criar uma referência visual imutável que comprove:
- Ausência total de AppBar no ShellRoute
- Navegação correta via FAB/Drawer
- Diferença clara entre fluxo ABERTO vs FECHADO

## 📸 Galeria Oficial

Esta pasta deve conter os seguintes prints (renderizados em HTML para fidelidade):

| Arquivo | Rota | Descrição Esperada |
| :--- | :--- | :--- |
| `01_map_home.png` | `/#/map` | Mapa fullscreen, zero barra. Apenas FAB e controles do mapa. |
| `02_map_occurrences.png` | `/#/map/occurrences` | Lista com header inline (texto + padding). Sem AppBar roxo/branco. |
| `03_map_clients.png` | `/#/map/clients` | Lista de clientes ocupando o topo. FAB visível. |
| `04_map_calendar.png` | `/#/map/calendar` | Agenda integrada ao layout base. |
| `05_closed_flow_clients_new.png` | `/#/map/clients/new` | **CONTRASTE:** Tela branca, com AppBar e botão voltar. |

## 🧪 Como Gerar Novos Prints

Se precisar atualizar o baseline, siga rigorosamente:

1. **Rodar em modo HTML (crucial):**
   ```bash
   flutter run -d chrome --web-renderer html
   ```
   *O CanvasKit pode mascarar sombras e paddings fantasmas.*

2. **Capturar:**
   - Tela cheia
   - Sem DevTools aberto
   - Sem zoom (100%)

## ✅ Critérios de Aprovação

Qualquer PR que altere a arquitetura visual do mapa deve ser comparado com este baseline.
- **Se aparecer barra no topo das telas 01-04:** ❌ REJEITADO (Regressão)
- **Se sumir a barra da tela 05:** ❌ REJEITADO (Inconsistência)

---

**Este baseline é a prova da integridade UX do SoloForte.**

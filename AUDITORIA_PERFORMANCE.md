# Auditoria de Leveza e Fluidez - SoloForte

Este documento detalha os pontos identificados para otimização de performance, fluidez e UX do aplicativo, com foco em manter a lógica de negócio intacta enquanto melhora a resposta visual e processamento.

## 1. Otimização de Renderização do Mapa (`HomeScreen`)
**Diagnóstico:**
O `HomeScreen` é um widget pesado que reconstrói inteiramente sempre que:
- O estado de desenho muda (`drawingControllerProvider`).
- O estado das notificações/clima/visitas é atualizado.
- O usuário seleciona algo no menu radial.

Isto ocorre porque `ref.watch` está sendo chamado no topo do método `build`.

**Impacto:**
Queda de FPS ao desenhar no mapa ou receber atualizações, causando engasgos na rolagem/zoom do mapa.

**Solução Proposta:**
- **Isolar Camadas:** Transformar as camadas do mapa (`PolygonLayer`, `MarkerLayer`) em widgets separados (`ConsumerWidget`) que escutam seus respectivos providers. O `FlutterMap` principal deve ser constante e não reconstruir com mudanças de estado externas irrelevantes.
- **Micro-Updates:** Atualizações de desenho devem afetar apenas a camada de desenho, não a tela inteira.

## 2. Gerenciamento de Estado de Notificações
**Diagnóstico:**
No `NotificationsNotifier`, cada ação de `markAsRead` dispara `loadNotifications()`, que define o estado como `AsyncValue.loading()`.

**Impacto:**
**Flickering (Piscada):** A lista de notificações desaparece e mostra um `CircularProgressIndicator` por uma fração de segundo toda vez que o usuário marca uma notificação como lida, quebrando a sensação de fluidez.

**Solução Proposta:**
- **Atualização Otimista:** Atualizar a lista localmente na memória imediatamente e disparar a requisição de persistência em segundo plano, sem transitar pelo estado de `loading`.

## 3. Persistência de Dados (TicketRepository)
**Diagnóstico:**
tickets são salvos como uma única string JSON gigante no `SharedPreferences`.

**Impacto:**
Conforme o uso aumenta, converter essa string (decode/encode) na thread principal (UI thread) causará travamentos (jank) perceptíveis ao abrir o suporte ou salvar um ticket.

**Solução Proposta:**
- Migrar para **SQLite** (já incluso nas dependências via `sqflite`) ou manter a solução atual apenas para protótipo, mas ciente do gargalo.

## 4. Animações e Feedback Visual
**Diagnóstico:**
Algumas animações dependem de `setState` em widgets grandes.

**Pontos Positivos Identificados:**
- O `RadialMenu` usa animações independentes, o que é bom.
- O tema já usa `NoSplash.splashFactory` para um feel mais "iOS/Premium".

**Solução Proposta:**
- Garantir que animações de entrada/saída (modais) usem `Hero` widgets onde possível para transições mais suaves entre telas.

## 5. Carregamento de Listas
**Diagnóstico:**
Listas longas podem estar renderizando itens desnecessários se não usarem `ListView.builder` ou `separated` corretamente.
- Na auditoria, verificou-se o uso correto de `ListView.separated` em notificações. Manter esse padrão.

---

## Plano de Execução Imediata (Refatoração Segura)

1.  **Refatorar `NotificationsNotifier`** para eliminar o estado de loading desnecessário (ganho imediato de fluidez).
2.  **Otimizar `HomeScreen`** extraindo os listeners para dentro das camadas do mapa.

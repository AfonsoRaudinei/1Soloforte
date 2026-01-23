# ✅ iOS Maps Preview - Marketing CTA Fix

**Data:** 2026-01-23  
**Status:** Implementado  
**Complexidade:** Baixa (cirúrgica)

---

## 🎯 OBJETIVO

Corrigir o fluxo de navegação do Marketing no mapa para seguir o padrão iOS Maps:
- ✅ Preview Sheet permanece como visualização rápida
- ✅ CTA "Ver case completo" navega para tela de edição
- ✅ Mapa permanece visível durante preview

---

## 🔧 ALTERAÇÃO IMPLEMENTADA

### Arquivo modificado:
`lib/features/marketing/presentation/widgets/marketing_publication_sheet_listener.dart`

### Mudanças:

#### 1. Import adicionado (linha 3):
```dart
import 'package:go_router/go_router.dart';
```

#### 2. Navegação implementada (linhas 72-73):
```dart
onSecondaryAction: () {
  MarketingInteractionTracker.ctaClicked(
    publicationId: selected.id,
  );
  // Navegar para tela de edição completa (iOS Maps pattern)
  context.push('/map/marketing/edit?id=${selected.id}');
},
```

---

## 📊 COMPORTAMENTO CORRETO

### Fluxo iOS Maps:

```
📍 Pin clicado no mapa
    ↓
📱 Preview Sheet abre (peek inicial ~32%)
    • Mapa visível atrás
    • Exibe foto de capa
    • Mostra título, tipo, nível investimento
    • Galeria de comparações
    • Informações (cliente, área, produto)
    • Resultado destacado
    ↓
👤 Usuário pode:
    • Fechar (volta ao mapa)
    • OU clicar "Ver case completo"
    ↓
🚀 CTA "Ver case completo" → NAVEGA PARA:
    ✅ Rota: /map/marketing/edit?id=ABC123
    ✅ Screen: PublicationEditorScreen
    ✅ Tela completa com AppBar
    ✅ Abas (Dados, Comparativo, Resultado)
    ✅ Edição completa de fotos e dados
    ✅ Botão Voltar retorna ao mapa
```

---

## ✅ VALIDAÇÕES

### Preview Sheet (NÃO alterado):
- ✅ NÃO usa AppBar
- ✅ NÃO tem abas
- ✅ NÃO é fullscreen
- ✅ Mapa permanece visível
- ✅ DraggableScrollableSheet (iOS style)
- ✅ Handle bar visível
- ✅ Expansível por drag gesture

### CTA (CORRIGIDO):
- ✅ Navega para rota existente
- ✅ Passa publicationId via query param
- ✅ Usa context.push (GoRouter)
- ✅ Não duplica código
- ✅ Analytics mantido (MarketingInteractionTracker)

### Tela de Edição (NÃO alterada):
- ✅ Usa PublicationEditorScreen existente
- ✅ Rota: /map/marketing/edit (já registrada)
- ✅ parentNavigatorKey: _rootNavigatorKey
- ✅ AppBar permitido (closed flow)
- ✅ Abas funcionais
- ✅ Edição de fotos completa

---

## 🚫 ESCOPO NÃO ALTERADO

- ❌ NÃO criou novas rotas
- ❌ NÃO refatorou tela de edição
- ❌ NÃO alterou Preview Sheet visual
- ❌ NÃO mexeu em providers globais
- ❌ NÃO adicionou novos estados
- ❌ NÃO modificou outros módulos

---

## 🏁 RESULTADO

**Linha de código adicionada:** 1  
**Imports adicionados:** 1  
**Arquivos modificados:** 1  
**Rotas criadas:** 0 (usa existente)  
**Comportamento iOS Maps:** ✅ Implementado

O mapa nunca abre tela de edição diretamente. O Preview é apenas visualização rápida. O CTA navega para a tela completa usando a rota registrada no GoRouter.

---

## 📝 NOTAS TÉCNICAS

### Rota de destino:
- **Path:** `/map/marketing/edit`
- **Query param:** `id` (publicationId)
- **Navigator:** `_rootNavigatorKey` (closed flow)
- **Screen:** `PublicationEditorScreen`
- **Linha no router.dart:** 183-193

### Padrão iOS Maps:
- **Preview** = Quick peek + dismiss fácil
- **Detail** = Navegação explícita via CTA
- **Context** = Mapa sempre visível no preview

---

**Implementação:** Completa  
**Status:** Pronto para teste  
**UX:** iOS Maps compliant ✅

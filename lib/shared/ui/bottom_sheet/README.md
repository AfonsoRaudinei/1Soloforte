# 📱 iOS Map Bottom Sheet

Componente reutilizável de **Bottom Sheet estilo iOS / Apple Maps** para o projeto SoloForte.

## 📍 Localização

```
lib/shared/ui/bottom_sheet/
├── ios_map_bottom_sheet.dart          # Bottom Sheet principal
├── ios_map_bottom_sheet_button.dart   # Botão floating/pill
├── ios_map_bottom_sheet_example.dart  # Exemplos de uso
└── README.md                          # Esta documentação
```

---

## 🎯 Características

### Bottom Sheet (`IosMapBottomSheet`)

✅ Altura inicial: **~30-35%** da tela
✅ Expandível até **~85%** via drag
✅ **Handle** visual (barra cinza superior)
✅ Fundo branco com bordas arredondadas
✅ Sombra sutil
✅ **Draggable** para expandir/recolher
✅ Fecha ao arrastar para baixo
✅ Mapa permanece visível ao fundo
✅ `isScrollControlled: true`
✅ SafeArea respeitada

### Botão (`IosMapBottomSheetButton`)

✅ Estilo **floating / pill**
✅ Bordas arredondadas (radius alto)
✅ Sombra suave
✅ Ícone + texto
✅ Feedback visual ao toque

---

## 🧩 Uso Básico

### 1. Botão + Bottom Sheet Simples

```dart
import 'package:soloforte_app/shared/ui/bottom_sheet/ios_map_bottom_sheet.dart';
import 'package:soloforte_app/shared/ui/bottom_sheet/ios_map_bottom_sheet_button.dart';

// No seu widget (ex: sobre o mapa)
IosMapBottomSheetButton(
  icon: Icons.info_outline,
  label: 'Ver Detalhes',
  onTap: () {
    IosMapBottomSheet.show(
      context: context,
      child: IosMapBottomSheetContent(
        title: 'Título',
        subtitle: 'Subtítulo',
        description: 'Descrição do conteúdo...',
      ),
    );
  },
)
```

### 2. Bottom Sheet com Conteúdo Personalizado

```dart
IosMapBottomSheet.show(
  context: context,
  initialHeightFactor: 0.35,  // Altura inicial (35% da tela)
  maxHeightFactor: 0.85,      // Altura máxima (85% da tela)
  child: YourCustomWidget(),  // Seu widget personalizado
);
```

### 3. Botão Customizado

```dart
IosMapBottomSheetButton(
  icon: Icons.place,
  label: 'Localização',
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  onTap: () => _handleTap(),
)
```

---

## 📦 Widgets Disponíveis

### `IosMapBottomSheet`

**Método estático:**
```dart
IosMapBottomSheet.show<T>({
  required BuildContext context,
  required Widget child,
  double initialHeightFactor = 0.35,
  double maxHeightFactor = 0.85,
  BorderRadius? borderRadius,
})
```

**Parâmetros:**
- `context`: BuildContext
- `child`: Widget a ser exibido no bottom sheet
- `initialHeightFactor`: Altura inicial (0.0 a 1.0, padrão: 0.35)
- `maxHeightFactor`: Altura máxima (0.0 a 1.0, padrão: 0.85)
- `borderRadius`: BorderRadius personalizado (opcional)

---

### `IosMapBottomSheetButton`

**Construtor:**
```dart
IosMapBottomSheetButton({
  required VoidCallback onTap,
  required IconData icon,
  required String label,
  Color? backgroundColor,
  Color? foregroundColor,
})
```

**Parâmetros:**
- `onTap`: Callback ao tocar no botão
- `icon`: Ícone a ser exibido
- `label`: Texto do botão
- `backgroundColor`: Cor de fundo (opcional, padrão: branco)
- `foregroundColor`: Cor do texto/ícone (opcional, padrão: preto)

---

### `IosMapBottomSheetContent`

Widget de conteúdo genérico/placeholder.

```dart
IosMapBottomSheetContent({
  String? title,
  String? subtitle,
  String? description,
  Widget? customContent,
})
```

---

## 🎨 Comportamento iOS / Maps

### Drag Gestures

1. **Arrastar para baixo** (quando no estado inicial) → Fecha o bottom sheet
2. **Arrastar para cima** → Expande o bottom sheet
3. **Arrastar para baixo** (quando expandido) → Retrai para altura inicial
4. **Arrastar muito para baixo** → Fecha completamente

### Animações

- Entrada: Suave com `Curves.easeOut` (300ms)
- Expansão/Retração: Animação suave
- Fechamento: Fade out natural

### Visual

- **Handle**: Barra cinza claro (36x5px) no topo
- **Bordas**: Radius de 28px (superior esquerda/direita)
- **Sombra**: Dupla (blur 20 + blur 10, offset vertical negativo)
- **Fundo**: Branco sólido

---

## ⚠️ Regras de Uso

### ✅ PERMITIDO

- Usar em qualquer contexto onde o fundo deve permanecer visível
- Customizar conteúdo interno
- Ajustar alturas inicial/máxima
- Estilizar botão (cores)

### 🚫 NÃO PERMITIDO

- ❌ Não usar `Navigator.push` dentro do bottom sheet
- ❌ Não adicionar `AppBar` no conteúdo
- ❌ Não usar em fluxos que requerem tela cheia
- ❌ Não modificar os arquivos base sem motivo válido

---

## 🧪 Exemplo Completo

Veja `ios_map_bottom_sheet_example.dart` para exemplos funcionais.

---

## 🔧 Manutenção

Este é um **componente base reutilizável**.

- Mantém-se **isolado** (sem lógica de negócio)
- **Sem dependências** de estado global
- **Sem providers** ou backend
- Focado apenas em **UI/UX**

---

## 📝 Changelog

### v1.0.0 (2026-01-23)
- ✨ Criação inicial do componente
- ✨ Suporte a drag para expandir/recolher
- ✨ Botão floating/pill
- ✨ Conteúdo genérico/placeholder
- ✨ Estilo iOS/Apple Maps completo

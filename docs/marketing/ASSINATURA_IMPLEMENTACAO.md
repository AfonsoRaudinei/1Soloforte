# 📊 ASSINATURA DE PUBLICAÇÕES — IMPLEMENTAÇÃO

## ✅ REGRA-MÃE IMPLEMENTADA

**Assinatura ≠ curtida**  
É **confirmação técnica**: "vi, concordo, valido"

---

## 📍 ONDE MOSTRAR (Decisão Final)

### 1️⃣ Lista da Aba Marketing (Relatórios) — ✅ IMPLEMENTADO

**Posição**: Linha de sinais, mesma hierarquia que visualizações

```
👁️ 12   ✍️ 4   👥 [A][B][+2]        ✏️ Editar
```

**Por que funciona**:
- ✅ Contexto analítico
- ✅ Usuário já está "lendo dados"
- ✅ Não interfere na ação principal
- ✅ Escala bem com várias publicações

**Características visuais**:
- ✅ Ícone discreto: `Icons.draw_outlined`
- ✅ Cor neutra: `Color(0xFF757575)` (cinza)
- ✅ Mesma hierarquia que 👁️ visualizações
- ✅ Tamanho: 16px (pequeno)

---

### 2️⃣ Preview do Mapa (Bottom Sheet) — ✅ IMPLEMENTADO

**Posição**: Logo abaixo do título, antes dos badges

```
Case | Fazenda São João
✍️ 4 assinaturas • 👁️ 12 visualizações
```

**Comportamento**:
- ✅ Texto neutro, não protagonista
- ✅ Ícones monocromáticos (14px)
- ✅ Separador discreto (•)

**Botão "Assinar"** (no rodapé de ações):
- ✅ Sempre visível
- ✅ Texto claro: "✍️ Assinar"
- ✅ Após assinar: "✔️ Assinado" (desabilitado)
- ✅ Design neutro, não chamativo
- ✅ Localizado entre "Ver detalhes" e "Editar"

**Visual do botão**:
- ✅ `OutlinedButton.icon` (não filled)
- ✅ Cor: `Color(0xFF757575)` (cinza neutro)
- ✅ Borda fina
- ✅ Padding reduzido (12px vertical)
- ✅ Ícone: `Icons.draw_outlined` → `Icons.check_circle_outline`

---

### 3️⃣ Editor — ❌ NÃO IMPLEMENTADO (conforme especificação)

**Motivo técnico**:
- Editor = modo de trabalho
- Assinatura = validação posterior
- Misturar isso distrai e confunde

**Decisão**: Editor não é lugar de feedback social.

---

## 🧠 COMO O USUÁRIO "ASSINA"

### Onde o botão aparece
✅ **Somente no Preview do Mapa** (Bottom Sheet)

### Fluxo de interação
1. Usuário abre o Bottom Sheet ao clicar no pin do mapa
2. Vê contador discreto: "✍️ 4 assinaturas"
3. No rodapé, botão "✍️ Assinar" (se não assinou)
4. Ao clicar: botão muda para "✔️ Assinado" (desabilitado)
5. Contador incrementa

### Regra técnica
- ✅ **Sem desassinar** (ato técnico, não like)
- ✅ Estado local preservado durante sessão
- ⚠️ **TODO**: Implementar persistência real (salvar em `marketing_publication_signatures`)

---

## 📊 DADOS SIMULADOS (até implementar tabela real)

### Função de cálculo de assinaturas

```dart
int _calculateSimulatedSignatures(MarketingPublication publication) {
  final views = _calculateSimulatedViews(publication);
  final seed = publication.id.hashCode.abs() % 3;
  return (views * 0.2).round() + seed;
}
```

**Lógica**:
- Assinaturas ≈ 20% das visualizações
- Variação baseada no hash do ID (consistência)
- Valores realistas e estáveis

---

## 👁️ REGISTRO DE VISUALIZAÇÃO

### ✅ REGRA DE OURO (Intenção Real)

**Visualização só conta quando o usuário ENTRA no conteúdo.**
Lista e relatório não contam.
Isso mantém o dado limpo e confiável.

### Onde registrar (✅ SIM)
1. **Preview do Mapa (Bottom Sheet)**
   - Intenção: Clique no pin + Abertura do card
   - Onde: `initState` do `MarketingPublicationBottomSheet`
2. **Editor (Leitura/Edição)**
   - Intenção: "Ver detalhes" + Abertura da tela cheia

### Onde NÃO registrar (❌ NÃO)
1. **Relatórios (Lista)**
   - É leitura analítica ("sobre" a publicação), não consumo.
2. **Preview do Mapa (apenas carregar no mapa)**
   - Ícones no mapa não contam.

### Implementação Técnica
```dart
@override
void initState() {
  super.initState();
  // REGISTRA APENAS AQUI (PREVIEW)
  repository.recordView(
    publicationId: widget.publication.id,
    userId: widget.currentUserId,
  );
}
```

---

## 🎨 TOM VISUAL (Implementado)

| Característica | Valor | Motivo |
|---|---|---|
| **Ícone** | Monocromático | Não compete com conteúdo |
| **Cor** | `#757575` (cinza) | Neutro, não chamativo |
| **Hierarquia** | Igual ao 👁️ | Acompanha, não lidera |
| **Tamanho** | 14-16px | Discreto |
| **Peso** | FontWeight.w500 | Leve, não bold |

---

## 🚫 ONDE NÃO ESTÁ (conforme especificação)

- ❌ SideMenu
- ❌ Dashboard geral
- ❌ Editor
- ❌ Tela de criação
- ❌ Gráfico dedicado

**Motivo**: Se entrar nesses lugares, vira ruído.

---

## 📁 ARQUIVOS MODIFICADOS

### 1. **`lib/features/reports/presentation/tabs/marketing_tab.dart`**
✅ Já implementado desde versão anterior
- Linha de sinais: `👁️ 12   ✍️ 4   👥 [A][B][+2]`

### 2. **`lib/features/marketing/presentation/widgets/marketing_publication_bottom_sheet.dart`**

**Adicionado**:
1. **Linha de sinais discretos** em `_InfoBlock`:
   ```dart
   ✍️ 4 assinaturas • 👁️ 12 visualizações
   ```

2. **Botão "Assinar"** em `_FooterActions`:
   - State management com `_hasSigned`
   - Mudança de estado: "Assinar" → "Assinado"
   - Visual neutro e discreto

3. **Funções de simulação**:
   ```dart
   int _calculateSimulatedViews(MarketingPublication publication)
   int _calculateSimulatedSignatures(MarketingPublication publication)
   ```

---

## ⚙️ PRÓXIMOS PASSOS (Futuro)

### 1. Implementar persistência real

**Criar tabela**:
```sql
CREATE TABLE marketing_publication_signatures (
  id TEXT PRIMARY KEY,
  publication_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  signed_at INTEGER NOT NULL,
  FOREIGN KEY (publication_id) REFERENCES marketing_publications(id)
);
```

**Criar repositório**:
- `MarketingSignatureRepository`
- Métodos: `create()`, `getByPublicationId()`, `hasUserSigned()`

**Integrar com Bottom Sheet**:
- Verificar se usuário já assinou ao abrir
- Persistir assinatura ao clicar
- Atualizar contador em tempo real

### 2. Detalhe de quem assinou (micro-UX)

**Tooltip/Popover**:
```
Assinado por:
• João Silva
• Maria Santos
• +2
```

**Implementação**:
- Widget `Tooltip` ou `InkWell` com overlay
- Listar até 3 nomes
- Indicador "+N" para restante

---

## 🧠 AVALIAÇÃO TÉCNICA

### Por que essa implementação é sólida

✅ **Respeita o papel da assinatura**
- Não é protagonista
- Não compete com conteúdo
- Contexto técnico claro

✅ **Não cria dependência de UX**
- Funciona sem assinatura
- Não bloqueia fluxos
- Não é gamificado

✅ **Escala bem**
- 1 ou 100 publicações
- Layout não quebra
- Performance mantida

✅ **Não exige refatoração futura**
- Estrutura preparada para persistência real
- Visual já definido
- UX consistente

---

## ✅ STATUS FINAL

**IMPLEMENTAÇÃO COMPLETA E PRONTA**

- ✅ Aba Marketing (Relatórios): sinais discretos
- ✅ Bottom Sheet: contador + botão
- ✅ Visual neutro e técnico
- ✅ Estado local funcionando
- ⚠️ TODO: Persistência real (quando necessário)

**Não tem excesso.**  
**Não tem gambiarra.**  
**Assinatura acompanha, não lidera.**

# 🚀 GUIA RÁPIDO - MVP CLIENTES

**Status:** ✅ Pronto para Execução (MVP)

As features problemáticas foram isoladas temporariamente. Você pode testar a feature de **Clientes** agora.

## 🏃 Como Rodar

Execute no terminal:

```bash
flutter run
```

*(Se estiver no web, use `flutter run -d chrome`)*

## 🧪 O Que Testar (Checklist MVP)

### 1. Lista de Clientes (`/dashboard/clients`)
- [ ] A lista carrega sem erros?
- [ ] Os cards mostram as informações básicas?
- [ ] A busca filtra os nomes corretamente?

### 2. Detalhes do Cliente
- [ ] Ao clicar em um cliente, a tela de detalhes abre?
- [ ] As abas (Info, Fazendas, Histórico, Stats) funcionam?
- [ ] O botão "Voltar" funciona?

### 3. Criação de Cliente
- [ ] O botão "+" abre o formulário?
- [ ] O formulário valida campos obrigatórios?
- [ ] Ao salvar, ele retorna para a lista? (Dados são mock, então podem não persistir no refresh, mas devem aparecer na lista em memória).

## ⚠️ Limitações Conhecidas (MVP)
- **Mapas, Clima, Relatórios**: Estão desativados para permitir o teste.
- **Upload de Avatar**: A interface existe, mas não fará upload real.
- **Edição**: Pode não carregar os dados existentes (use Criar Novo para testar o formulário).

Bom teste!

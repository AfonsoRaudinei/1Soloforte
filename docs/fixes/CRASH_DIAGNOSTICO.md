# 🔍 DIAGNÓSTICO - CRASH APÓS PRIMEIRA CARGA

**Data:** 2026-01-23  
**Sintoma:** Página carrega uma vez, depois para de funcionar e pede reload

---

## 🎯 POSSÍVEIS CAUSAS

### 1. **Hot Reload com Erro de Estado**
- **Sintoma:** Após primeira navegação, ao fazer mudança no código ou navegar entre rotas, a app crasha
- **Causa:** Estado inconsistente após hot reload
- **Solução:** Use Hot Restart (Shift+R no terminal) ao invés de Hot Reload (r)

### 2. **Erro do Service Worker do Flutter**
- **Sintoma:** Após reload da página, recursos não carregam
- **Causa:** Service Worker do Flutter cacheia recursos antigos
- **Solução:**
  ```bash
  # No Chrome DevTools:
  # Application → Service Workers → Unregister
  # Ou
  # Application → Clear storage → Clear site data
  ```

### 3. **Erro no SQLite Web Worker**
- **Sintoma:** Erro ao tentar acessar banco de dados após primeira carga
- **Causa:** Web Worker do SQLite falha após primeira inicialização
- **Diagnóstico:** Verificar console do navegador para erros de "worker"

### 4. **Memory Leak ou Estado Corrupto**
- **Sintoma:** App funciona inicialmente mas degrada
- **Causa:** Providers ou streams não sendo disposed corretamente
- **Diagnóstico:** Verificar console para "setState called after dispose"

### 5. **Erro de Navegação (Router)**
- **Sintoma:** Primeira rota carrega, mas navegação subsequente falha
- **Causa:** Problema no GoRouter ou navegação
- **Diagnóstico:** Verificar console para erros de routing

---

## 🔧 CHECKLIST DE DIAGNÓSTICO

Execute os passos abaixo e anote os resultados:

### Passo 1: Verificar Console do Navegador
```
1. Abrir Chrome DevTools (F12)
2. Ir para aba Console
3. Recarregar a página
4. Anotar TODOS os erros (vermelho) e warnings (amarelo)
```

**Erros encontrados:**
```
[Anotar aqui]
```

### Passo 2: Verificar Network
```
1. DevTools → Network
2. Recarregar página
3. Verificar se há requests falhando (vermelho)
4. Verificar se sqflite_sw.js carrega (Status 200)
```

**Status sqflite_sw.js:** ___  
**Status sqlite3.wasm:** ___

### Passo 3: Verificar Service Workers
```
1. DevTools → Application → Service Workers
2. Verificar se há service workers registrados
3. Se houver, clicar em "Unregister"
4. Recarregar página
```

**Service Worker ativo:** Sim / Não

### Passo 4: Testar sem Cache
```
1. DevTools → Network
2. Marcar checkbox "Disable cache"
3. Recarregar página (Cmd+Shift+R)
4. Verificar se problema persiste
```

**Problema persiste sem cache:** Sim / Não

### Passo 5: Verificar Memória
```
1. DevTools → Performance
2. Iniciar recording
3. Usar a aplicação normalmente
4. Parar recording
5. Verificar se há memory leaks
```

**Memory leak detectado:** Sim / Não

---

## 🛠️ SOLUÇÕES RÁPIDAS

### Solução 1: Limpar Todo o Cache
```bash
# No navegador:
1. Cmd+Shift+Delete (Mac) ou Ctrl+Shift+Delete (Windows/Linux)
2. Selecionar "Cached images and files"
3. Clicar em "Clear data"

# Ou via DevTools:
1. F12 → Application → Clear storage
2. Clicar em "Clear site data"
```

### Solução 2: Reiniciar Servidor em Modo Release
```bash
flutter run -d chrome --web-port 55894 --release
```

**Nota:** Modo release é mais estável mas sem hot reload

### Solução 3: Desabilitar Service Worker do Flutter
```bash
# Editar web/index.html e adicionar:
<script>
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.getRegistrations().then(function(registrations) {
      for(let registration of registrations) {
        registration.unregister();
      }
    });
  }
</script>
```

### Solução 4: Rodar sem Service Worker
```bash
flutter run -d chrome --web-port 55894 --no-web-resources-cdn
```

---

## 📊 PADRÃO DE ERRO TÍPICO

### Se o erro é do SQLite:
```javascript
// Console mostrará:
"SqfliteFfiWebWorkerException"
"Failed to execute 'postMessage' on 'Worker'"
"Worker initialization failed"
```

**Solução:** Regenerar arquivos do worker
```bash
dart run sqflite_common_ffi_web:setup --force
```

### Se o erro é de State Management:
```dart
// Console mostrará:
"setState() called after dispose()"
"Bad state: Provider disposed"
"Looking up a deactivated widget's ancestor is unsafe"
```

**Solução:** Revisar ciclo de vida dos Providers

### Se o erro é de Router:
```dart
// Console mostrará:
"GoRouter: Could not find a match"
"Navigator operation requested with a context that does not include a Navigator"
```

**Solução:** Revisar configuração do GoRouter

---

## 🎯 PRÓXIMOS PASSOS

1. **Executar o checklist acima**
2. **Anotar os erros específicos do console**
3. **Testar com cache desabilitado**
4. **Se necessário, limpar storage completamente**
5. **Reportar erros específicos para diagnóstico mais preciso**

---

## 📝 TEMPLATE DE REPORTE DE ERRO

```
**Descrição:**
[O que acontece]

**Passos para reproduzir:**
1. Abrir http://localhost:55894
2. [Ação que causa o problema]
3. [Resultado observado]

**Erros no Console:**
```
[Copiar e colar TODOS os erros do console]
```

**Comportamento esperado:**
[O que deveria acontecer]

**Screenshots:**
[Se possível, anexar prints do DevTools]
```

---

## 🔍 COMANDOS ÚTEIS PARA DIAGNÓSTICO

```bash
# Ver logs detalhados do Flutter
flutter run -d chrome --verbose 2>&1 | tee debug.log

# Rodar em modo profile (melhor performance)
flutter run -d chrome --profile

# Rodar em modo release (sem debug tools)
flutter run -d chrome --release

# Limpar cache completo
flutter clean && flutter pub get

# Regenerar arquivos web
dart run sqflite_common_ffi_web:setup --force

# Ver tamanho do build
flutter build web --release
du -sh build/web
```

---

**Status Atual:** ⏳ AGUARDANDO DIAGNÓSTICO  
**Próxima Ação:** Executar checklist e reportar erros específicos do console do navegador

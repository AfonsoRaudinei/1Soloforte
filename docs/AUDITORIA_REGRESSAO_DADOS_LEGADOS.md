Auditoria de Regressao – Dados Legados (SoloForte)

Objetivo
Garantir que dados antigos sem clientId:
- Nao quebrem o sistema
- Nao vazem para contexto de cliente
- Nao sejam migrados automaticamente

Cenarios de teste
1) Areas legadas (sem clientId)
- [ ] Abrir Mapa global -> areas aparecem
- [ ] Abrir Mapa via Cliente -> areas NAO aparecem
- [ ] Nenhum erro ou crash

2) Ocorrencias legadas (sem clientId)
- [ ] Modo global -> aparecem
- [ ] Modo cliente -> NAO aparecem
- [ ] Nao e possivel editar e salvar sem clientId

3) Agenda legada
- [ ] Eventos antigos carregam
- [ ] Eventos sem clientId aparecem apenas no modo global
- [ ] Eventos novos exigem persistencia real

Navegacao
- [ ] Fluxos nao quebram com dados legados
- [ ] Retornos funcionam normalmente

Resultado da Auditoria
- [ ] PASSOU – sem regressao
- [ ] FALHOU – bloquear release

Observacoes
(Documentar qualquer comportamento inesperado)

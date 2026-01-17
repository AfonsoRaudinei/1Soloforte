Checklist Tecnico – Pronto para Producao (SoloForte)

Estrutura e Contrato
- [ ] Contrato Cliente ↔ Agenda ↔ Mapa Tecnico ↔ Ocorrencias aprovado
- [ ] Nenhum vinculo por string (nome, label, texto)
- [ ] clientId obrigatorio em:
  - Clientes
  - Ocorrencias
  - Entidades geograficas (areas/fazendas/talhoes)

Cliente
- [ ] Persistencia real (SQLite)
- [ ] Reload nao perde dados
- [ ] Cliente nao depende de nenhum outro modulo

Agenda
- [ ] Sem mocks
- [ ] CRUD completo funcional
- [ ] Eventos persistem apos reload
- [ ] clientId nullable (evento global permitido)
- [ ] Agenda via Cliente filtra corretamente
- [ ] Agenda global mantem comportamento original

Mapa Tecnico
- [ ] Modo global sem filtro implicito
- [ ] Modo cliente filtra somente por clientId
- [ ] Dados legados sem clientId nao aparecem no modo cliente
- [ ] Mapa nao persiste cliente ativo

Ocorrencias
- [ ] clientId obrigatorio no modelo
- [ ] Nao e possivel criar ocorrencia sem cliente
- [ ] Filtro por clientId
- [ ] Legados sem clientId so aparecem no modo global

Navegacao
- [ ] Fluxo Cliente -> Agenda -> Cliente OK
- [ ] Fluxo Cliente -> Mapa -> Cliente OK
- [ ] Fluxo global intacto

Antipadroes (qualquer um = reprovacao)
- [ ] Ocorrencia orfa
- [ ] Filtro por nome
- [ ] Inferencia automatica de cliente
- [ ] Estado global sujo

Status final
- [ ] APROVADO – pronto para producao
- [ ] REPROVADO – bloqueado

Contrato tecnico oficial entre modulos: Cliente, Agenda, Mapa Tecnico e Ocorrencias

Entidade central
- Cliente e a entidade raiz e dona dos vinculos.
- Toda entidade relacionada deve referenciar clientId.
- Cliente nunca depende de outros modulos.

1) Cliente (Owner)
Responsabilidades
- Identidade do cliente.
- Vinculo com fazendas e dados geograficos.
- Vinculo com visitas e ocorrencias.

Campos obrigatorios
- clientId (string/uuid).

2) Cliente ↔ Agenda (Visitas)
Regra de contrato
- Evento pode ser global (sem cliente) ou pertencer a um cliente.
- clientId e nullable na Agenda.

Regras
- Se clientId existir, a visita pertence ao cliente.
- Agenda nao assume cliente implicitamente.
- Cliente nao depende da Agenda.

Dependencia
- Agenda -> Cliente (unidirecional).

3) Cliente ↔ Mapa Tecnico
Regra de contrato
- Mapa e contextual, nao dono de dados.
- Entidades geograficas devem carregar clientId.

Campos obrigatorios nas entidades geograficas
- Fazendas, talhoes, areas desenhadas, ocorrencias georreferenciadas: clientId obrigatorio.

Regras
- Modo global (sem clientId) ou modo cliente (com clientId).
- Mapa nao cria clientes.
- Mapa nao persiste cliente ativo.

Dependencia
- Mapa -> Cliente (somente filtro/contexto).

4) Cliente ↔ Ocorrencias
Regra de contrato
- Ocorrencia nao existe sem cliente.

Campos obrigatorios
- clientId (obrigatorio).

Campos opcionais
- fazendaId
- areaId

Dependencia
- Ocorrencias -> Cliente (forte).

Matriz de dependencias
- Agenda depende de Cliente: sim | Cliente depende de Agenda: nao
- Mapa depende de Cliente: sim | Cliente depende de Mapa: nao
- Ocorrencias depende de Cliente: sim | Cliente depende de Ocorrencias: nao
- Relatorios (futuro) depende de Cliente: sim | Cliente depende de Relatorios: nao

Regras de contexto global
- clientId pode ser passado por rota ou state.
- clientId nao deve ser salvo globalmente sem intencao explicita.
- clientId nao deve ser inferido automaticamente.

Antipadroes proibidos
- Ocorrencia sem clientId.
- Agenda assumindo cliente implicitamente.
- Mapa persistindo cliente ativo por conta propria.
- Cliente buscando dados globais.

Governanca de mudancas estruturais (baseline docs-baseline-1.0)
- Qualquer PR que altere estrutura, contrato ou relacionamento entre modulos deve atualizar este contrato.
- Atualize o indice do projeto quando aplicavel.
- O PR deve declarar qual contrato foi alterado e qual regra foi adicionada, removida ou endurecida.
- PRs estruturais sem atualizacao explicita do contrato devem ser reprovados.

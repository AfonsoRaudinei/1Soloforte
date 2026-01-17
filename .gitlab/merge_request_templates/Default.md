Regra de Governanca – Merge Requests Estruturais (GitLab)

A partir da baseline docs-baseline-1.0, todo Merge Request que altere estrutura, contrato ou relacionamento entre modulos do SoloForte DEVE:

Atualizar o arquivo:
/docs/CONTRATO_CLIENTE_AGENDA_MAPA_OCORRENCIAS.md

Atualizar o:
/docs/INDICE_PROJETO.md (se a estrutura documentada mudar)

Declarar explicitamente a alteracao no corpo do MR (secao "Validacao de Contrato").

Merge Requests que nao cumprirem esta regra serao reprovados, mesmo que:
- o codigo compile
- os testes passem
- a funcionalidade "pareca funcionar"

Esta regra e validada manualmente pelos reviewers.

Mudanca estrutural (exige update do contrato)
Exemplos diretos do SoloForte
- Tornar clientId obrigatorio ou opcional
- Alterar vinculo Cliente <-> Agenda / Mapa / Ocorrencias
- Mudar regra de modo global vs. modo cliente
- Criar novo modulo que dependa de Cliente
- Remover ou adicionar campo estrutural em:
  - Cliente
  - Ocorrencia
  - Area / entidade geografica
- Alterar quem e "dono" dos dados (ex: mapa persistindo algo)

Regra pratica
Se muda o significado do sistema, e estrutural.

Mudanca nao estrutural (nao exige contrato)
Exemplos do SoloForte
- Ajuste de layout
- Mudanca de cor, texto ou espaco
- Correcao de bug visual
- Refatoracao interna sem mudar regra
- Otimizacao de performance
- Renomear variavel interna sem impacto semantico

Regra pratica
Se muda so como o sistema faz, nao o que ele e, nao e estrutural.

Frase-mestra
Codigo muda facil. Contrato muda caro.
Por isso, toda mudanca estrutural deixa rastro documental.

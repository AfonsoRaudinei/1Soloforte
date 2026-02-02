import 'dart:convert';

class Relatorio {
  Meta meta;
  Consultor consultor;
  List<Avaliacao> avaliacoes;
  Conclusao? conclusao;
  ROI? roi;

  Relatorio({
    required this.meta,
    required this.consultor,
    required this.avaliacoes,
    this.conclusao,
    this.roi,
  });

  factory Relatorio.empty() {
    return Relatorio(
      meta: Meta(produtor: '', cidade: '', fazenda: '', talhao: '', tamanhoHa: 0),
      consultor: Consultor(nome: ''),
      avaliacoes: [],
    );
  }

  Map<String, dynamic> toJson() => {
    'meta': meta.toJson(),
    'consultor': consultor.toJson(),
    'avaliacoes': avaliacoes.map((a) => a.toJson()).toList(),
    'conclusao': conclusao?.toJson(),
    'roi': roi?.toJson(),
  };

  factory Relatorio.fromJson(Map<String, dynamic> json) {
    return Relatorio(
      meta: Meta.fromJson(json['meta']),
      consultor: Consultor.fromJson(json['consultor']),
      avaliacoes: (json['avaliacoes'] as List).map((a) => Avaliacao.fromJson(a)).toList(),
      conclusao: json['conclusao'] != null ? Conclusao.fromJson(json['conclusao']) : null,
      roi: json['roi'] != null ? ROI.fromJson(json['roi']) : null,
    );
  }
}

class Meta {
  String produtor;
  String cidade;
  String fazenda;
  String talhao;
  double tamanhoHa;
  String? logoBase64;

  Meta({
    required this.produtor,
    required this.cidade,
    required this.fazenda,
    required this.talhao,
    required this.tamanhoHa,
    this.logoBase64,
  });

  Map<String, dynamic> toJson() => {
    'produtor': produtor,
    'cidade': cidade,
    'fazenda': fazenda,
    'talhao': talhao,
    'tamanhoHa': tamanhoHa,
    'logoBase64': logoBase64,
  };

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      produtor: json['produtor'] ?? '',
      cidade: json['cidade'] ?? '',
      fazenda: json['fazenda'] ?? '',
      talhao: json['talhao'] ?? '',
      tamanhoHa: (json['tamanhoHa'] ?? 0).toDouble(),
      logoBase64: json['logoBase64'],
    );
  }
}

class Avaliacao {
  int id;
  int layout; // 1 ou 2
  bool colapsado;
  LadoAvaliacao ladoEsquerdo;
  LadoAvaliacao ladoDireito;

  Avaliacao({
    required this.id,
    required this.layout,
    required this.colapsado,
    required this.ladoEsquerdo,
    required this.ladoDireito,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'layout': layout,
    'colapsado': colapsado,
    'ladoEsquerdo': ladoEsquerdo.toJson(),
    'ladoDireito': ladoDireito.toJson(),
  };

  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['id'],
      layout: json['layout'],
      colapsado: json['colapsado'] ?? false,
      ladoEsquerdo: LadoAvaliacao.fromJson(json['ladoEsquerdo']),
      ladoDireito: LadoAvaliacao.fromJson(json['ladoDireito']),
    );
  }
}

class LadoAvaliacao {
  String titulo;
  String estadio;
  String anotacao;
  String? fotoBase64;

  LadoAvaliacao({
    required this.titulo,
    required this.estadio,
    required this.anotacao,
    this.fotoBase64,
  });

  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'estadio': estadio,
    'anotacao': anotacao,
    'fotoBase64': fotoBase64,
  };

  factory LadoAvaliacao.fromJson(Map<String, dynamic> json) {
    return LadoAvaliacao(
      titulo: json['titulo'] ?? '',
      estadio: json['estadio'] ?? '',
      anotacao: json['anotacao'] ?? '',
      fotoBase64: json['fotoBase64'],
    );
  }
}

class Consultor {
  String nome;
  String? fotoBase64;

  Consultor({
    required this.nome,
    this.fotoBase64,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'fotoBase64': fotoBase64,
  };

  factory Consultor.fromJson(Map<String, dynamic> json) {
    return Consultor(
      nome: json['nome'] ?? '',
      fotoBase64: json['fotoBase64'],
    );
  }
}

class Conclusao {
  String texto;

  Conclusao({required this.texto});

  Map<String, dynamic> toJson() => {'texto': texto};

  factory Conclusao.fromJson(Map<String, dynamic> json) {
    return Conclusao(texto: json['texto'] ?? '');
  }
}

class ROI {
  double investimento;
  double retorno;

  ROI({required this.investimento, required this.retorno});

  Map<String, dynamic> toJson() => {
    'investimento': investimento,
    'retorno': retorno,
  };

  factory ROI.fromJson(Map<String, dynamic> json) {
    return ROI(
      investimento: (json['investimento'] ?? 0).toDouble(),
      retorno: (json['retorno'] ?? 0).toDouble(),
    );
  }
}

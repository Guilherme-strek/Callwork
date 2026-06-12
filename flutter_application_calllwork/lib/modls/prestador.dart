class Prestador {
  final int id;
  final String nomePublico;
  final String categoria;
  final String cidade;
  final String estado;
  final String descricao;
  final bool meiVerificado;
  final double avaliacaoMedia;
  final int totalAvaliacoes;
  final double precoBase;
  final String tipoPreco;

  Prestador({
    required this.id,
    required this.nomePublico,
    required this.categoria,
    required this.cidade,
    required this.estado,
    required this.descricao,
    required this.meiVerificado,
    required this.avaliacaoMedia,
    required this.totalAvaliacoes,
    required this.precoBase,
    required this.tipoPreco,
  });

  factory Prestador.fromJson(Map<String, dynamic> json) {
    return Prestador(
      id: json['id'],
      nomePublico: json['nomePublico'],
      categoria: json['categoria'],
      cidade: json['cidade'],
      estado: json['estado'],
      descricao: json['descricao'] ?? '',
      meiVerificado: json['meiVerificado'] ?? false,
      avaliacaoMedia: double.parse(json['avaliacaoMedia'].toString()),
      totalAvaliacoes: json['totalAvaliacoes'] ?? 0,
      precoBase: double.parse(json['precoBase'].toString()),
      tipoPreco: json['tipoPreco'] ?? 'serviço',
    );
  }
}
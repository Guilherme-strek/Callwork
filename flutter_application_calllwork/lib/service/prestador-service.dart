import 'dart:convert';
import 'package:http/http.dart' as http;

import '../modls/prestador.dart';

class PrestadorService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/prestadores';

  Future<List<Prestador>> buscarPrestadores({
    String? q,
    String? cidade,
  }) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        if (q != null && q.isNotEmpty) 'q': q,
        if (cidade != null && cidade.isNotEmpty) 'cidade': cidade,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List dados = jsonDecode(utf8.decode(response.bodyBytes));

      return dados.map((item) => Prestador.fromJson(item)).toList();
    }

    throw Exception('Erro ao buscar prestadores');
  }
}
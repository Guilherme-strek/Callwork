import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

const _base = 'http://10.0.2.2:8080/api'; // Android emulator → localhost

class ApiService {
  static const _headers = {'Content-Type': 'application/json'};

  Future<List<ProfessionalSummary>> search(String q, String category, bool meiOnly) async {
    final uri = Uri.parse('$_base/professionals').replace(queryParameters: {
      'q': q, 'category': category, 'meiOnly': '$meiOnly',
    });
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Erro ao buscar');
    final list = jsonDecode(res.body) as List;
    return list.map((e) => ProfessionalSummary.fromJson(e)).toList();
  }

  Future<ProfessionalDetail> getById(int id) async {
    final res = await http.get(Uri.parse('$_base/professionals/$id'));
    if (res.statusCode != 200) throw Exception('Profissional não encontrado');
    return ProfessionalDetail.fromJson(jsonDecode(res.body));
  }

  Future<ProfessionalDetail> create(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$_base/professionals'),
      headers: _headers, body: jsonEncode(data),
    );
    if (res.statusCode != 200 && res.statusCode != 201) throw Exception('Erro ao cadastrar');
    return ProfessionalDetail.fromJson(jsonDecode(res.body));
  }

  Future<ServiceRequest> requestService(int professionalId, Map<String, dynamic> payload) async {
    final res = await http.post(
      Uri.parse('$_base/professionals/$professionalId/requests'),
      headers: _headers, body: jsonEncode(payload),
    );
    if (res.statusCode != 200 && res.statusCode != 201) throw Exception('Erro ao solicitar');
    return ServiceRequest.fromJson(jsonDecode(res.body));
  }

  Future<List<ServiceRequest>> listRequests(int professionalId) async {
    final res = await http.get(Uri.parse('$_base/professionals/$professionalId/requests'));
    if (res.statusCode != 200) throw Exception('Erro ao listar pedidos');
    final list = jsonDecode(res.body) as List;
    return list.map((e) => ServiceRequest.fromJson(e)).toList();
  }

  Future<ServiceRequest> updateStatus(int requestId, String status) async {
    final uri = Uri.parse('$_base/requests/$requestId/status').replace(queryParameters: {'value': status});
    final res = await http.patch(uri, headers: _headers);
    if (res.statusCode != 200) throw Exception('Erro ao atualizar status');
    return ServiceRequest.fromJson(jsonDecode(res.body));
  }
}

import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/theme.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _api = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _role = TextEditingController();
  final _city = TextEditingController();
  final _cnpj = TextEditingController();
  final _about = TextEditingController();
  String _categoria = 'Limpeza';
  bool _enviando = false;
  String _erro = '';

  final _categorias = ['Limpeza', 'Reformas', 'Tecnologia', 'Beleza'];

  bool get _cnpjValido => _cnpj.text.replaceAll(RegExp(r'\D'), '').length == 14;

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _enviando = true; _erro = ''; });
    try {
      final criado = await _api.create({
        'name': _name.text,
        'role': _role.text,
        'category': _categoria,
        'city': _city.text,
        'cnpj': _cnpj.text.isEmpty ? null : _cnpj.text,
        'about': _about.text,
      });
      if (mounted) Navigator.pushReplacementNamed(context, '/perfil', arguments: criado.id);
    } catch (_) {
      if (mounted) setState(() { _erro = 'Não foi possível concluir o cadastro. Tente novamente.'; _enviando = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call Work')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(children: List.generate(3, (i) => Expanded(
              child: Container(
                height: 4, margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                decoration: BoxDecoration(
                  color: i == 0 ? kBrand700 : i == 1 ? kBrand500 : kLine,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ))),
            const SizedBox(height: 20),
            const Text('Dados profissionais', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Esses dados aparecem no seu perfil público.', style: TextStyle(color: kInkSoft, fontSize: 13)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nome completo'),
              validator: (v) => (v == null || v.isEmpty) ? 'Informe seu nome.' : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: DropdownButtonFormField<String>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _categoria = v!),
              )),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(
                controller: _role,
                decoration: const InputDecoration(labelText: 'Função'),
                validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório.' : null,
              )),
            ]),
            const SizedBox(height: 12),
            TextFormField(
              controller: _city,
              decoration: const InputDecoration(labelText: 'Cidade de atuação'),
              validator: (v) => (v == null || v.isEmpty) ? 'Informe sua cidade.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cnpj,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'CNPJ / MEI (opcional)',
                hintText: '00.000.000/0000-00',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _cnpjValido ? kBrand500 : kLine, width: 1.5),
                ),
                fillColor: _cnpjValido ? kBrand50 : Colors.white,
                suffixIcon: _cnpjValido ? const Icon(Icons.check_circle, color: kBrand500) : null,
                helperText: _cnpjValido ? '✓ MEI válido — você será verificado' : null,
                helperStyle: const TextStyle(color: kBrand700, fontWeight: FontWeight.w600),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _about,
              decoration: const InputDecoration(labelText: 'Sobre você'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            if (_erro.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_erro, style: const TextStyle(color: Colors.red, fontSize: 13), textAlign: TextAlign.center),
              ),
            ElevatedButton(
              onPressed: _enviando ? null : _enviar,
              child: _enviando
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Concluir cadastro'),
            ),
            const SizedBox(height: 12),
            const Text('Etapa 2 de 3', textAlign: TextAlign.center, style: TextStyle(color: kInkSoft, fontSize: 12)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose(); _role.dispose(); _city.dispose();
    _cnpj.dispose(); _about.dispose();
    super.dispose();
  }
}

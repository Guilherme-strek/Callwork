import 'package:flutter/material.dart';
import '../app_theme.dart';

class PerfilUsuarioScreen extends StatelessWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _buildNavBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepper(),
                  const SizedBox(height: 14),
                  const Text(
                    'Dados profissionais',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: kText),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Esses dados aparecem no seu perfil público.',
                    style: TextStyle(fontSize: 12, color: kMuted),
                  ),
                  const SizedBox(height: 14),
                  _buildField('Nome completo', 'Ana Moura'),
                  Row(
                    children: [
                      Expanded(child: _buildField('Categoria', 'Limpeza')),
                      const SizedBox(width: 10),
                      Expanded(child: _buildField('Função', 'Diarista')),
                    ],
                  ),
                  _buildField('Cidade de atuação', 'Maringá, PR'),
                  _buildMeiField('CNPJ / MEI (opcional)', '12.345.678/0001-90'),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBrand,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Concluir cadastro',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      color: kBrand,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 14),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(color: kBrand500, borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.phone, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Text(
            'Call Work',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        Expanded(child: Container(height: 3, decoration: BoxDecoration(color: kBrand, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(width: 4),
        Expanded(child: Container(height: 3, decoration: BoxDecoration(color: kBrand500, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(width: 4),
        Expanded(child: Container(height: 3, decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(2)))),
      ],
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: kMuted)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFB4B2A9), width: 0.5),
            ),
            child: Text(value, style: const TextStyle(fontSize: 13, color: kText)),
          ),
        ],
      ),
    );
  }

  Widget _buildMeiField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: kMuted)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: kBrand50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kBrand500, width: 0.5),
            ),
            child: Text(value, style: const TextStyle(fontSize: 13, color: kText)),
          ),
        ],
      ),
    );
  }
}

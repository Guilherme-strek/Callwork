import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../modls/prestador.dart';
import 'mensagens_screen.dart';

class PerfilPrestadorScreen extends StatelessWidget {
  final Prestador prestador;

  const PerfilPrestadorScreen({super.key, required this.prestador});

  String getIniciais(String nome) {
    final partes = nome.trim().split(' ');
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServicos(),
                  const SizedBox(height: 14),
                  _buildBotaoMensagem(context),
                  const SizedBox(height: 14),
                  _buildAvaliacoes(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: kBrand,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              '← Voltar à busca',
              style: TextStyle(fontSize: 12, color: kBrand300),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(color: kBrand500, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  getIniciais(prestador.nomePublico),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            prestador.nomePublico,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                        if (prestador.meiVerificado) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: kBrand300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '✓ MEI',
                              style: TextStyle(fontSize: 9, color: kBrand, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${prestador.categoria} · ${prestador.cidade}, ${prestador.estado}',
                      style: const TextStyle(fontSize: 12, color: kBrand300),
                    ),
                    Text(
                      '★ ${prestador.avaliacaoMedia} · ${prestador.totalAvaliacoes} avaliações',
                      style: const TextStyle(fontSize: 12, color: kBrand300),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Serviços e preços',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kText),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kBorder, width: 0.5),
          ),
          child: Column(
            children: [
              _svcRow('Limpeza residencial', prestador.precoBase),
              _svcRow('Limpeza pós-obra', prestador.precoBase * 1.5),
              _svcRow('Limpeza comercial', prestador.precoBase * 1.2),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
            child: const Text('📅 Solicitar serviço', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }

  Widget _svcRow(String nome, double valor) {
    final isLast = nome == 'Limpeza comercial';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(nome, style: const TextStyle(fontSize: 13, color: kText))),
          Text(
            'R\$ ${valor.toStringAsFixed(0)},00',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kText),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoMensagem(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MensagensScreen(prestador: prestador)),
        ),
        icon: const Icon(Icons.chat_bubble_outline, size: 16),
        label: const Text('Enviar mensagem'),
        style: OutlinedButton.styleFrom(
          foregroundColor: kBrand,
          side: const BorderSide(color: Color(0xFF0F6E56)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildAvaliacoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avaliações',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kText),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kBorder, width: 0.5),
          ),
          child: Column(
            children: [
              _reviewRow('Maria Lima', 'Excelente serviço, pontual e cuidadosa!'),
              _reviewRow('Pedro Costa', 'Muito profissional, recomendo.', isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reviewRow(String nome, String texto, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '★★★★★  $nome',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kText),
          ),
          const SizedBox(height: 3),
          Text(texto, style: const TextStyle(fontSize: 12, color: kMuted)),
        ],
      ),
    );
  }
}

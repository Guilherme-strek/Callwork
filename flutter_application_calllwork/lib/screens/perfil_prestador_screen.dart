import 'package:flutter/material.dart';

import '../modls/prestador.dart';
import 'mensagens_screen.dart';

class PerfilPrestadorScreen extends StatelessWidget {
  final Prestador prestador;

  const PerfilPrestadorScreen({
    super.key,
    required this.prestador,
  });

  String getIniciais(String nome) {
    final partes = nome.trim().split(' ');

    if (partes.length == 1) {
      return partes.first.substring(0, 1).toUpperCase();
    }

    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F5),
        elevation: 0,
        title: const Text('Perfil do prestador'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 18),
            _buildStats(),
            const SizedBox(height: 18),
            _buildAvaliacoes(),
            const SizedBox(height: 18),
            _buildServicos(),
          ],
        ),
      ),
      bottomNavigationBar: _buildActions(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: const Color(0xFF085041),
            child: Text(
              getIniciais(prestador.nomePublico),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            prestador.nomePublico,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '${prestador.categoria} · ${prestador.cidade}, ${prestador.estado}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            prestador.meiVerificado
                ? '✔ MEI verificado'
                : 'Profissional autônomo',
            style: TextStyle(
              color: prestador.meiVerificado
                  ? const Color(0xFF047857)
                  : const Color(0xFF6B7280),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _statCard('Avaliação', prestador.avaliacaoMedia.toString(), Icons.star),
        const SizedBox(width: 10),
        _statCard('Serviços', prestador.totalAvaliacoes.toString(), Icons.work),
        const SizedBox(width: 10),
        _statCard('Resposta', '~1h', Icons.schedule),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF085041)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvaliacoes() {
    return _section(
      title: 'Avaliações recentes',
      children: const [
        Text('★★★★★ Pontual e caprichosa. — Padaria do Bairro'),
        SizedBox(height: 10),
        Text('★★★★★ Ótimo trabalho no escritório. — TechLocal MEI'),
      ],
    );
  }

  Widget _buildServicos() {
    return _section(
      title: 'Serviços oferecidos',
      children: [
        _serviceRow('Limpeza residencial', 120),
        _serviceRow('Limpeza pós-obra', 180),
        _serviceRow('Limpeza comercial', 150),
      ],
    );
  }

  Widget _serviceRow(String nome, double valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              nome,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            'R\$ ${valor.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_month),
              label: const Text('Solicitar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF085041),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MensagensScreen(prestador: prestador),
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Mensagem'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF085041),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../app_theme.dart';

class PainelScreen extends StatelessWidget {
  const PainelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow(),
                  const SizedBox(height: 20),
                  _buildPedidos(),
                  const SizedBox(height: 20),
                  _buildAtividade(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: kBrand,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra superior
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: kBrand500,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.phone, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Call Work',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(color: kBrand500, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Text(
                  'AM',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Saudação
          const Text(
            'Olá, Ana 👋',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 2),
          const Text(
            'Resumo de junho',
            style: TextStyle(fontSize: 13, color: kBrand300),
          ),

          const SizedBox(height: 16),

          // Cartão de ganhos em destaque
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kBrand500,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Ganhos do mês',
                      style: TextStyle(fontSize: 12, color: kBrand300),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'R\$ 2.480',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kBrand500,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '+12%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    return Row(
      children: [
        _statCard(Icons.work_outline, '14', 'Serviços'),
        const SizedBox(width: 10),
        _statCard(Icons.star_outline, '4,9', 'Avaliação'),
        const SizedBox(width: 10),
        _statCard(Icons.timer_outlined, '98%', 'Resposta'),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder, width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: kBrand, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kText),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: kMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPedidos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Pedidos recebidos',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kText),
            ),
            const Spacer(),
            Text(
              'Ver todos',
              style: const TextStyle(fontSize: 12, color: kBrand500),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _pedidoCard(
          initials: 'ED',
          empresa: 'Empresa Demo',
          servico: 'Limpeza residencial',
          data: 'Hoje, 14h',
          confirmado: false,
        ),
        _pedidoCard(
          initials: 'ED',
          empresa: 'Empresa Demo',
          servico: 'Limpeza pós-obra',
          data: 'Amanhã, 09h',
          confirmado: true,
        ),
        _pedidoCard(
          initials: 'ML',
          empresa: 'Maria Lima',
          servico: 'Limpeza comercial',
          data: 'Sex, 10h',
          confirmado: true,
        ),
      ],
    );
  }

  Widget _pedidoCard({
    required String initials,
    required String empresa,
    required String servico,
    required String data,
    required bool confirmado,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: kBrand50, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kBrand),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  empresa,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kText),
                ),
                const SizedBox(height: 2),
                Text(servico, style: const TextStyle(fontSize: 12, color: kMuted)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 11, color: kMuted),
                    const SizedBox(width: 3),
                    Text(data, style: const TextStyle(fontSize: 11, color: kMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: confirmado ? kBrand50 : const Color(0xFFFAEEDA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              confirmado ? 'Confirmado' : 'Pendente',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: confirmado ? kBrand : const Color(0xFF633806),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAtividade() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avaliações recentes',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kText),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder, width: 0.5),
          ),
          child: Column(
            children: [
              _avaliacaoRow('Maria Lima', 'Excelente serviço, pontual e cuidadosa!', '5,0'),
              const Divider(color: kBorder, thickness: 0.5, height: 20),
              _avaliacaoRow('Pedro Costa', 'Muito profissional, recomendo.', '5,0'),
              const Divider(color: kBorder, thickness: 0.5, height: 20),
              _avaliacaoRow('TechLocal MEI', 'Ótimo trabalho no escritório.', '4,8'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avaliacaoRow(String nome, String texto, String nota) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: kBrand50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '★ $nota',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kBrand),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kText)),
              const SizedBox(height: 2),
              Text(texto, style: const TextStyle(fontSize: 12, color: kMuted)),
            ],
          ),
        ),
      ],
    );
  }
}

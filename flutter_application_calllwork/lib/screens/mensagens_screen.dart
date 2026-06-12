import 'package:flutter/material.dart';

import '../modls/prestador.dart';

class MensagensScreen extends StatelessWidget {
  final Prestador prestador;

  const MensagensScreen({
    super.key,
    required this.prestador,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF085041),
              child: Text(
                prestador.nomePublico.substring(0, 1),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prestador.nomePublico,
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(
                  '● online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF047857),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _message(
                  text: 'Oi Ana! Você atende limpeza comercial na sexta à tarde?',
                  isMe: true,
                ),
                _message(
                  text: 'Olá! Atendo sim 😊 Para a padaria, fica R\$ 150.',
                  isMe: false,
                ),
                _proposalCard(),
                _message(
                  text: 'Perfeito, vou aceitar agora. Obrigado!',
                  isMe: true,
                ),
              ],
            ),
          ),
          _inputArea(),
        ],
      ),
    );
  }

  Widget _message({
    required String text,
    required bool isMe,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF085041) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }

  Widget _proposalCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F8F1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1F1E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROPOSTA DE SERVIÇO',
            style: TextStyle(
              color: Color(0xFF085041),
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Limpeza comercial',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text('R\$ 150'),
          const Text('Sexta, 14h · ~3h de duração'),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF085041),
                foregroundColor: Colors.white,
              ),
              child: const Text('Aceitar proposta'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Escreva uma mensagem...',
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
            color: const Color(0xFF085041),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../modls/prestador.dart';

class MensagensScreen extends StatelessWidget {
  final Prestador prestador;

  const MensagensScreen({super.key, required this.prestador});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBrand,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: kBrand500, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                prestador.nomePublico.substring(0, 1),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prestador.nomePublico,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                const Text(
                  '● online',
                  style: TextStyle(fontSize: 11, color: kBrand300),
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
              padding: const EdgeInsets.all(14),
              children: [
                _message(text: 'Oi Ana! Você atende limpeza comercial na sexta à tarde?', isMe: true),
                _message(text: 'Olá! Atendo sim 😊 Para a padaria, fica R\$ 150.', isMe: false),
                _proposalCard(),
                _message(text: 'Perfeito, vou aceitar agora. Obrigado!', isMe: true),
              ],
            ),
          ),
          _inputArea(),
        ],
      ),
    );
  }

  Widget _message({required String text, required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? kBrand : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isMe ? null : Border.all(color: kBorder, width: 0.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isMe ? Colors.white : kText,
          ),
        ),
      ),
    );
  }

  Widget _proposalCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kBrand50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBrand300, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROPOSTA DE SERVIÇO',
            style: TextStyle(color: kBrand, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          const Text('Limpeza comercial', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kText)),
          const SizedBox(height: 4),
          const Text('R\$ 150', style: TextStyle(fontSize: 13, color: kText)),
          const Text('Sexta, 14h · ~3h de duração', style: TextStyle(fontSize: 12, color: kMuted)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kBrand,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                elevation: 0,
              ),
              child: const Text('Aceitar proposta', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: kBgMuted,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: kBorder, width: 0.5),
              ),
              child: const Text(
                'Escreva uma mensagem...',
                style: TextStyle(fontSize: 13, color: kMuted),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(color: kBrand, shape: BoxShape.circle),
            child: const Icon(Icons.send, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

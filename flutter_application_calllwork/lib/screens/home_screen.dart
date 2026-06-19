import 'package:flutter/material.dart';
import '../app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  _buildHero(),
                  const SizedBox(height: 14),
                  _buildStats(),
                  const SizedBox(height: 14),
                  _buildDestaques(),
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
            decoration: BoxDecoration(
              color: kBrand500,
              borderRadius: BorderRadius.circular(6),
            ),
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

  Widget _buildHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: kText, height: 1.3),
            children: [
              TextSpan(text: 'O serviço que você precisa, '),
              TextSpan(text: 'perto de você.', style: TextStyle(color: kBrand)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Microempreendedores e autônomos da sua região.',
          style: TextStyle(fontSize: 13, color: kMuted, height: 1.5),
        ),
        const SizedBox(height: 14),
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
            child: const Text('Buscar serviços', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: kBrand,
              side: const BorderSide(color: Color(0xFF0F6E56)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Sou profissional', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _statChip('12k+', 'Profissionais'),
        const SizedBox(width: 8),
        _statChip('85k', 'Serviços'),
        const SizedBox(width: 8),
        _statChip('4,8★', 'Avaliação'),
      ],
    );
  }

  Widget _statChip(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: kBrand50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              val,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: kBrand),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF0F6E56)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestaques() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Destaques',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kText),
        ),
        const SizedBox(height: 8),
        _proCard('AM', 'Ana Moura · Diarista', '★ 4,9 · Maringá, PR', true),
        _proCard('CS', 'Carlos Silva · Eletricista', '★ 4,7 · Maringá, PR', true),
      ],
    );
  }

  Widget _proCard(String initials, String name, String sub, bool mei) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(color: kBrand50, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kBrand),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kText)),
                Text(sub, style: const TextStyle(fontSize: 11, color: kMuted)),
              ],
            ),
          ),
          if (mei)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: kBrand50, borderRadius: BorderRadius.circular(6)),
              child: const Text('✓ MEI', style: TextStyle(fontSize: 10, color: kBrand)),
            ),
        ],
      ),
    );
  }
}

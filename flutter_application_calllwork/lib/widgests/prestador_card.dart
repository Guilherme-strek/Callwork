import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../modls/prestador.dart';
import '../screens/perfil_prestador_screen.dart';

class PrestadorCard extends StatelessWidget {
  final Prestador prestador;

  const PrestadorCard({super.key, required this.prestador});

  String getIniciais(String nome) {
    final partes = nome.trim().split(' ');
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PerfilPrestadorScreen(prestador: prestador)),
      ),
      child: Container(
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
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: kBrand50, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                getIniciais(prestador.nomePublico),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kBrand),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prestador.nomePublico,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kText),
                  ),
                  Text(
                    '${prestador.categoria} · ★ ${prestador.avaliacaoMedia} · ${prestador.totalAvaliacoes} aval.',
                    style: const TextStyle(fontSize: 11, color: kMuted),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: prestador.meiVerificado ? kBrand50 : kBgMuted,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                prestador.meiVerificado ? '✓ MEI' : 'Autônomo',
                style: TextStyle(
                  fontSize: 10,
                  color: prestador.meiVerificado ? kBrand : kMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

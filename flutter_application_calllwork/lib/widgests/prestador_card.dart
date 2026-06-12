import 'package:flutter/material.dart';

import '../modls/prestador.dart';
import '../screens/perfil_prestador_screen.dart';

class PrestadorCard extends StatelessWidget {
  final Prestador prestador;

  const PrestadorCard({
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
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PerfilPrestadorScreen(prestador: prestador),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF085041),
              child: Text(
                getIniciais(prestador.nomePublico),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prestador.nomePublico,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    prestador.categoria,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '★ ${prestador.avaliacaoMedia} · ${prestador.totalAvaliacoes} avaliações',
                    style: const TextStyle(
                      color: Color(0xFF92400E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    prestador.meiVerificado
                        ? '✔ MEI verificado'
                        : 'Autônomo',
                    style: TextStyle(
                      color: prestador.meiVerificado
                          ? const Color(0xFF047857)
                          : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'a partir de R\$ ${prestador.precoBase.toStringAsFixed(0)}/${prestador.tipoPreco}',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
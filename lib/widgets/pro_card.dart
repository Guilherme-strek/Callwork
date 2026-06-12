import 'package:flutter/material.dart';
import '../core/models.dart';
import '../core/theme.dart';

class ProCard extends StatelessWidget {
  final ProfessionalSummary pro;
  final VoidCallback onTap;

  const ProCard({super.key, required this.pro, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kLine),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24, backgroundColor: kBrand50,
              child: Text(pro.initials, style: const TextStyle(color: kBrand900, fontWeight: FontWeight.w800, fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pro.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text('${pro.role} · ${pro.city}', style: const TextStyle(color: kInkSoft, fontSize: 12)),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFBA7517), size: 14),
                    const SizedBox(width: 3),
                    Text('${pro.rating}  ·  ${pro.reviewsCount} aval.', style: const TextStyle(color: kInkSoft, fontSize: 12)),
                  ]),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Badge(pro.meiVerified ? '✓ MEI' : 'Autônomo', pro.meiVerified ? kBrand50 : kBg, pro.meiVerified ? kBrand700 : kInkSoft),
                if (pro.startingPrice != null) ...[
                  const SizedBox(height: 5),
                  Text(pro.startingPrice!, style: const TextStyle(color: kBrand700, fontWeight: FontWeight.w800, fontSize: 12)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg, fg;
  const _Badge(this.label, this.bg, this.fg);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(7)),
    child: Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
  );
}

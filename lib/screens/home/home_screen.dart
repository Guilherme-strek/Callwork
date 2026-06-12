import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../widgets/pro_card.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiService();
  List<ProfessionalSummary> _destaques = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _api.search('', 'Todos', false).then((list) {
      if (mounted) setState(() { _destaques = list.take(4).toList(); _loading = false; });
    }).catchError((_) { if (mounted) setState(() => _loading = false); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero()),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([
              _SectionTitle('Em destaque'),
              const SizedBox(height: 10),
              if (_loading) const Center(child: CircularProgressIndicator(color: kBrand500)),
              ..._destaques.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ProCard(pro: p, onTap: () => Navigator.pushNamed(context, '/perfil', arguments: p.id)),
              )),
              const SizedBox(height: 4),
              OutlinedButton(
                onPressed: () => widget.onNavigate(1),
                child: const Text('Ver todos os profissionais →'),
              ),
              const SizedBox(height: 24),
              _SectionTitle('Como funciona'),
              const SizedBox(height: 10),
              ...[
                ('🔍', 'Busque', 'Encontre profissionais por categoria e localização, com avaliações reais.'),
                ('💬', 'Negocie', 'Converse direto e receba uma proposta de serviço transparente.'),
                ('⭐', 'Avalie', 'Contrate com segurança e avalie ao final para ajudar a comunidade.'),
              ].map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.$1, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.$2, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(s.$3, style: const TextStyle(color: kInkSoft, fontSize: 13, height: 1.5)),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              )),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: kBrand900, borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  const Text('Faça parte da economia local', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17), textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  const Text('Crie seu perfil e comece a receber pedidos.', style: TextStyle(color: kBrand300, fontSize: 13), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => widget.onNavigate(3),
                    style: ElevatedButton.styleFrom(backgroundColor: kBrand500),
                    child: const Text('Criar perfil grátis'),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
            ])),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() => Container(
    color: kBrand900,
    padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(width: 28, height: 28, decoration: BoxDecoration(color: kBrand500, borderRadius: BorderRadius.circular(8)), child: const Center(child: Text('☎', style: TextStyle(fontSize: 14)))),
          const SizedBox(width: 8),
          const Text('Call Work', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
        ]),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: kBrand50, borderRadius: BorderRadius.circular(8)),
          child: const Text('✓ +12 mil profissionais verificados', style: TextStyle(color: kBrand700, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 14),
        RichText(text: const TextSpan(
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.2, color: Colors.white),
          children: [
            TextSpan(text: 'O serviço que você precisa, '),
            TextSpan(text: 'perto de você.', style: TextStyle(color: kBrand300)),
          ],
        )),
        const SizedBox(height: 10),
        const Text('Conecte-se a autônomos e microempreendedores da sua região.', style: TextStyle(color: kBrand300, fontSize: 13, height: 1.5)),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: ElevatedButton(
            onPressed: () => widget.onNavigate(1),
            child: const Text('Buscar serviços'),
          )),
          const SizedBox(width: 10),
          Expanded(child: OutlinedButton(
            onPressed: () => widget.onNavigate(3),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38)),
            child: const Text('Sou profissional'),
          )),
        ]),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            for (final s in [('12k+', 'Profissionais'), ('85k', 'Serviços'), ('4,8★', 'Avaliação')])
              Expanded(child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(border: Border(right: s.$1 == '4,8★' ? BorderSide.none : const BorderSide(color: Colors.white12))),
                child: Column(children: [
                  Text(s.$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
                  const SizedBox(height: 2),
                  Text(s.$2, style: const TextStyle(color: kBrand300, fontSize: 11)),
                ]),
              )),
          ]),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kInkMute, letterSpacing: .8),
  );
}

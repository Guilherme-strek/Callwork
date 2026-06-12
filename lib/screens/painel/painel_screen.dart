import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class PainelScreen extends StatefulWidget {
  const PainelScreen({super.key});

  @override
  State<PainelScreen> createState() => _PainelScreenState();
}

class _PainelScreenState extends State<PainelScreen> {
  final _api = ApiService();
  List<ServiceRequest> _pedidos = [];
  bool _loading = true;

  final _kpis = [
    ('Ganhos do mês', 'R\$ 2.480', '▲ 18% vs maio', kBrand700),
    ('Serviços', '14', 'concluídos', kInkSoft),
    ('Avaliação', '4,9★', '132 no total', kInkSoft),
    ('Resposta', '98%', '~1h em média', kInkSoft),
  ];

  final _servicos = [
    ('Limpeza residencial', true),
    ('Limpeza pós-obra', true),
    ('Limpeza comercial', false),
  ];

  @override
  void initState() {
    super.initState();
    _api.listRequests(1).then((list) {
      if (mounted) setState(() { _pedidos = list; _loading = false; });
    }).catchError((_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  Future<void> _atualizar(ServiceRequest r, String status) async {
    try {
      final updated = await _api.updateStatus(r.id, status);
      if (mounted) setState(() => r.status = updated.status);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao atualizar.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Work'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(radius: 16, backgroundColor: kBrand500, child: const Text('AM', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Olá, Ana 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          const Text('Resumo de junho', style: TextStyle(color: kInkSoft, fontSize: 13)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.6,
            children: _kpis.map((k) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kLine),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(k.$1, style: const TextStyle(color: kInkSoft, fontSize: 11, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(k.$2, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                  const SizedBox(height: 2),
                  Text(k.$3, style: TextStyle(color: k.$4, fontSize: 11)),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SecTitle('Pedidos recebidos'),
                const SizedBox(height: 10),
                if (_loading) const Center(child: CircularProgressIndicator(color: kBrand500)),
                if (!_loading && _pedidos.isEmpty)
                  const Text('Nenhum pedido ainda.', style: TextStyle(color: kInkSoft, fontSize: 13)),
                ..._pedidos.map((r) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.requesterName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(r.serviceTitle, style: const TextStyle(color: kInkSoft, fontSize: 12)),
                          ],
                        )),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _StatusBadge(r.status),
                            if (r.status == 'PENDING') ...[
                              const SizedBox(height: 6),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                _SmallBtn('Aceitar', kBrand500, Colors.white, () => _atualizar(r, 'CONFIRMED')),
                                const SizedBox(width: 5),
                                _SmallBtn('Recusar', Colors.white, kInk, () => _atualizar(r, 'DECLINED'), border: true),
                              ]),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (r != _pedidos.last) const Divider(height: 1),
                ])),
              ],
            ),
          )),
          const SizedBox(height: 12),
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SecTitle('Meus serviços'),
                const SizedBox(height: 10),
                ..._servicos.map((s) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.$1, style: const TextStyle(fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: s.$2 ? kBrand50 : kBg,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(s.$2 ? 'Ativo' : 'Pausado', style: TextStyle(color: s.$2 ? kBrand700 : kInkSoft, fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  if (s != _servicos.last) const Divider(height: 1),
                ])),
              ],
            ),
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SecTitle extends StatelessWidget {
  final String text;
  const _SecTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kInkMute, letterSpacing: .7),
  );
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);
  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      'CONFIRMED' => ('Confirmado', kBrand50, kBrand700),
      'DECLINED'  => (const Color(0xFFF1EFE8), kBg, kInkSoft),
      _            => ('Pendente', const Color(0xFFFAEEDA), const Color(0xFF854F0B)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(7)),
      child: Text(label == 'Confirmado' ? 'Confirmado' : label == 'Pendente' ? 'Pendente' : 'Recusado', style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final String label;
  final Color bg, fg;
  final VoidCallback onTap;
  final bool border;
  const _SmallBtn(this.label, this.bg, this.fg, this.onTap, {this.border = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(8),
        border: border ? Border.all(color: kLine) : null,
      ),
      child: Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    ),
  );
}

import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class PerfilScreen extends StatefulWidget {
  final int professionalId;
  const PerfilScreen({super.key, required this.professionalId});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _api = ApiService();
  ProfessionalDetail? _pro;
  bool _loading = true, _erro = false, _enviando = false, _enviado = false;

  @override
  void initState() {
    super.initState();
    _api.getById(widget.professionalId).then((p) {
      if (mounted) { setState(() { _pro = p; _loading = false; }); }
    }).catchError((_) {
      if (mounted) setState(() { _erro = true; _loading = false; });
    });
  }

  Future<void> _solicitar() async {
    if (_pro == null || _enviado) return;
    setState(() => _enviando = true);
    try {
      await _api.requestService(_pro!.id, {
        'requesterName': 'Cliente App',
        'serviceTitle': _pro!.services.isNotEmpty ? _pro!.services.first.title : 'Serviço',
        'message': 'Tenho interesse neste serviço.',
      });
      if (mounted) setState(() { _enviado = true; _enviando = false; });
    } catch (_) {
      if (mounted) { setState(() => _enviando = false); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao enviar solicitação.'))); }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(title: const Text('Perfil')), body: const Center(child: CircularProgressIndicator(color: kBrand500)));
    if (_erro || _pro == null) return Scaffold(appBar: AppBar(title: const Text('Perfil')), body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, size: 48, color: kInkMute),
      const SizedBox(height: 12),
      const Text('Profissional não encontrado.', style: TextStyle(color: kInkSoft)),
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('← Voltar')),
    ])));

    final p = _pro!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: kBrand900,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: kBrand900,
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34, backgroundColor: kBrand500,
                      child: Text(p.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(children: [
                          Flexible(child: Text(p.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18))),
                          if (p.meiVerified) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(color: kBrand50, borderRadius: BorderRadius.circular(6)),
                              child: const Text('✓ MEI', style: TextStyle(color: kBrand700, fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ]),
                        const SizedBox(height: 4),
                        Text('${p.role} · ${p.city}', style: const TextStyle(color: kBrand300, fontSize: 13)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFBA7517), size: 14),
                          const SizedBox(width: 3),
                          Text('${p.rating}  ·  ${p.reviewsCount} avaliações  ·  ~1h', style: const TextStyle(color: kBrand300, fontSize: 12)),
                        ]),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Card(child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _SecTitle('Sobre'),
                  const SizedBox(height: 8),
                  Text(p.about, style: const TextStyle(color: kInkSoft, fontSize: 13, height: 1.6)),
                ]),
              )),
              const SizedBox(height: 12),
              Card(child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _SecTitle('Serviços e preços'),
                  const SizedBox(height: 8),
                  ...p.services.map((s) => Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Flexible(child: Text(s.title, style: const TextStyle(fontSize: 14))),
                        Text(s.price, style: const TextStyle(color: kBrand700, fontWeight: FontWeight.w800, fontSize: 14)),
                      ]),
                    ),
                    if (s != p.services.last) const Divider(height: 1),
                  ])),
                  if (p.services.isEmpty) const Text('Sem serviços cadastrados.', style: TextStyle(color: kInkSoft, fontSize: 13)),
                ]),
              )),
              const SizedBox(height: 12),
              if (_enviado)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: kBrand50, borderRadius: BorderRadius.circular(12), border: Border.all(color: kBrand100)),
                  child: const Row(children: [
                    Icon(Icons.check_circle, color: kBrand700, size: 20),
                    SizedBox(width: 8),
                    Flexible(child: Text('Solicitação enviada! O profissional verá no painel.', style: TextStyle(color: kBrand700, fontWeight: FontWeight.w600, fontSize: 13))),
                  ]),
                )
              else
                ElevatedButton.icon(
                  onPressed: _enviando ? null : _solicitar,
                  icon: _enviando ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('📅', style: TextStyle(fontSize: 16)),
                  label: Text(_enviando ? 'Enviando...' : 'Solicitar serviço'),
                ),
              const SizedBox(height: 12),
              Card(child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _SecTitle('Atendimento'),
                  const SizedBox(height: 10),
                  _InfoRow(Icons.location_on_outlined, '${p.city} (até 20 km)'),
                  const SizedBox(height: 8),
                  const _InfoRow(Icons.calendar_today_outlined, 'Seg a sáb · 8h às 18h'),
                ]),
              )),
              const SizedBox(height: 12),
              Card(child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _SecTitle('Avaliações (${p.reviews.length})'),
                  const SizedBox(height: 8),
                  ...p.reviews.map((r) => Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFBA7517), size: 14),
                          const SizedBox(width: 4),
                          Text(r.author, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        ]),
                        const SizedBox(height: 4),
                        Text(r.comment, style: const TextStyle(color: kInkSoft, fontSize: 13, height: 1.5)),
                      ]),
                    ),
                    if (r != p.reviews.last) const Divider(height: 1),
                  ])),
                  if (p.reviews.isEmpty) const Text('Ainda sem avaliações.', style: TextStyle(color: kInkSoft, fontSize: 13)),
                ]),
              )),
              const SizedBox(height: 20),
            ])),
          ),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 16, color: kInkSoft),
    const SizedBox(width: 8),
    Text(text, style: const TextStyle(color: kInkSoft, fontSize: 13)),
  ]);
}

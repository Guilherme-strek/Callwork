import 'package:flutter/material.dart';
import '../../core/api_service.dart';
import '../../core/models.dart';
import '../../core/theme.dart';
import '../../widgets/pro_card.dart';

class BuscarScreen extends StatefulWidget {
  const BuscarScreen({super.key});

  @override
  State<BuscarScreen> createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  final _api = ApiService();
  final _ctrl = TextEditingController();
  String _categoria = 'Todos';
  bool _meiOnly = false;
  bool _loading = false;
  List<ProfessionalSummary> _lista = [];

  final _categorias = ['Todos', 'Limpeza', 'Reformas', 'Tecnologia', 'Beleza'];

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  Future<void> _buscar() async {
    setState(() => _loading = true);
    try {
      final result = await _api.search(_ctrl.text, _categoria, _meiOnly);
      if (mounted) setState(() { _lista = result; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call Work'), actions: [
        Padding(padding: const EdgeInsets.only(right: 12), child: Icon(Icons.location_on_outlined, color: kBrand300, size: 20)),
      ]),
      body: Column(
        children: [
          Container(
            color: kBrand900,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                TextField(
                  controller: _ctrl,
                  onChanged: (_) => _buscar(),
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Diarista, eletricista, designer...',
                    prefixIcon: const Icon(Icons.search, color: kInkMute),
                    suffixIcon: _ctrl.text.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear, color: kInkMute, size: 18), onPressed: () { _ctrl.clear(); _buscar(); })
                        : null,
                    filled: true, fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _categorias.map((c) => Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: GestureDetector(
                        onTap: () { setState(() => _categoria = c); _buscar(); },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: _categoria == c ? Colors.white : Colors.white12,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(c, style: TextStyle(
                            color: _categoria == c ? kBrand900 : Colors.white,
                            fontWeight: FontWeight.w700, fontSize: 13,
                          )),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_lista.length} profissionais · Maringá, PR', style: const TextStyle(fontSize: 12, color: kInkSoft)),
                Row(children: [
                  const Text('Só MEI', style: TextStyle(fontSize: 12, color: kInkSoft)),
                  const SizedBox(width: 6),
                  Switch.adaptive(value: _meiOnly, onChanged: (v) { setState(() => _meiOnly = v); _buscar(); }, activeThumbColor: kBrand700, activeTrackColor: kBrand100),
                ]),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: kBrand500))
                : _lista.isEmpty
                    ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.search_off, size: 48, color: kInkMute),
                        const SizedBox(height: 12),
                        const Text('Nenhum profissional encontrado.', style: TextStyle(color: kInkSoft)),
                        const SizedBox(height: 6),
                        TextButton(onPressed: () { _ctrl.clear(); setState(() { _categoria = 'Todos'; _meiOnly = false; }); _buscar(); }, child: const Text('Limpar filtros')),
                      ]))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: _lista.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) => ProCard(
                          pro: _lista[i],
                          onTap: () => Navigator.pushNamed(ctx, '/perfil', arguments: _lista[i].id),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
}

import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../modls/prestador.dart';
import '../service/prestador-service.dart';
import '../widgests/prestador_card.dart';

class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  State<BuscaScreen> createState() => _BuscaScreenState();
}

class _BuscaScreenState extends State<BuscaScreen> {
  final PrestadorService prestadorService = PrestadorService();
  final TextEditingController buscaController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController(text: 'Maringá');

  List<Prestador> prestadores = [];
  bool carregando = false;
  String erro = '';
  String categoriaSelecionada = 'Todos';

  final List<String> categorias = ['Todos', 'Limpeza', 'Reformas', 'Tecnologia', 'Beleza'];

  @override
  void initState() {
    super.initState();
    buscarPrestadores();
  }

  Future<void> buscarPrestadores() async {
    if (!mounted) return;
    setState(() {
      carregando = true;
      erro = '';
    });
    try {
      final resultado = await prestadorService.buscarPrestadores(
        q: buscaController.text,
        cidade: cidadeController.text,
      );
      if (mounted) setState(() => prestadores = resultado);
    } catch (e) {
      if (mounted) setState(() => erro = 'Não foi possível carregar os prestadores.');
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  List<Prestador> get prestadoresFiltrados {
    if (categoriaSelecionada == 'Todos') return prestadores;
    return prestadores
        .where((p) => p.categoria.toLowerCase().contains(categoriaSelecionada.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNavBar(),
          _buildSearchBar(),
          _buildCategorias(),
          if (!carregando && prestadoresFiltrados.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
              child: Text(
                '${prestadoresFiltrados.length} profissionais em ${cidadeController.text}',
                style: const TextStyle(fontSize: 12, color: kMuted),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: buscarPrestadores,
              child: _buildLista(),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: kBgMuted,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFB4B2A9), width: 0.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: kMuted),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: buscaController,
                onSubmitted: (_) => buscarPrestadores(),
                decoration: const InputDecoration(
                  hintText: 'Diarista, eletricista...',
                  hintStyle: TextStyle(fontSize: 13, color: kMuted),
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 13, color: kText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorias() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final cat = categorias[index];
          final on = cat == categoriaSelecionada;
          return GestureDetector(
            onTap: () => setState(() => categoriaSelecionada = cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: on ? kBrand50 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: on ? kBrand300 : kBorder,
                  width: 0.5,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 12,
                  color: on ? kBrand : kMuted,
                  fontWeight: on ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLista() {
    if (carregando) {
      return const Center(child: CircularProgressIndicator(color: kBrand));
    }
    if (erro.isNotEmpty) {
      return Center(
        child: Text(erro, style: const TextStyle(fontSize: 13, color: kMuted)),
      );
    }
    if (prestadoresFiltrados.isEmpty) {
      return const Center(
        child: Text('Nenhum prestador encontrado.', style: TextStyle(fontSize: 13, color: kMuted)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
      itemCount: prestadoresFiltrados.length,
      itemBuilder: (context, index) => PrestadorCard(prestador: prestadoresFiltrados[index]),
    );
  }
}

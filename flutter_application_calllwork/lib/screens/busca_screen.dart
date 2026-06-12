import 'package:flutter/material.dart';
import 'package:flutter_application_calllwork/modls/prestador.dart';

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
  final TextEditingController cidadeController = TextEditingController(
    text: 'Maringá',
  );

  List<Prestador> prestadores = [];
  bool carregando = false;
  String erro = '';
  String categoriaSelecionada = 'Todos';

  final List<String> categorias = [
    'Todos',
    'Reformas',
    'Limpeza',
    'Tech',
  ];

  @override
  void initState() {
    super.initState();
    buscarPrestadores();
  }

  Future<void> buscarPrestadores() async {
    setState(() {
      carregando = true;
      erro = '';
    });

    try {
      final resultado = await prestadorService.buscarPrestadores(
        q: buscaController.text,
        cidade: cidadeController.text,
      );

      setState(() {
        prestadores = resultado;
      });
    } catch (e) {
      setState(() {
        erro = 'Não foi possível carregar os prestadores.';
      });
    } finally {
      setState(() {
        carregando = false;
      });
    }
  }

  List<Prestador> get prestadoresFiltrados {
    if (categoriaSelecionada == 'Todos') {
      return prestadores;
    }

    return prestadores.where((prestador) {
      return prestador.categoria.toLowerCase().contains(
            categoriaSelecionada.toLowerCase(),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchArea(),
            _buildCategorias(),

            Expanded(
              child: RefreshIndicator(
                onRefresh: buscarPrestadores,
                child: _buildListaPrestadores(),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF085041),
        unselectedItemColor: const Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Conversas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          const Text(
            '📞 Call Work',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF085041),
            ),
          ),

          const Spacer(),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),

          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF1D9E75),
            child: Text(
              'JS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextField(
            controller: buscaController,
            onSubmitted: (_) => buscarPrestadores(),
            decoration: InputDecoration(
              hintText: 'Eletricista, diarista, pedreiro...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: cidadeController,
            onSubmitted: (_) => buscarPrestadores(),
            decoration: InputDecoration(
              hintText: 'Cidade',
              prefixIcon: const Icon(Icons.location_on_outlined),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorias() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          final selecionada = categoria == categoriaSelecionada;

          return ChoiceChip(
            label: Text(categoria),
            selected: selecionada,
            selectedColor: const Color(0xFF085041),
            labelStyle: TextStyle(
              color: selecionada ? Colors.white : const Color(0xFF374151),
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: Colors.white,
            onSelected: (_) {
              setState(() {
                categoriaSelecionada = categoria;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildListaPrestadores() {
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (erro.isNotEmpty) {
      return Center(
        child: Text(
          erro,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (prestadoresFiltrados.isEmpty) {
      return const Center(
        child: Text('Nenhum prestador encontrado.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
      itemCount: prestadoresFiltrados.length,
      itemBuilder: (context, index) {
        return PrestadorCard(
          prestador: prestadoresFiltrados[index],
        );
      },
    );
  }
}
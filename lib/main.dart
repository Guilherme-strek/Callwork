import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/buscar/buscar_screen.dart';
import 'screens/perfil/perfil_screen.dart';
import 'screens/painel/painel_screen.dart';
import 'screens/cadastro/cadastro_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kBrand900,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const CallWorkApp());
}

class CallWorkApp extends StatelessWidget {
  const CallWorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Work',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const MainShell());
          case '/buscar':
            return MaterialPageRoute(builder: (_) => const MainShell(initialIndex: 1));
          case '/painel':
            return MaterialPageRoute(builder: (_) => const MainShell(initialIndex: 2));
          case '/cadastro':
            return MaterialPageRoute(builder: (_) => const MainShell(initialIndex: 3));
          case '/perfil':
            final id = settings.arguments as int;
            return MaterialPageRoute(builder: (_) => PerfilScreen(professionalId: id));
          default:
            return MaterialPageRoute(builder: (_) => const MainShell());
        }
      },
    );
  }
}

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _idx;

  @override
  void initState() {
    super.initState();
    _idx = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigate: (i) => setState(() => _idx = i)),
      const BuscarScreen(),
      const PainelScreen(),
      const CadastroScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _idx, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search_rounded), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard_rounded), label: 'Painel'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Cadastro'),
        ],
      ),
    );
  }
}

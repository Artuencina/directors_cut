import 'package:directors_cut/config/router/app_router.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_bloc.dart';
import 'package:directors_cut/features/scenes/ui/bloc/projects/local/local_project_event.dart';
import 'package:directors_cut/features/scenes/ui/bloc/scenes/local/bloc/local_scene_bloc.dart';
import 'package:directors_cut/features/scenes/ui/pages/projects.dart';
import 'package:directors_cut/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';

import 'features/scenes/ui/bloc/annotations/local/bloc/annotation_bloc.dart';

//Temas
final temaClaro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.amber,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6200EE),
      foregroundColor: Colors.white,
    ),
    textTheme: GoogleFonts.latoTextTheme().copyWith(),
    cardTheme: CardTheme(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      color: Colors.indigo.shade100,
    ));

void main() async {
  //Ensure initialized
  WidgetsFlutterBinding.ensureInitialized();
  //Drop database for testing
  deleteDatabase('app_database.db');
  await initializeDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocalProjectsBloc>(
          create: (context) => sl()..add(const GetProjectsEvent()),
        ),
        BlocProvider<LocalScenesBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<AnnotationBloc>(
          create: (context) => sl(),
        )
      ],
      child: MaterialApp.router(
        title: 'Directors Cut',
        theme: temaClaro,
        themeMode: ThemeMode.light,
        routerConfig: router,
      ),
    ),
  );
}

//Layout principal de la app, con el tema claro
//y un bottomnavigationbar con dos opciones
//para navegar entre proyectos y la pestaña de descargas

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  //Temporalmente voy a poner aca las pantallas

  static const List<Widget> _widgetOptions = <Widget>[
    ProjectScreen(),
    Text(
      'Index 1: Descargas',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Layout principal de la app, con el tema claro
  //y un bottomnavigationbar con dos opciones
  //para navegar entre proyectos y la pestaña de descargas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Proyectos',
            activeIcon: Icon(Icons.movie_creation_rounded),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Descargas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

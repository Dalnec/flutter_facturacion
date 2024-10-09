// import 'package:facturacion/src/models/models.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:facturacion/src/widgets/user/user_card_info.dart';
// import 'package:facturacion/src/services/services.dart' show UsuarioService;
// import 'package:facturacion/src/screens/screens.dart' show LoadingScreen;

// class UserScreen extends StatefulWidget {
//   const UserScreen({super.key});

//   @override
//   State<UserScreen> createState() => _UserScreenState();
// }

// class _UserScreenState extends State<UserScreen> {
//   final TextEditingController __searchController = TextEditingController();

//   @override
//   void dispose() {
//     // Limpiar el controlador cuando el widget se elimina
//     __searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final usuarioService = Provider.of<UsuarioService>(context);
//     if (usuarioService.isLoading) return const LoadingScreen();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Usuarios"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: PopScope(
//           onPopInvokedWithResult: (didPop, result) {
//             usuarioService.getUsuarios('');
//             // __searchController.clear();
//           },
//           child: Column(
//             children: [
//               // Campo de texto para la búsqueda
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: __searchController,
//                       decoration: InputDecoration(
//                         hintText: 'Buscar...',
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.search),
//                           onPressed: () {
//                             // Llamar a la función de búsqueda cuando se presione el ícono
//                             // _search(___searchController.text);
//                             usuarioService.getUsuarios(__searchController.text);
//                           },
//                         ),
//                       ),
//                       onSubmitted: (value) {
//                         // Llamar a la función de búsqueda cuando se presione Enter en el teclado
//                         // _search(value);
//                         usuarioService.getUsuarios(__searchController.text);
//                       },
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       usuarioService.selectedUsuario = Usuario(
//                         ci: '',
//                         names: '',
//                         lastnames: '',
//                         gender: 'M',
//                         phone: '',
//                         email: '',
//                         family: '',
//                         address: '',
//                         status: 'A',
//                         employee: 0,
//                       );
//                       Navigator.pushNamed(context, 'userform');
//                     },
//                     icon: const Icon(Icons.person_add),
//                     iconSize: 30,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 // ListView para mostrar los resultados
//                 child: ListView.builder(
//                   itemCount: usuarioService.usuarios.length,
//                   itemBuilder: (context, index) {
//                     return UserCardInfo(
//                         usuario: usuarioService.usuarios[index],
//                         service: usuarioService);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/widgets/user/user_card_info.dart';
import 'package:facturacion/src/services/services.dart' show UsuarioService;
// import 'package:facturacion/src/screens/screens.dart' show LoadingScreen;

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _searchController = TextEditingController();
  // Controlador de desplazamiento
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Añadir el listener al ScrollController
    _scrollController.addListener(_onScroll);
    // Actualizar la UI cada vez que cambia el texto
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Limpiar el controlador de texto y scroll cuando el widget se elimina
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Función para detectar cuando el usuario está cerca del final del scroll
  void _onScroll() async {
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);
    // Si el scroll está cerca del final (200 px antes) y no está cargando más datos
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      await Future.delayed(const Duration(seconds: 3));
      _loadMore(usuarioService);
    }
  }

  // Función para cargar más datos
  Future<void> _loadMore(UsuarioService usuarioService) async {
    setState(() {
      _isLoadingMore = true;
    });
    // lógica para cargar más usuarios
    await usuarioService.loadMoreUsuarios(_searchController.text);
    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);
    // if (usuarioService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
      ),
      body: usuarioService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : PopScope(
              onPopInvokedWithResult: (didPop, result) {
                usuarioService.getUsuarios('');
                // _searchController.clear();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Campo de texto para la búsqueda
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              prefixIcon: _searchController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        usuarioService.getUsuarios('');
                                        setState(() {});
                                      },
                                    ),
                              hintText: 'Buscar...',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  _scrollController.jumpTo(0);
                                  usuarioService
                                      .getUsuarios(_searchController.text);
                                },
                              ),
                            ),
                            onSubmitted: (value) {
                              _scrollController.jumpTo(0);
                              usuarioService
                                  .getUsuarios(_searchController.text);
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            usuarioService.selectedUsuario = Usuario(
                              ci: '',
                              names: '',
                              lastnames: '',
                              gender: 'M',
                              phone: '',
                              email: '',
                              family: '',
                              address: '',
                              status: 'A',
                              employee: 0,
                            );
                            Navigator.pushNamed(context, 'userform');
                          },
                          icon: const Icon(Icons.person_add),
                          iconSize: 30,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      // ListView con ScrollController para detectar el desplazamiento
                      child: RefreshIndicator(
                        color: AppTheme.primary,
                        backgroundColor: Colors.white.withOpacity(0.7),
                        onRefresh: () {
                          return usuarioService.getUsuarios('');
                        },
                        child: ListView.builder(
                          // Asignar el controlador de scroll
                          controller: _scrollController,
                          // Añadir 1 si está cargando más
                          itemCount: usuarioService.usuarios.length +
                              (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == usuarioService.usuarios.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: AppTheme.primary,
                                )),
                              );
                            }
                            return UserCardInfo(
                              usuario: usuarioService.usuarios[index],
                              service: usuarioService,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _LodingIcon extends StatelessWidget {
  const _LodingIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // return Container(
    //   // alignment: Alignment.center,
    //   padding: const EdgeInsets.all(10),
    //   height: 60,
    //   width: 60,
    //   decoration: BoxDecoration(
    //       color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
    //   child: const CircularProgressIndicator(
    //     color: AppTheme.primary,
    //   ),
    // );
    return Container(
      child: SizedBox(
        width: double.infinity,
        height: size.height,
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        ),
      ),
    );
  }
}

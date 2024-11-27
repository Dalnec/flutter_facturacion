import 'package:facturacion/src/services/services.dart'
    show UsuarioService, AuthService;
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final storage = const FlutterSecureStorage();
  String profile = '';

  // Lista de tags
  final List<String> tags = ['Deuda', 'Facturar', 'Todos'];

  // Mantiene el estado de selección de cada tag
  List<bool> _isSelected = [false, false, true];
  final Map<String, dynamic> filterParams = {
    'hasDebt': null,
    'makeInvoice': null,
    'status': 'A',
  };
  final Map<String, String> formValues = {
    'measure': '0',
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFetchData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      // await Future.delayed(const Duration(seconds: 3));
      _loadMore(usuarioService);
    }
  }

  Future<void> _loadMore(UsuarioService usuarioService) async {
    setState(() {
      _isLoadingMore = true;
    });
    await usuarioService.loadMoreUsuarios(
        _searchController.text,
        filterParams['hasDebt'],
        filterParams['makeInvoice'],
        filterParams['status']);
    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _initFetchData() async {
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);
    await usuarioService.getUsuarios('', filterParams['hasDebt'],
        filterParams['makeInvoice'], filterParams['status']);
    profile = await storage.read(key: 'profile') ?? '';
  }

  void setfiltersParams() async {
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);
    if (_isSelected[0] == true) {
      filterParams['hasDebt'] = true;
    } else {
      filterParams['hasDebt'] = false;
    }
    if (_isSelected[1] == true) {
      filterParams['makeInvoice'] = true;
    } else {
      filterParams['makeInvoice'] = false;
    }
    if (_isSelected[2] == true) {
      filterParams['hasDebt'] = null;
      filterParams['makeInvoice'] = null;
      _isSelected = [false, false, true];
    }
    // _initFetchData();
    await usuarioService.getUsuarios(
        _searchController.text,
        filterParams['hasDebt'],
        filterParams['makeInvoice'],
        filterParams['status']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.readProfile();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generar Factura"),
        actions: [
          if (profile == 'LECTURADOR')
            IconButton(
                onPressed: () {
                  ModularDialog.showModularDialog(
                    context: context,
                    title: 'Confirmar Acción',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '¿Desea Cerrar Sesión?',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Future.delayed(const Duration(seconds: 1));
                          await authService.logout();
                          // Navigator.pushReplacementNamed(context, 'login');
                          Navigator.pushNamedAndRemoveUntil(
                              context, "login", (r) => false);
                        },
                        child: const Text('Confirmar',
                            style: TextStyle(color: AppTheme.harp)),
                      ),
                    ],
                  );
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de texto para la búsqueda
            Row(
              children: [
                Expanded(
                  child: TextField(
                    // autofocus: true,
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () async {
                                _searchController.clear();
                                // usuarioService.getUsuarios('', null, null, 'A');
                                await usuarioService.getUsuarios(
                                    '',
                                    filterParams['hasDebt'],
                                    filterParams['makeInvoice'],
                                    filterParams['status']);
                                setState(() {});
                              },
                            ),
                      labelText: 'Buscar...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          _scrollController.jumpTo(0);
                          // usuarioService.getUsuarios( _searchController.text, null, null, 'A');
                          await usuarioService.getUsuarios(
                              _searchController.text,
                              filterParams['hasDebt'],
                              filterParams['makeInvoice'],
                              filterParams['status']);
                        },
                      ),
                    ),
                    onSubmitted: (value) async {
                      _scrollController.jumpTo(0);
                      // usuarioService.getUsuarios( _searchController.text, null, null, 'A');
                      await usuarioService.getUsuarios(
                          _searchController.text,
                          filterParams['hasDebt'],
                          filterParams['makeInvoice'],
                          filterParams['status']);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List<Widget>.generate(tags.length, (int index) {
                      return ChoiceChip(
                        label: Text(tags[index]),
                        selected: _isSelected[index],
                        onSelected: (bool selected) {
                          setState(() {
                            _isSelected[index] = selected;
                            setfiltersParams();
                          });
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
            Expanded(
              // ListView para mostrar los resultados
              child: RefreshIndicator(
                color: AppTheme.primary,
                backgroundColor: Colors.white.withOpacity(0.7),
                onRefresh: () async {
                  // return usuarioService.getUsuarios('', null, null, 'A');
                  return await usuarioService.getUsuarios(
                      _searchController.text,
                      filterParams['hasDebt'],
                      filterParams['makeInvoice'],
                      filterParams['status']);
                },
                child: usuarioService.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
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
                          // TODO: Mostrar ultimo mes deuda
                          return UserCardInvoiceInfo(
                              usuario: usuarioService.usuarios[index],
                              service: usuarioService);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

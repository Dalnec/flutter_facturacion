import 'package:facturacion/src/services/services.dart' show UsuarioService;
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

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
    await usuarioService.loadMoreUsuarios(_searchController.text);
    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generar Factura"),
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
                              onPressed: () {
                                _searchController.clear();
                                usuarioService.getUsuarios('');
                                setState(() {});
                              },
                            ),
                      // hintText: 'Buscar...',
                      labelText: 'Buscar',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _scrollController.jumpTo(0);
                          usuarioService.getUsuarios(_searchController.text);
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      _scrollController.jumpTo(0);
                      usuarioService.getUsuarios(_searchController.text);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              // ListView para mostrar los resultados
              child: RefreshIndicator(
                color: AppTheme.primary,
                backgroundColor: Colors.white.withOpacity(0.7),
                onRefresh: () {
                  return usuarioService.getUsuarios('');
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      usuarioService.usuarios.length + (_isLoadingMore ? 1 : 0),
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

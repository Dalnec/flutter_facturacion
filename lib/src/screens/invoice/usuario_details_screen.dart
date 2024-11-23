import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuarioDetailsScreen extends StatefulWidget {
  const UsuarioDetailsScreen({super.key});

  @override
  State<UsuarioDetailsScreen> createState() => _UsuarioDetailsScreenState();
}

class _UsuarioDetailsScreenState extends State<UsuarioDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int usuarioId = 0;

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
    final usuarioService =
        Provider.of<UsuarioDetailDetailService>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      await Future.delayed(const Duration(seconds: 3));
      _loadMore(usuarioService);
    }
  }

  Future<void> _loadMore(UsuarioDetailDetailService usuarioService) async {
    if (!mounted) return;
    setState(() {
      _isLoadingMore = true;
    });
    await usuarioService.loadMoreUsuarioDetails('$usuarioId');
    if (!mounted) return;
    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _initFetchData() async {
    final usuarioDetailService =
        Provider.of<UsuarioDetailDetailService>(context, listen: false);
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);
    usuarioId = usuarioService.selectedUsuario.id!;
    await usuarioDetailService.getUsuarioDetails('$usuarioId');
  }

  @override
  Widget build(BuildContext context) {
    final usuarioDetailService =
        Provider.of<UsuarioDetailDetailService>(context);
    final details = usuarioDetailService.details;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Usuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: () {
              usuarioDetailService.selectedUsuarioDetail = UsuarioDetail(
                description: '',
                price: '',
                quantity: '',
                isIncome: true,
                usuario: usuarioId,
                status: true,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UsuarioDetailsFormScreen()),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: details.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) => Container(
          padding:
              const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          decoration: _createCardShape(
              details[index].invoiceNumber, details[index].status),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (details[index].invoiceNumber != null)
                    Text('N° ${details[index].invoiceNumber}',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  Text(details[index].formatedUsuarioDetailDate(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      )),
                  if (details[index].status!)
                    Text(
                      'Activo',
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  else
                    Text(
                      'Anulado',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                details[index].description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Cantidad',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(details[index].quantity),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Precio',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(details[index].price),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text('${details[index].subtotal}'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (details[index].status!)
                    ElevatedButton.icon(
                        onPressed: null,
                        icon: Icon(
                          Icons.arrow_circle_up_outlined,
                          color: Colors.teal[400],
                          size: 25,
                        ),
                        label: Text(
                          'Ingreso',
                          style: TextStyle(
                            color: Colors.teal[400],
                            fontSize: 15,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ))
                  else
                    ElevatedButton.icon(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_circle_down_outlined,
                        color: Colors.orange,
                        size: 25,
                      ),
                      label: Text(
                        'Egreso',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 15,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: !details[index].status!
                        ? null
                        : () {
                            ModularDialog.showModularDialog(
                              context: context,
                              title: 'Confirmar Acción',
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '¿Desea Anular el Registro?',
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
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    final updateDestail = details[index].copy();
                                    updateDestail.status = false;
                                    final res = await usuarioDetailService
                                        .saveOrCreateUsuarioDetail(
                                            updateDestail);
                                    if (res == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Error al anular')),
                                      );
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Registro anulado correctamente')),
                                    );
                                    Navigator.of(context).pop();
                                    _initFetchData();
                                  },
                                  child: const Text('Confirmar',
                                      style: TextStyle(color: AppTheme.harp)),
                                ),
                              ],
                            );
                          },
                    icon: const Icon(Icons.block,
                        color: AppTheme.error, size: 18),
                    label: const Text("Anular",
                        style: TextStyle(color: AppTheme.error, fontSize: 15)),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      foregroundColor: WidgetStateProperty.all(Colors.red),
                      overlayColor:
                          WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _createCardShape(int? invoiceNumber, bool? status) =>
      BoxDecoration(
        color:
            invoiceNumber != null || !status! ? Colors.grey[300] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15, // soften the shadow
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      );
}

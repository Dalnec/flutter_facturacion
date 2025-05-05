import 'package:facturacion/src/screens/screens.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart' show EmployeeService;

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

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
    final employeeService =
        Provider.of<EmployeeService>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      await Future.delayed(const Duration(seconds: 3));
      _loadMore(employeeService);
    }
  }

  Future<void> _loadMore(EmployeeService employeeService) async {
    if (!mounted) return;
    setState(() {
      _isLoadingMore = true;
    });

    await employeeService.loadMoreEmployee(_searchController.text);
    if (!mounted) return;
    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _initFetchData() async {
    final employeeService =
        Provider.of<EmployeeService>(context, listen: false);
    await employeeService.getEmployee('');
  }

  @override
  Widget build(BuildContext context) {
    final employeeService = Provider.of<EmployeeService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Encargados"),
      ),
      // body: PopScope(
      //   onPopInvokedWithResult: (didPop, result) {
      //     employeeService.getEmployee('');
      //   },
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                                employeeService.getEmployee('');
                                setState(() {});
                              },
                            ),
                      hintText: 'Buscar Encargados...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _scrollController.jumpTo(0);
                          employeeService.getEmployee(_searchController.text);
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      _scrollController.jumpTo(0);
                      employeeService.getEmployee(_searchController.text);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    employeeService.selectedEmployee = Employee(
                      ci: '',
                      names: '',
                      lastnames: '',
                      phone: '',
                      email: '',
                      address: '',
                      status: 'A',
                      employee: 0,
                      username: '',
                      profile: 2,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmployeeFormScreen()),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  iconSize: 30,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                color: AppTheme.primary,
                backgroundColor: Colors.white.withOpacity(0.7),
                onRefresh: () {
                  return employeeService.getEmployee('');
                },
                child: employeeService.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: employeeService.employees.length +
                            (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == employeeService.employees.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: AppTheme.primary,
                              )),
                            );
                          }
                          return _UserCardInfo(
                            employee: employeeService.employees[index],
                            service: employeeService,
                          );
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

class _UserCardInfo extends StatelessWidget {
  final Employee employee;
  final EmployeeService service;

  const _UserCardInfo({
    super.key,
    required this.employee,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('card_container'),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Container(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        width: double.infinity,
        decoration: _createCardShape(),
        child: _UserInfo(employee: employee, service: service),
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      );
}

class _UserInfo extends StatelessWidget {
  final Employee employee;
  final EmployeeService service;

  const _UserInfo({
    super.key,
    required this.employee,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _rowInfo(Icons.person_outline, employee.names, width: 150),
          if (employee.status == 'I')
            Text("Inactivo", style: TextStyle(color: AppTheme.error)),
          IconButton(
            onPressed: () {
              ModularDialog.showModularDialog(
                context: context,
                title: 'Cambiar estado Encargado',
                content: Text(
                    '¿Esta seguro de ${employee.status == 'A' ? 'Inactivar' : 'Activar'} este Encargado?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final employeeService =
                          Provider.of<EmployeeService>(context, listen: false);
                      final status = employee.status == 'A' ? 'I' : 'A';
                      final resp = await employeeService.changeStatus(
                          '${employee.id}', status);
                      if (resp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Cambio de estado realizado correctamente')),
                        );
                        Navigator.of(context).pop();
                        await employeeService.getEmployee('');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error al cambiar el estado')),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Confirmar',
                        style: TextStyle(color: AppTheme.harp)),
                  ),
                ],
              );
            },
            tooltip: employee.status == 'I' ? 'Habilitar' : 'Inhabilitar',
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.block,
                color:
                    employee.status == 'I' ? AppTheme.primary : AppTheme.error,
                size: 25),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              foregroundColor: WidgetStateProperty.all(Colors.red),
              overlayColor:
                  WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
            ),
          ),
        ]),
        _rowInfo(Icons.house_outlined, employee.address),
        const SizedBox(height: 5),
        _rowInfo(Icons.smartphone_outlined, employee.phone),
        const SizedBox(height: 5),
        _rowInfo(Icons.person_pin, employee.username),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                service.selectedEmployee = employee.copy();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeFormScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: AppTheme.warning, size: 25),
              label: const Text("Editar",
                  style: TextStyle(color: AppTheme.warning)),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                foregroundColor: WidgetStateProperty.all(Colors.red),
                overlayColor:
                    WidgetStateProperty.all(Colors.red.withOpacity(0.1)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                service.selectedEmployee = employee.copy();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeEmployeePassword(
                            id: employee.id ?? 0,
                          )),
                );
              },
              icon: const Icon(Icons.password_outlined,
                  color: AppTheme.secondary, size: 25),
              label: const Text("Contraseña",
                  style: TextStyle(color: AppTheme.secondary)),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                foregroundColor: WidgetStateProperty.all(AppTheme.secondary),
                overlayColor: WidgetStateProperty.all(
                    AppTheme.secondary.withOpacity(0.1)),
              ),
            ),
          ],
        )
      ],
    );
  }

  Row _rowInfo(IconData icon, text, {double? width = 270}) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primary,
          size: 30,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: width,
          child: Text(text,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

class ChangeEmployeePassword extends StatelessWidget {
  final int id;

  const ChangeEmployeePassword({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Encargados"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormChangePassword(
            usuarioId: id,
            isEmployee: true,
          ),
        ),
      ),
    );
  }
}

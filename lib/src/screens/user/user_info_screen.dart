import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/services/services.dart'
    show AuthService, UsuarioService;
import 'package:facturacion/src/widgets/widgets.dart'
    show
        BarChartWidget,
        InvoiceDataTable,
        FormChangePassword,
        CardFullInfoUserInvoice,
        ModularDialog;

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  int _selectedIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final usuarioService = Provider.of<UsuarioService>(context, listen: false);
    const storage = FlutterSecureStorage();
    final usuario = await storage.read(key: 'usuario');
    await usuarioService.getUsuario('$usuario');
    setState(() {
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      Navigator.pop(context);
      destinations[index].onTap(context);
      if (index != 3) {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de Usuario'),
        actions: [
          // reload
          if (_selectedIndex == 1)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: isLoading
                  ? null
                  : () {
                      _fetchData();
                    },
            ),
        ],
      ),
      body: _selectedIndex == 0
          ? _NestedScrollViewWidget(usuarioService: usuarioService)
          : _selectedIndex == 1
              ? isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 300,
                      child: CardFullInfoUserInvoice(
                          usuario: usuarioService.selectedUsuario),
                    )
              : _CardContainer(
                  child: FormChangePassword(
                  usuarioId: usuarioService.selectedUsuario.id,
                )),
      drawer: NavigationDrawer(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Column(
              children: [
                Icon(
                  Icons.person_pin,
                  color: AppTheme.primary,
                  size: 60,
                ),
                const SizedBox(width: 5),
                Text(
                  'Bienvenido(a), ${usuarioService.selectedUsuario.names}!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          ...destinations.map(
            (NavDestination destination) {
              return NavigationDrawerDestination(
                label: Text(
                  destination.label,
                  style: const TextStyle(fontSize: 16),
                ),
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}

class NavDestination {
  const NavDestination(
    this.label,
    this.icon,
    this.selectedIcon,
    this.onTap,
  );

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final Function(BuildContext) onTap;
}

final List<NavDestination> destinations = <NavDestination>[
  NavDestination(
    'Recibos',
    const Icon(Icons.receipt_long_outlined, color: AppTheme.primary),
    const Icon(Icons.receipt_long),
    (context) {},
  ),
  NavDestination(
    'Datos Usuario',
    const Icon(Icons.perm_contact_cal_outlined, color: AppTheme.primary),
    const Icon(Icons.perm_contact_cal),
    (context) {},
  ),
  NavDestination(
    'Cambiar Contraseña',
    const Icon(Icons.edit_attributes_outlined, color: AppTheme.primary),
    const Icon(Icons.edit_attributes),
    (context) {},
  ),
  NavDestination(
    'Cerrar Sesión',
    const Icon(Icons.logout_outlined, color: AppTheme.primary),
    const Icon(Icons.logout),
    (context) {
      ModularDialog.showModularDialog(
        context: context,
        title: 'Confirmar Acción',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¿Deseas cerrar la sesión?',
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
              Navigator.of(context).pop();
              await Provider.of<AuthService>(context, listen: false).logout();
              // Navigator.pushReplacementNamed(context, 'login');
              Navigator.pushNamedAndRemoveUntil(context, "login", (r) => false);
            },
            child:
                const Text('Confirmar', style: TextStyle(color: AppTheme.harp)),
          ),
        ],
      );
    },
  ),
];

class _NestedScrollViewWidget extends StatefulWidget {
  const _NestedScrollViewWidget({
    super.key,
    required this.usuarioService,
  });

  final UsuarioService usuarioService;

  @override
  State<_NestedScrollViewWidget> createState() =>
      _NestedScrollViewWidgetState();
}

class _NestedScrollViewWidgetState extends State<_NestedScrollViewWidget> {
  int? selectedYear;
  List<int> years = [];

  @override
  void initState() {
    super.initState();
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i >= 2023; i--) {
      years.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: const NeverScrollableScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                  // textAlign: TextAlign.center,
                  "Últimos Recibos:",
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 20,
                  )),
              // YearSelector()
              Center(
                child: DropdownButton<int>(
                  isExpanded: false,
                  dropdownColor: Colors.white,
                  hint: Text(
                    'Seleccionar Año',
                    style: TextStyle(color: AppTheme.primary, fontSize: 14),
                  ),
                  value: selectedYear,
                  items: years.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(
                        year.toString(),
                        style: const TextStyle(
                            fontSize: 16, color: AppTheme.primary),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedYear = newValue;
                      print("Selector: $selectedYear");
                    });
                  },
                ),
              )
            ],
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CardContainer(
                height: 230,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: BarChartWidget(year: selectedYear),
                ),
              ),
            ),
          )
        ];
      },
      body: InvoiceDataTable(
        usuario: widget.usuarioService.selectedUsuario,
        year: selectedYear,
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  final double? height;

  const _CardContainer({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      // width: 300,
      height: height ?? null,
      decoration: _createCardShape(),
      child: child,
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      );
}

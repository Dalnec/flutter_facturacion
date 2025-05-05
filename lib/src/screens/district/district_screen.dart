// import 'package:facturacion/src/models/distric.dart';
import 'package:facturacion/src/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/services/services.dart' show DistricService;

class DistricScreen extends StatefulWidget {
  const DistricScreen({super.key});

  @override
  State<DistricScreen> createState() => _DistricScreenState();
}

class _DistricScreenState extends State<DistricScreen> {
  bool _isEditing = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final districService = Provider.of<DistricService>(context);
    final distric = districService.distric;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Información General"),
        actions: [
          // Botón de Editar/Guardar
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              // Guardar los cambios
              if (_isEditing) {
                districService.updateDistric(distric);
              }
              setState(() {
                // Cambiar entre los modos de edición y vista
                _isEditing = !_isEditing;
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              final districService =
                  Provider.of<DistricService>(context, listen: false);
              await districService.getSettings();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DistrictSettingsFormScreen()),
              );
              setState(() {});
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // Icono principal y nombre del barrio
            _CardContainer(
              child: Column(
                children: [
                  const Icon(
                    Icons.other_houses_outlined,
                    color: AppTheme.primary,
                    size: 130,
                  ),
                  const SizedBox(height: 10),
                  // Mostrar Text o TextFormField según el estado de edición
                  _isEditing
                      ? TextFormField(
                          initialValue: distric.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            distric.name = value;
                          },
                        )
                      : Text(
                          distric.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            // Sección de Representante
            _CardContainer(
              child: _FieldsInfo(
                isEditing: _isEditing,
                label: 'Representante',
                value: distric.representative,
                onChanged: (value) => distric.representative = value,
              ),
            ),

            // Sección de Dirección
            _CardContainer(
              child: _FieldsInfo(
                isEditing: _isEditing,
                label: 'Dirección',
                value: distric.address,
                onChanged: (value) => distric.address = value,
              ),
            ),
            _CardContainer(
              child: _FieldsInfo(
                isEditing: _isEditing,
                label: 'Celular',
                value: distric.phone,
                onChanged: (value) => distric.phone = value,
              ),
            ),
            _CardContainer(
              child: _FieldsInfo(
                isEditing: _isEditing,
                label: 'Correo Electrónico',
                value: distric.email,
                onChanged: (value) => distric.email = value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldsInfo extends StatelessWidget {
  const _FieldsInfo({
    super.key,
    required bool isEditing,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : _isEditing = isEditing;

  final bool _isEditing;
  final String label;
  final String value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondary,
          ),
        ),
        const SizedBox(height: 5),
        _isEditing
            ? TextFormField(
                initialValue: value,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) => onChanged(value),
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _createCardShape(),
        child: child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
      );
}

// import 'package:facturacion/src/themes/theme.dart';
// import 'package:flutter/material.dart';

// class DistricScreen extends StatelessWidget {
//   const DistricScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Información General"),
//       ),
//       body: const _CardContainer(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(Icons.other_houses_outlined,
//                 color: AppTheme.primary, size: 150),
//             Text('OTB VILLA ESPERANZA',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 20,
//                     color: AppTheme.primary,
//                     fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text('Representante',
//                 style: TextStyle(
//                     fontSize: 20,
//                     color: AppTheme.secondary,
//                     fontWeight: FontWeight.bold)),
//             Text('JAIME MAMANI CORONEL',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 20,
//                     // color: AppTheme.primary,
//                     fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text('Dirección',
//                 style: TextStyle(
//                     fontSize: 20,
//                     color: AppTheme.secondary,
//                     fontWeight: FontWeight.bold)),
//             Text('CALLES LOS CONQUISTADORES Y LOS PINOS SUR MZ. C LT. 2',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CardContainer extends StatelessWidget {
//   final Widget child;

//   const _CardContainer({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20.0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//         width: double.infinity,
//         decoration: _createCardShape(),
//         child: child,
//       ),
//     );
//   }

//   BoxDecoration _createCardShape() => BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 15, // soften the shadow
//             offset: Offset(0, 5), // changes position of shadow
//           ),
//         ],
//       );
// }

// Image(
//   image: AssetImage('assets/images/distric.png'),
//   fit: BoxFit.contain,
//   width: 280,
// ),
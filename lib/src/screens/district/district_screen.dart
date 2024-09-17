import 'package:flutter/material.dart';
import 'package:facturacion/src/themes/theme.dart';

class DistricScreen extends StatefulWidget {
  const DistricScreen({super.key});

  @override
  _DistricScreenState createState() => _DistricScreenState();
}

class _DistricScreenState extends State<DistricScreen> {
  bool _isEditing = false;

  // Valores de los campos de ejemplo
  String _districtName = 'OTB VILLA ESPERANZA';
  String _representativeName = 'JAIME MAMANI CORONEL';
  String _address = 'CALLES LOS CONQUISTADORES Y LOS PINOS SUR MZ. C LT. 2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Información General"),
        actions: [
          // Botón de Editar/Guardar
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                // Cambiar entre los modos de edición y vista
                _isEditing = !_isEditing;
              });
            },
          ),
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
                          initialValue: _districtName,
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
                            _districtName = value;
                          },
                        )
                      : Text(
                          _districtName,
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
            const SizedBox(height: 20),

            // Sección de Representante
            _CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Representante',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _isEditing
                      ? TextFormField(
                          initialValue: _representativeName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            _representativeName = value;
                          },
                        )
                      : Text(
                          _representativeName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sección de Dirección
            _CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dirección',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _isEditing
                      ? TextFormField(
                          initialValue: _address,
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
                          onChanged: (value) {
                            _address = value;
                          },
                        )
                      : Text(
                          _address,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            offset: Offset(8, 6),
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
import 'package:facturacion/src/widgets/user/user_card_info.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
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
                    // controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Llamar a la función de búsqueda cuando se presione el ícono
                          // _search(_searchController.text);
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      // Llamar a la función de búsqueda cuando se presione Enter en el teclado
                      // _search(value);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'userform');
                  },
                  icon: const Icon(Icons.person_add),
                  iconSize: 30,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Indicador de carga
            Expanded(
              // ListView para mostrar los resultados
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const UserCardInfo();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';

class CardInfoUserInvoice extends StatelessWidget {
  final Usuario usuario;
  const CardInfoUserInvoice({super.key, required this.usuario});

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
        child: _UserInfo(
          hasDebt: usuario.hasDebt!,
          code: usuario.id.toString(),
          family: usuario.family,
          addres: usuario.address,
          phone: usuario.phone,
          names: usuario.names,
          lastnames: usuario.lastnames,
          ci: usuario.ci,
        ),
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
  final bool hasDebt;
  final String code;
  final String family;
  final String addres;
  final String phone;
  final String ci;
  final String names;
  final String lastnames;

  const _UserInfo({
    super.key,
    required this.hasDebt,
    required this.code,
    required this.family,
    required this.addres,
    required this.phone,
    required this.names,
    required this.lastnames,
    required this.ci,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.password_outlined,
                  color: AppTheme.primary,
                  size: 25,
                ),
                const SizedBox(width: 10),
                Text(code,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              children: [
                !hasDebt
                    ? const Icon(Icons.check_circle_outline_outlined,
                        color: AppTheme.success, size: 30)
                    : const Icon(Icons.monetization_on_outlined,
                        color: AppTheme.warning, size: 30),
                !hasDebt
                    ? const Text("",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.success))
                    : const Text(
                        "Deuda",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.warning),
                      ),
              ],
            )
          ],
        ),
        const SizedBox(height: 5),
        _rowInfo(Icons.family_restroom_outlined, family),
        const SizedBox(height: 5),
        _rowInfo(Icons.house, addres),
        const SizedBox(height: 5),
        _rowInfo(Icons.phone, phone),
        const SizedBox(height: 5),
        _rowInfo(Icons.person, '$ci - $names $lastnames'),
        const SizedBox(height: 5),
      ],
    );
  }

  Row _rowInfo(IconData icon, text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primary,
          size: 25,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 270,
          child: Text(text,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

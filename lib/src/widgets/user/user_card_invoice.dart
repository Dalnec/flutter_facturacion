import 'package:facturacion/src/themes/theme.dart';
import 'package:flutter/material.dart';

class UserCardInvoiceInfo extends StatelessWidget {
  final bool hasDebt;

  const UserCardInvoiceInfo({
    super.key,
    required this.hasDebt,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'invoiceform');
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        key: const Key('card_container'),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Container(
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          width: double.infinity,
          decoration: _createCardShape(),
          child: _UserInfo(hasDebt: hasDebt),
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
            blurRadius: 15, // soften the shadow
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      );
}

class _UserInfo extends StatelessWidget {
  final bool hasDebt;

  const _UserInfo({
    super.key,
    required this.hasDebt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _rowInfo(Icons.password_outlined, "A9865456"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.password_outlined,
                  color: AppTheme.primary,
                  size: 25,
                ),
                SizedBox(width: 10),
                Text("M9865456",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            !hasDebt
                ? const Icon(Icons.check_circle_outline_outlined,
                    color: AppTheme.success, size: 30)
                : const Icon(Icons.money_off_csred_outlined,
                    color: AppTheme.warning, size: 30),
          ],
        ),
        const SizedBox(height: 5),
        _rowInfo(Icons.family_restroom_outlined, "Fam. Perez Guevara"),
        const SizedBox(height: 5),
        _rowInfo(Icons.house,
            "Calle Guadalupe esq. juan pablo Ise gundo fi tercero #90"),
        const SizedBox(height: 5),
        _rowInfo(Icons.phone, "65381838"),
        const SizedBox(height: 5),
        // const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        //   Icon(Icons.check, color: AppTheme.success, size: 25),
        //   SizedBox(width: 10),
        //   Text(
        //     "AL DIA", //Habido
        //     style: TextStyle(
        //         fontSize: 20,
        //         fontWeight: FontWeight.bold,
        //         color: AppTheme.success),
        //   )
        // ])
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

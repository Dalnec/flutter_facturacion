import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/models/models.dart' show Usuario, Invoice;
import 'package:facturacion/src/services/services.dart'
    show UsuarioService, InvoiceService;

class UserCardInvoiceInfo extends StatelessWidget {
  final Usuario usuario;
  final UsuarioService service;

  const UserCardInvoiceInfo({
    super.key,
    required this.usuario,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final invoiceService = Provider.of<InvoiceService>(context);
    return InkWell(
      onTap: () {
        service.selectedUsuario = usuario.copy();
        invoiceService.selectedInvoice = Invoice(
          readDate: '',
          measured: '',
          price: '',
          total: '',
          status: 'D',
          employee: 0,
          usuario: usuario.id!,
        );
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
          child: _UserInfo(
            hasDebt: usuario.hasDebt!,
            code: usuario.id.toString(),
            family: usuario.family,
            addres: usuario.address,
            phone: usuario.phone,
          ),
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
  final String code;
  final String family;
  final String addres;
  final String phone;

  const _UserInfo({
    super.key,
    required this.hasDebt,
    required this.code,
    required this.family,
    required this.addres,
    required this.phone,
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

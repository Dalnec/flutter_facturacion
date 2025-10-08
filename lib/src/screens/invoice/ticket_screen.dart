import 'package:facturacion/src/models/models.dart';
import 'package:facturacion/src/services/services.dart';
import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:typed_data';
import 'dart:convert';

class TicketScreen extends StatefulWidget {
  final String data;
  final String status;
  final String profile;
  final Invoice invoice;

  const TicketScreen({
    super.key,
    required this.data,
    required this.status,
    required this.profile,
    required this.invoice,
  });

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final WidgetsToImageController controller = WidgetsToImageController();
  bool isLoading = false;

  Uint8List? _capturedImage;

  Future<void> _captureImage() async {
    final image = await controller.capture();
    if (image != null) {
      setState(() {
        _capturedImage = image;
      });
    }
  }

  Future<void> _shareImageTicket() async {
    await _captureImage();
    Share.shareXFiles([
      XFile.fromData(_capturedImage!, name: 'recibo.png', mimeType: 'image/png')
    ]);
  }

  Future<void> _shareLinkTicket() async {
    final usuario =
        Provider.of<UsuarioService>(context, listen: false).selectedUsuario;
    final ticketData = Ticket.fromJson(json.decode(widget.data));
    final header = ticketData.header;
    final body = ticketData.body;
    // final Uri url = Uri.parse(
    //     "https://wa.me/59165351938?text=Hello\nhttp://localhost:8000/api/ticket/bfeef66f-bfed-409a-aac2-12f56290bbe7/");
    final Uri url = Uri.parse(
        // "https://api.whatsapp.com/send?phone=591${usuario.phone}&text=Hola *${header.fullName}*, puede acceder a su recibo *${body.actualMonth}* ingresando al siguiente enlace:\nhttps://barrioluzapi.tsifactur.com/api/ticket/${widget.invoice.uuid}/");
        "https://api.whatsapp.com/send?phone=591${usuario.phone}&text=Hola *${header.fullName}*, puede acceder a su recibo *${body.actualMonth}* ingresando al siguiente enlace:\nhttps://barrioluzapi.tsifactur.com/api/ticket/${widget.invoice.uuid}/");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _paymentTicket() async {
    ModularDialog.showModularDialog(
      context: context,
      title: 'Cobrar',
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('¿Desea cobrar este recibo?', style: TextStyle(fontSize: 18)),
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
            setState(() => isLoading = true);
            widget.invoice.status = 'P';
            final invoiceService =
                Provider.of<InvoiceService>(context, listen: false);
            final usuarioService =
                Provider.of<UsuarioService>(context, listen: false);

            Navigator.of(context).pop();
            final res =
                await invoiceService.updateStatusInvoice(widget.invoice);
            await Future.delayed(const Duration(seconds: 1));
            if (res) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recibo cobrado correctamente')),
              );
              usuarioService.changeStatusPayment(widget.invoice.usuario);
              Navigator.pop(context, 'reload');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al cobrar :(')),
              );
            }
            setState(() => isLoading = false);
          },
          child: const Text('COBRAR', style: TextStyle(color: AppTheme.harp)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double reading = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Previa/Acciones'),
        actions: [
          // if (widget.status != 'P' && widget.profile != 'USUARIO')
          if ((widget.profile == 'LECTURADOR' || widget.status != 'P') &&
              widget.profile != 'USUARIO')
            IconButton(
                onPressed: () {
                  ModularDialog.showModularDialog(
                    context: context,
                    title: 'Editar Lectura',
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Nuevo valor de Lectura',
                              prefixIcon: Icon(Icons.add_chart),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^(\d+)?\.?\d{0,2}'))
                            ],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              reading = double.parse(value);
                            },
                          ),
                        )
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
                          isLoading = true;
                          setState(() {});
                          Navigator.of(context).pop();
                          final invoiceService = Provider.of<InvoiceService>(
                              context,
                              listen: false);

                          final invoice = widget.invoice.copy();
                          invoice.measured = reading.toString();
                          // invoice.total = ((reading -
                          //             double.parse(invoice.previosMeasured)) *
                          //         double.parse(invoice.price))
                          //     .toStringAsFixed(2);

                          final res =
                              await invoiceService.updateInvoice(invoice);
                          await Future.delayed(const Duration(seconds: 1));
                          isLoading = false;
                          setState(() {});
                          if (res["status"]) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Edición de Lectura correcta :)')),
                            );
                            widget.invoice.measured = res["invoice"].measured;
                            widget.invoice.total = res["invoice"].total;
                            widget.invoice.ticket = res["invoice"].ticket;
                            Navigator.pop(context, 'reload');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error al editar :(')),
                            );
                          }
                        },
                        child: const Text('Guardar',
                            style: TextStyle(color: AppTheme.harp)),
                      ),
                    ],
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ))
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: WidgetsToImage(
                    controller: controller,
                    child: TicketFormat(data: widget.data),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: CustomFlotingActions(
                    shareImageTicketFn: _shareImageTicket,
                    paymentFn: _paymentTicket,
                    shareLinkTicketFn: _shareLinkTicket,
                    isPaid: widget.status,
                    profile: widget.profile,
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomFlotingActions extends StatelessWidget {
  final Function shareImageTicketFn;
  final Function paymentFn;
  final Function shareLinkTicketFn;
  final String isPaid;
  final String profile;

  const CustomFlotingActions({
    super.key,
    required this.shareImageTicketFn,
    required this.paymentFn,
    required this.shareLinkTicketFn,
    required this.isPaid,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final usuario =
        Provider.of<UsuarioService>(context, listen: false).selectedUsuario;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: 'shareImageHeroTag',
          child: const Icon(Icons.offline_share, color: Colors.white),
          onPressed: () => shareImageTicketFn(),
        ),
        if (isPaid != 'P' && profile == 'ADMINISTRADOR')
          FloatingActionButton.extended(
            label: const Text("COBRAR", style: TextStyle(color: Colors.white)),
            heroTag: 'paymentHeroTag',
            backgroundColor: Colors.green[700],
            icon: const Icon(Icons.payments_outlined, color: Colors.white),
            onPressed: () => paymentFn(),
          ),
        FloatingActionButton(
          heroTag: 'shareLinkHeroTag',
          onPressed: usuario.phone != null ? () => shareLinkTicketFn() : null,
          child: const Icon(Icons.share, color: Colors.white),
        ),
      ],
    );
  }
}

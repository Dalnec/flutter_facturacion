import 'package:facturacion/src/themes/theme.dart';
import 'package:facturacion/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';

class TicketScreen extends StatefulWidget {
  final String data;
  final String status;
  final String profile;

  const TicketScreen({
    super.key,
    required this.data,
    required this.status,
    required this.profile,
  });

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final WidgetsToImageController controller = WidgetsToImageController();
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
    final Uri url = Uri.parse('https://wa.me/59165351938?text=Hello');
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
          onPressed: () {
            Navigator.of(context).pop();
            // Lógica adicional al confirmar
          },
          child: const Text('COBRAR', style: TextStyle(color: AppTheme.harp)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Previa/Acciones'),
      ),
      body: Column(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: 'shareImageHeroTag',
          child: const Icon(Icons.offline_share, color: Colors.white),
          onPressed: () => shareImageTicketFn(),
        ),
        if (isPaid != 'P' && profile != 'USUARIO')
          FloatingActionButton.extended(
            label: const Text("COBRAR", style: TextStyle(color: Colors.white)),
            heroTag: 'paymentHeroTag',
            backgroundColor: Colors.green[700],
            icon: const Icon(Icons.payments_outlined, color: Colors.white),
            onPressed: () => paymentFn(),
          ),
        FloatingActionButton(
          heroTag: 'shareLinkHeroTag',
          child: const Icon(Icons.share, color: Colors.white),
          onPressed: () => shareLinkTicketFn(),
        ),
      ],
    );
  }
}

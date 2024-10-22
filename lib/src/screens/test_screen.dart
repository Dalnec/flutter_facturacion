// import 'package:facturacion/src/widgets/ticket_format.dart';
// import 'package:flutter/material.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:typed_data';
// import 'package:url_launcher/url_launcher.dart';

// class TestScreen extends StatefulWidget {
//   const TestScreen({super.key});

//   @override
//   _TestScreenState createState() => _TestScreenState();
// }

// class _TestScreenState extends State<TestScreen> {
//   ScreenshotController screenshotController = ScreenshotController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Vista previa del Recibo')),
//       body: Screenshot(
//         controller: screenshotController,
//         child: const TicketFormat(),
//       ),
//       // floatingActionButton: FloatingActionButton(onPressed: () => _launchUrl()
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final image = await screenshotController
//               .captureFromWidget(const TicketFormat(), pixelRatio: 2);
//           Share.shareXFiles([
//             XFile.fromData(image, name: 'recibo.png', mimeType: 'image/png')
//           ]);
//         },
//         child: const Icon(Icons.camera),
//       ),
//     );
//   }

//   Future<void> _launchUrl() async {
//     final Uri url = Uri.parse('https://wa.me/59165351938?text=Hello');
//     if (!await launchUrl(url)) {
//       throw Exception('Could not launch $url');
//     }
//   }

//   Future<dynamic> ShowCapturedWidget(
//       BuildContext context, Uint8List capturedImage) {
//     return showDialog(
//       useSafeArea: false,
//       context: context,
//       builder: (context) => Scaffold(
//         appBar: AppBar(
//           title: Text("Captured widget screenshot"),
//         ),
//         body: Center(child: Image.memory(capturedImage)),
//       ),
//     );
//   }
// }

import 'package:facturacion/src/widgets/ticket_format.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
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
              child: TicketFormat(data: "data"),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: CustomFlotingActions(
              shareImageTicketFn: _shareImageTicket,
              paymentFn: () {},
              shareLinkTicketFn: _shareLinkTicket,
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
  const CustomFlotingActions({
    super.key,
    required this.shareImageTicketFn,
    required this.paymentFn,
    required this.shareLinkTicketFn,
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

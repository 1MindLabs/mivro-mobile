import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AnalyzeImageFromGalleryButton extends StatelessWidget {
  const AnalyzeImageFromGalleryButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: const Image(
        image: AssetImage('assets/icons/misc/gallery.png'),
        height: 40,
      ),
      iconSize: 32.0,
      onPressed: () async {
        final ImagePicker picker = ImagePicker();

        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image == null) {
          return;
        }

        await controller.analyzeImage(image.path);

        if (!context.mounted) {
          return;
        }

        const SnackBar snackbar = SnackBar(
          content: Text('Barcode found!'),
          backgroundColor: Colors.green,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
    );
  }
}

class ToggleFlashlightButton extends StatefulWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  State<ToggleFlashlightButton> createState() => _ToggleFlashlightButtonState();
}

class _ToggleFlashlightButtonState extends State<ToggleFlashlightButton> {
  bool _torchEnabled = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: _torchEnabled ? Colors.white : Colors.grey,
      iconSize: 32.0,
      icon: Image(
        image: AssetImage(
          _torchEnabled
              ? 'assets/icons/misc/flash-on.png'
              : 'assets/icons/misc/flash-off.png',
        ),
        height: 45,
      ),
      onPressed: () async {
        await widget.controller.toggleTorch();
        setState(() {
          _torchEnabled = !_torchEnabled;
        });
      },
    );
  }
}

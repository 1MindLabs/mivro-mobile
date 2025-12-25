import 'package:mivro/features/home/widgets/scanner_list_widget.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(children: [Expanded(child: ScannerListWidget())]);
  }
}

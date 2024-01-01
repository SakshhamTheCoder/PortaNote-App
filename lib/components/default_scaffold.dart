import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultScaffold extends StatelessWidget {
  final Widget body;
  final Widget? trailingWidget;
  final Widget? fab;
  const DefaultScaffold({
    super.key,
    this.trailingWidget,
    required this.body,
    this.fab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [trailingWidget ?? const SizedBox()],
          shape: const Border(bottom: BorderSide(color: Colors.white, width: 0.15)),
          centerTitle: true,
          toolbarHeight: 72,
          title: Text(
            'PortaNote',
            style: GoogleFonts.fingerPaint(fontSize: 40),
          )),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: body,
      ),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

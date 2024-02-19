import 'package:flutter/material.dart';

class FiltrosPage extends StatefulWidget {
  final Function functionAplicarFiltros;

  const FiltrosPage({super.key, required this.functionAplicarFiltros,});

  @override
  State<FiltrosPage> createState() => _FiltrosPageState();
}

class _FiltrosPageState extends State<FiltrosPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

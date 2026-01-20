import 'package:flutter/material.dart';

class DropdownCustom extends StatefulWidget {
  final List<dynamic> items;
  final dynamic selected;
  const DropdownCustom({super.key, this.selected,required this.items});

  @override
  State<DropdownCustom> createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  dynamic valorInicial;

  @override
  void initState() {
    valorInicial = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<dynamic>(
        initialValue: valorInicial,
        isExpanded: true,
        onChanged: (v) => setState(() => valorInicial = v),
        decoration: InputDecoration(
          hint: const Text('Selecione'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        items: widget.items.map((item) {
          return DropdownMenuItem<dynamic>(
            value: item,
            child: Text(item.titulo),
          );
        }).toList(),
      ),
    );
  }
}

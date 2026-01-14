import 'package:flutter/material.dart';

class CardPerson extends StatelessWidget {

  final void Function()? onTap;
  final Widget child;
  const CardPerson({super.key, this.onTap, required this.child});


  @override
  Widget build(BuildContext context) {
    final Color corBorda = Theme.of(context).brightness == Brightness.light ? Colors.black.withValues(alpha:0.1) : Colors.white.withValues(alpha:0.1);
    final Color codFundoCard = Theme.of(context).brightness == Brightness.light ? Colors.black.withValues(alpha: 0.07) : Colors.white.withValues(alpha: 0.15);
    
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: codFundoCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: corBorda,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsetsGeometry.all(10),
          child: child,
        ),    
      )
    );
  }
}
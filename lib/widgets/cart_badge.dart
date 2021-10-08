import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Color? color;
  final Widget? child;
  final String value;

  const Badge({Key? key, required this.child, required this.value, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child!,
        Positioned(
            right: 8,
            top: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color != null ? color : Colors.red,
              ),
              constraints: BoxConstraints(minHeight: 15, minWidth: 15),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ))
      ],
    );
  }
}

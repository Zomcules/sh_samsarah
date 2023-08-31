import 'package:flutter/material.dart';

class ProductPreviewFloatinButton extends StatelessWidget {
  final PPPType type;
  final VoidCallback onPressed;
  const ProductPreviewFloatinButton(
      {super.key, required this.type, required this.onPressed});

  _Data _data() {
    return _Data.fromType(type);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      backgroundColor: _data().buttonColor,
      child: Icon(
        _data().iconData,
        color: Colors.white,
      ),
    );
  }
}

enum PPPType { viewExternal, viewInternal, createNew }

class _Data {
  final Color buttonColor;
  final IconData iconData;

  _Data(this.buttonColor, this.iconData);

  factory _Data.fromType(PPPType type) {
    switch (type) {
      case PPPType.viewExternal:
        return _Data(
          Colors.green,
          Icons.message,
        );
      case PPPType.viewInternal:
        return _Data(
          Colors.green,
          Icons.edit,
        );
      case PPPType.createNew:
        return _Data(
          Colors.green,
          Icons.save,
        );
      default:
        return _Data(Colors.grey, Icons.signal_cellular_no_sim_sharp);
    }
  }
}

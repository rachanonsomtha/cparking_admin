import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  final Widget child;
  const CenteredView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 70, right: 70),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1600),
        child: child,
      ),
    );
  }
}

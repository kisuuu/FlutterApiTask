import 'package:flutter/material.dart';

class genLoginSignupHeader extends StatelessWidget {
  String headerName;

  genLoginSignupHeader(this.headerName);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        Text(
          headerName,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 40.0),
        ),
        const SizedBox(height: 10.0),
        const Icon(
          Icons.login,
          size: 150.0,
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}

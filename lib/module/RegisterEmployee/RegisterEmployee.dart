import 'package:flutter/material.dart';

class RegisterEmployeeScreen extends StatelessWidget {
  const RegisterEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Text("Register Screen", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          children: [Center(child: Text("Register Employee Screen"))],
        ),
      ),
    );
  }
}

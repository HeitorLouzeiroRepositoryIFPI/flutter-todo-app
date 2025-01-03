import 'package:flutter/material.dart';
import 'package:todo_app/screens/onboarding_page.dart'; // Importe sua página de onboarding

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simula um tempo de espera de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      // Após 3 segundos, redireciona para a página de onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Cor de fundo da splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aqui você pode colocar o logo do seu app ou uma animação
            Icon(
              Icons.check_circle, // Pode ser um ícone ou logo do app
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Todo App', // Nome do seu app
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

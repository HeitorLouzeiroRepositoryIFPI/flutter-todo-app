import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:todo_app/screens/home.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  final int _pageCount = 3;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40), // Espaço no topo
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pageCount,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return _buildOnboardingPage(
                        title: 'Organize sua Vida',
                        description: 'Com nosso app, você pode criar, editar e organizar suas tarefas de maneira fácil e rápida.',
                        image: Icons.list_alt,
                      );
                    case 1:
                      return _buildOnboardingPage(
                        title: 'Não Perca Prazos',
                        description: 'Adicione lembretes e receba notificações para nunca esquecer um compromisso importante.',
                        image: Icons.alarm,
                      );
                    case 2:
                      return _buildOnboardingPage(
                        title: 'Acompanhe seu Progresso',
                        description: 'Marque tarefas como concluídas e veja o quanto você já realizou!',
                        image: Icons.check_circle,
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            SmoothPageIndicator(
              controller: _controller,
              count: _pageCount,
              effect: const WormEffect(
                dotHeight: 8.0,
                dotWidth: 8.0,
                spacing: 16.0,
                dotColor: Colors.grey,
                activeDotColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 40),
            if (_currentPage == _pageCount - 1)
              ElevatedButton(
                onPressed: () {
                  // Redireciona ou fecha o onboarding
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                child: const Text('Começar Agora'),
              )
            else
              TextButton(
                onPressed: () {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Próximo'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required IconData image,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          image,
          size: 100,
          color: Colors.blue,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

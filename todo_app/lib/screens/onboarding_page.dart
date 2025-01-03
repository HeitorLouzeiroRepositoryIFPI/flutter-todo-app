import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/screens/home.dart'; // Adicionar o shared_preferences

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  final int _pageCount = 3;
  int _currentPage = 0;
  bool _dontShowAgain = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  // Carregar a preferência do usuário
  Future<void> _loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _dontShowAgain = prefs.getBool('dontShowAgain') ?? false;
    });
  }

  // Salvar a preferência do usuário
  Future<void> _savePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dontShowAgain', value);
  }

  @override
  Widget build(BuildContext context) {
    if (_dontShowAgain) {
      // Se o usuário marcou "não mostrar novamente", vai diretamente para a Home
      Future.delayed(Duration.zero, () {
        // Navegação para a Home centralizada
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      });
    }

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
                dragStartBehavior: DragStartBehavior.down, // Habilitar arraste
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Cor de fundo do botão
                  foregroundColor: Colors.white, // Cor do texto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Borda arredondada
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                ),
                child: const Text('Começar Agora'),
              )
            else
              TextButton(
                onPressed: () {
                  // Avança para a próxima página
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue, // Cor do texto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Borda arredondada
                    side: const BorderSide(color: Colors.blue), // Cor da borda
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                ),
                child: const Text('Próximo'),
              ),
            const SizedBox(height: 20),
            CheckboxListTile(
              value: _dontShowAgain,
              onChanged: (bool? value) {
                setState(() {
                  _dontShowAgain = value!;
                });
                _savePreference(_dontShowAgain); // Salvar a preferência
              },
              title: const Text("Não quero ver isso novamente"),
              controlAffinity: ListTileControlAffinity.leading,
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

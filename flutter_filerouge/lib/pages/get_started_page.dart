import 'package:flutter/material.dart';
import 'login_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Section supérieure sombre avec équations
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: const Color(0xFF4A4A4A),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEquation('f(x) = 1/3 + tan'),
                    const SizedBox(height: 15),
                    _buildEquation('cos x = Σ = (4/π)'),
                    const SizedBox(height: 15),
                    _buildEquation('y cos = 4×40× = 4×Δt'),
                    const SizedBox(height: 15),
                    _buildEquation('p(x) = Σ - (δ(x+a))'),
                    const SizedBox(height: 15),
                    _buildEquation('x = -j(ωt) = (x) - (x)f(x'),
                  ],
                ),
              ),
            ),
          ),
          // Section inférieure blanche
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Unlock Your Math\nPotential',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Master basic math concepts with interactive\n and personalized practice.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  // Bouton Get Started avec navigation
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7FDFB8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquation(String equation) {
    return Text(
      equation,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

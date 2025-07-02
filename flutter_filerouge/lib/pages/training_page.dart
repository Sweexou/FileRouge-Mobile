import 'package:flutter/material.dart';

class TrainingPage extends StatefulWidget {
  final String difficulty;
  
  const TrainingPage({Key? key, required this.difficulty}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Training',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Exercice 1: Find the Sign
            _buildExerciseCard(
              title: 'Find the Sign',
              description: 'Determine the correct mathematical sign to complete the equation.',
              icon: '×',
              onStart: () {
                print('Starting Find the Sign with difficulty: ${widget.difficulty}');
                // Navigation vers l'exercice Find the Sign
              },
            ),
            const SizedBox(height: 20),
            
            // Exercice 2: Find the Result
            _buildExerciseCard(
              title: 'Find the Result',
              description: 'Calculate the result of the given mathematical expression.',
              icon: '📊',
              onStart: () {
                print('Starting Find the Result with difficulty: ${widget.difficulty}');
                // Navigation vers l'exercice Find the Result
              },
            ),
            const SizedBox(height: 20),
            
            // Exercice 3: Find the Missing Number
            _buildExerciseCard(
              title: 'Find the Missing Number',
              description: 'Identify the missing number in the equation to make it true.',
              icon: '6_?7',
              onStart: () {
                print('Starting Find the Missing Number with difficulty: ${widget.difficulty}');
                // Navigation vers l'exercice Find the Missing Number
              },
            ),
            const SizedBox(height: 20),
            
            // Exercice 4: Test Training (nouveau)
            _buildExerciseCard(
              title: 'Test Training',
              description: 'Mixed questions combining all three exercise types for comprehensive practice.',
              icon: 'MIX',
              onStart: () {
                print('Starting Test Training with difficulty: ${widget.difficulty}');
                // Navigation vers l'exercice Test Training
              },
            ),
            
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Navigation selon l'index
          switch (index) {
            case 0:
              Navigator.pop(context); // Retour à Home
              break;
            case 1:
              // Navigation vers Leaderboard
              print('Navigate to Leaderboard');
              break;
            case 2:
              // Navigation vers Profile
              print('Navigate to Profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF7FDFB8),
        unselectedItemColor: Colors.grey,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard({
    required String title,
    required String description,
    required String icon,
    required VoidCallback onStart,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Contenu textuel
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 80,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7FDFB8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          
          // Icône/Illustration
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: Center(
              child: _buildExerciseIcon(icon),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseIcon(String iconType) {
    switch (iconType) {
      case '×':
        return const Text(
          '×',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      case '📊':
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: CustomPaint(
            painter: GraphPainter(),
          ),
        );
      case '6_?7':
        return const Text(
          '6_?7',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      case 'MIX':
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('×', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(width: 2),
                  Text('?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 2),
              Text('=', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 2),
              Text('📊', style: TextStyle(fontSize: 10)),
            ],
          ),
        );
      default:
        return const Icon(Icons.help_outline, size: 32);
    }
  }
}

// Painter pour dessiner un petit graphique
class GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1;

    // Dessiner les axes
    canvas.drawLine(
      Offset(5, size.height - 5),
      Offset(size.width - 5, size.height - 5),
      paint,
    );
    canvas.drawLine(
      Offset(5, 5),
      Offset(5, size.height - 5),
      paint,
    );

    // Dessiner une courbe simple
    final path = Path();
    path.moveTo(5, size.height - 10);
    path.quadraticBezierTo(
      size.width / 2, 10,
      size.width - 5, size.height / 2,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

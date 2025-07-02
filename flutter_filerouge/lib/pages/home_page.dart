import 'package:flutter/material.dart';
import 'training_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedDifficulty = 'Medium';
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Retire la flèche de retour
        title: const Text(
          'Math App',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              // Action pour les paramètres
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Select Difficulty
            const Text(
              'Select Difficulty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            
            // Boutons de difficulté
            Row(
              children: [
                _buildDifficultyButton('Easy'),
                const SizedBox(width: 12),
                _buildDifficultyButton('Medium'),
                const SizedBox(width: 12),
                _buildDifficultyButton('Hard'),
              ],
            ),
            const SizedBox(height: 40),
            
            // Bouton Training
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainingPage(difficulty: selectedDifficulty),
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
                  'Training',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Bouton Test
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print('Test selected with difficulty: $selectedDifficulty');
                  // Navigation vers la page de test
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7FDFB8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Test',
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Navigation selon l'index
          switch (index) {
            case 0:
              // Déjà sur Home
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

  Widget _buildDifficultyButton(String difficulty) {
    final isSelected = selectedDifficulty == difficulty;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDifficulty = difficulty;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8E8E8) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
            border: isSelected 
                ? Border.all(color: const Color(0xFF7FDFB8), width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              difficulty,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

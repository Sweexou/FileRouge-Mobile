import 'package:flutter/material.dart';
import 'package:flutter_filerouge/pages/home_page.dart';
import '../models/leaderboard_user.dart';
import '../services/leaderboard_service.dart';
import 'profile_page.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<LeaderboardUser> _leaderboard = [];
  bool _isLoading = true;
  int _currentIndex = 1; // Leaderboard tab selected

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    try {
      final leaderboard = await LeaderboardService.getLeaderboard();
      setState(() {
        _leaderboard = leaderboard;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading leaderboard: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshLeaderboard() async {
    setState(() {
      _isLoading = true;
    });
    await _loadLeaderboard();
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF7FDFB8); // Default green
    }
  }

  IconData _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events; // Trophy
      case 2:
        return Icons.military_tech; // Medal
      case 3:
        return Icons.military_tech; // Medal
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Leaderboard',
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
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: _refreshLeaderboard,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7FDFB8),
              ),
            )
          : _leaderboard.isEmpty
              ? const Center(
                  child: Text(
                    'No leaderboard data available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshLeaderboard,
                  color: const Color(0xFF7FDFB8),
                  child: Column(
                    children: [
                      // Top 3 podium section
                      if (_leaderboard.length >= 3) _buildPodium(),
                      
                      // Rest of the leaderboard
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _leaderboard.length - (_leaderboard.length >= 3 ? 3 : 0),
                          itemBuilder: (context, index) {
                            final actualIndex = index + (_leaderboard.length >= 3 ? 3 : 0);
                            final user = _leaderboard[actualIndex];
                            final rank = actualIndex + 1;
                            
                            return _buildLeaderboardItem(user, rank);
                          },
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
              break;
            case 1:
              break;
            case 2:
              // Navigation vers Profile
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
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

  Widget _buildPodium() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF7FDFB8).withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          if (_leaderboard.length >= 2) _buildPodiumPlace(_leaderboard[1], 2, 80),
          // 1st place
          _buildPodiumPlace(_leaderboard[0], 1, 100),
          // 3rd place
          if (_leaderboard.length >= 3) _buildPodiumPlace(_leaderboard[2], 3, 60),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(LeaderboardUser user, int rank, double height) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _getRankColor(rank),
            shape: BoxShape.circle,
            border: Border.all(
              color: _getRankColor(rank),
              width: 3,
            ),
          ),
          child: Center(
            child: rank <= 3
                ? Icon(
                    _getRankIcon(rank),
                    color: Colors.white,
                    size: 30,
                  )
                : Text(
                    user.userName.isNotEmpty ? user.userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        
        // Username
        Text(
          user.userName,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        
        // Score
        Text(
          '${user.score}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _getRankColor(rank),
          ),
        ),
        const SizedBox(height: 8),
        
        // Podium base
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: _getRankColor(rank).withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(
              color: _getRankColor(rank),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _getRankColor(rank),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(LeaderboardUser user, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rank <= 10 
                  ? const Color(0xFF7FDFB8).withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: rank <= 10 
                      ? const Color(0xFF7FDFB8)
                      : Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF7FDFB8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.userName.isNotEmpty ? user.userName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Username
          Expanded(
            child: Text(
              user.userName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Score
          Text(
            '${user.score}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7FDFB8),
            ),
          ),
        ],
      ),
    );
  }
}

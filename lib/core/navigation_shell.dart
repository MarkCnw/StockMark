import 'package:flutter/material.dart';
import 'package:stockmark/features/home/presentation/screens/home_screen.dart';
import 'package:stockmark/features/news/presentation/screens/news_screen.dart';
import 'package:stockmark/features/profile/profie_screen.dart';
import 'package:stockmark/features/watchlist/presentation/screens/watchlist_screen.dart';
import 'package:svg_flutter/svg.dart';

class NavigationShell extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const NavigationShell({super.key, required this.onToggleTheme});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ สร้าง screens ที่นี่แทน initState()
    final screens = [
      const HomeScreen(),
      const NewsScreen(),
      const NewsScreen(),
      ProfileScreen(onToggleTheme: widget.onToggleTheme),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/navigation/house-regular.svg',
              width: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/navigation/house-solid.svg',
              width: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/navigation/star-regular.svg',
              width: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/navigation/star-solid.svg',
              width: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Watchlist',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/navigation/file-zipper-regular.svg',
              width: 18,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/navigation/file-zipper-solid.svg',
              width: 18,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'News',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/navigation/user-regular.svg',
              width: 20,
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/navigation/user-solid.svg',
              width: 20,
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? Colors.blueAccent : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

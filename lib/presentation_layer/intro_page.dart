import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _selectedIndex = 0;
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intro Page'),
      ),
      drawer: _buildDrawer(),
      body: const Center(
        child: Text('This is a intro page of the application'),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.design_services), label: 'Generate'),
        BottomNavigationBarItem(icon: Icon(Icons.autorenew), label: 'Random'),
      ],
      currentIndex: _selectedIndex,
      onTap: _onTapped,
    );
  }

  _buildDrawer() {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: const Text(
            'More menu',
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.secondary),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.ring_volume),
          title: const Text('Subscription'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('Bookmarks'),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Dark Theme'),
          trailing: _buildThemeToggleSwitch(),
        ),
      ],
    ));
  }

  _buildThemeToggleSwitch() {
    return Switch.adaptive(
        value: isDarkModeEnabled, onChanged: _onThemeChanged);
  }

  _onTapped(currIndex) {
    setState(() {
      _selectedIndex = currIndex;
    });
  }

  _onThemeChanged(bool newValue) {
    setState(() {
      isDarkModeEnabled = newValue;
    });
  }
}

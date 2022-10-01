import 'package:flutter/material.dart';

import 'meme_generator_page.dart';
import 'random_meme_generator_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _selectedIndex = 0;
  bool isDarkModeEnabled = false;
  late PageController _intoPageController;

  @override
  void initState() {
    super.initState();
    _intoPageController = PageController(initialPage: 0);
  }

//////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intro Page'),
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildBody() {
    return PageView(
      controller: _intoPageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
        MemeGeneratorPage(),
        RandomMemeGeneratorPage(),
      ],
    );
  }

  _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.design_services), label: 'Generate'),
        BottomNavigationBarItem(icon: Icon(Icons.autorenew), label: 'Random'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Colors.blueGrey,
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

    _intoPageController.jumpToPage(currIndex);
  }

  _onThemeChanged(bool newValue) {
    setState(() {
      isDarkModeEnabled = newValue;
    });
  }
}

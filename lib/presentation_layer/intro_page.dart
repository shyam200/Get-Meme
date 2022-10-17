import 'package:flutter/material.dart';
import 'package:get_meme/injection/injection_container.dart';
import 'package:get_meme/presentation_layer/more_menu/wishlist_page.dart';
import 'package:get_meme/resources/string_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'meme_generator/meme_generator_page.dart';
import 'random_meme_generator/random_meme_generator_page.dart';

class IntroPage extends StatefulWidget {
  final Function function;
  const IntroPage({Key? key, required this.function}) : super(key: key);

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
    isDarkModeEnabled =
        di<SharedPreferences>().getBool(StringKeys.isDarkTheme) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meme App'),
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
    return Container(
      decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(width: 0.5, color: Colors.grey)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              tooltip: 'Generate your own meme',
              icon: Icon(Icons.design_services),
              label: 'Generate meme'),
          BottomNavigationBarItem(
              tooltip: 'Choose a random meme',
              icon: Icon(Icons.autorenew),
              label: 'Random meme'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.blueGrey,
        onTap: _onTapped,
      ),
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
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const WishlistPage()));
            // Navigator.of(context).pop();
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
    widget.function(newValue);
    setState(() {
      isDarkModeEnabled = newValue;
    });
  }
}

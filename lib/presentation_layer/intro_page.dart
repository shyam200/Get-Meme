import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../injection/injection_container.dart';
import '../resources/string_keys.dart';
import '../resources/styles/text_styles.dart';
import 'meme_generator/meme_generator_page.dart';
import 'more_menu/wishlist_page.dart';
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
        title: const Text(
          StringKeys.mainPageTitle,
          style: TextStyles.appTitleText,
          // GoogleFonts.robotoSerif(
          //     fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
              tooltip: StringKeys.generateMemeTootip,
              icon: Icon(Icons.design_services),
              label: StringKeys.generateMeme),
          BottomNavigationBarItem(
              tooltip: StringKeys.chooseMemelabel,
              icon: Icon(Icons.autorenew),
              label: StringKeys.randomMemelabel),
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
        _buildDrawerHeader(),
        _buildListItem(icon: Icons.settings, title: StringKeys.settings),
        _buildListItem(icon: Icons.ring_volume, title: StringKeys.subscription),
        _buildListItem(
          icon: Icons.bookmark,
          title: StringKeys.bookmarks,
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const WishlistPage()));
            // Navigator.of(context).pop();
          },
        ),
        _buildListItem(
            icon: Icons.dark_mode,
            title: StringKeys.darkTheme,
            trailing: _buildThemeToggleSwitch()),
      ],
    ));
  }

  ListTile _buildListItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
      onTap: onTap ?? popDrawer,
    );
  }

  DrawerHeader _buildDrawerHeader() {
    return DrawerHeader(
      child: const Text(
        StringKeys.moreMenu,
        style: TextStyle(fontSize: 30.0, color: Colors.white),
      ),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
    );
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

  void popDrawer() {
    Navigator.of(context).pop();
  }
}

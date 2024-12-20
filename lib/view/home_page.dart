import 'package:provider/provider.dart';
import 'package:tourisme/view/settings.dart';

import 'package:tourisme/service/auth.dart';
import 'allresto.dart';
import 'log.dart';
import 'package:flutter/material.dart';
import 'Profile.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourisme/models/hotel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hotels.dart';
import 'attraction_page.dart';

import 'favhotel.dart';
import 'favatt.dart';

class HoMepa extends StatefulWidget {
  final String email;

  const HoMepa({Key? key, required this.email}) : super(key: key);

  @override
  _HoMepaState createState() => _HoMepaState();
}

class _HoMepaState extends State<HoMepa> {
  int _currentIndex = 0;
  List<Color> _favIconColors = [];
  List<Color> _favIconColors1 = [];
  String selectedPage = '';
  List _items = [];
  List<int> selectedItem = [];

  @override
  void initState() {
    super.initState();
    _favIconColors = List.generate(5, (index) => Color(0xffffffff));
    _favIconColors1 = List.generate(4, (index) => Color(0xffdcdbdb));
    // Call the method to read JSON data during initialization
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FireAuth>(context, listen: false);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          "images/zak.jpg",
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Color(0xFF1E0342),
          appBar: AppBar(
            backgroundColor: Color(0xff4d72b7),
            bottomOpacity: 0.5,
            leadingWidth: 30,
            elevation: 0.2,
            leading: IconButton(
              onPressed: () async {
                auth.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LogPage()),
                );
              },
              icon: Icon(Icons.logout),
            ),
            centerTitle: true,
            title: Text(
              'Tourismapp',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Raleway',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          endDrawer: Drawer(
            width: 300,
            elevation: 1.0,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 100,
                  child: const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xff368ff4),
                      gradient: LinearGradient(
                        colors: [Color(0xff4fa2f1), Color(0xff368ff4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.blue),
                  leading: const Icon(Icons.hotel, color: Colors.blue),
                  title: const Text(
                    'Favorite Hotels',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff0a0a0a),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedPage = 'favhotel';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavPage()),
                      );
                    });
                  },
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Color(0x319c9292),
                ),
                ListTile(
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.blue),
                  leading: const Icon(Icons.attractions, color: Colors.blue),
                  title: const Text(
                    'Favorite Attractions',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff090909),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedPage = 'favattraction';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteAttractionsPage()),
                      );
                    });
                  },
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Color(0x319c9292),
                ),
                ListTile(
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.blue),
                  leading: const Icon(Icons.settings, color: Colors.blue),
                  title: const Text(
                    'Settings',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedPage = 'Settings';
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    });
                  },
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Color(0x319c9292),
                ),
                ListTile(
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.blue),
                  leading: const Icon(Icons.home, color: Colors.blue),
                  title: const Text(
                    'Close Drawer',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedPage = 'close it';
                      Navigator.pop(context); // Close the drawer
                    });
                  },
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Color(0x319c9292),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.blue),
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.blue),
                  title: const Text(
                    'Help',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedPage = 'Help';
                      SystemNavigator.pop();
                    });
                  },
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Color(0x319c9292),
                ),
                ListTile(
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.blue),
                  leading:
                      const Icon(Icons.contact_support, color: Colors.blue),
                  title: const Text(
                    'Contact Us',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedPage = 'Contact us';
                    });
                    final url = "tel:+212620018359";
                    print('linkl');
                    Future<void> _launchUrl(url) async {
                      if (!await launch(url)) {
                        throw Exception('Could not launch $url');
                      }
                      ;
                    }

                    ;
                  },
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Color(0x319c9292),
                ),
                ListTile(
                  trailing: const Icon(Icons.keyboard_arrow_right,
                      color: Colors.blue),
                  leading: const Icon(Icons.logout, color: Colors.blue),
                  title: const Text(
                    'Log Out',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      auth.logout();
                      selectedPage = 'Log_out';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogPage()),
                      );
                    });
                  },
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Color(0x319c9292),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.blue),
                  title: const Text(
                    'Exit',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedPage = 'exit';
                      SystemNavigator.pop();
                    });
                  },
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Color(0x319c9292),
                ),
              ],
            ),
          ),
          body: _buildBody(_currentIndex),
          bottomNavigationBar: Stack(
            children: <Widget>[
              SizedBox(
                height: 58,
                child: BottomNavigationBar(
                  backgroundColor: Color(0xFFE1F7F5),
                  elevation: 0.0,
                  currentIndex: _currentIndex,
                  selectedItemColor: Color(0xf00000b2),
                  onTap: _onItemTapped,
                  unselectedItemColor: Color(0xf7f89500),
                  unselectedLabelStyle: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                  useLegacyColorScheme: true,
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        color: Color(0xff050202),
                        size: 20.0,
                      ),
                      label: 'Home',
                    ),

                    BottomNavigationBarItem(
                        backgroundColor: Color(0xff1202f9),
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        label: 'Profile',
                        tooltip: 'go to profile'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return _buildHome();
      case 1:
        return ProfilePage(email: "");

      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    final List<String> imageAssets = [
      "images/Kasba_Taourirt_1 (2).jpg",
      "images/fes1.jpg",
      "images/had.jpg",
      "images/daraas.jpg",
    ];
    final List<String> imageDescriptions = [
      "Ville:Fes",
      "Marrakech",
      "tetouan",
      "ouarzazte",
    ];
    final List<String> imagehotel = [
      "images/hotels/zahra.webp",
      "images/hotels/chezyou.jpg",
      "images/hotels/isabel.jpg",
      "images/hotels/kasbah.JPG",
    ];
    final List<String> villehotel = [
      "Ville:Merzouga",
      "Ville:Marzouga",
      "Ville:boumalne",
      "Ville:Errachidia",
    ];

    final List<String> resto = [
      "images/resto.jfif",
      "images/resto1.jfif",
      "images/resto2.jfif",
      "images/resto3.jfif",
    ];
    final List<String> villemonu = [
      "Ville:Zagoura",
      "Ville:ouarzazate",
      "Ville:boumalne",
      "Ville:Errachidia",
    ];
    return Container(
      margin: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('images/ddmo.jpg'),
        fit: BoxFit.cover,
      )),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          ListTile(
            leading: const Text(
              'Attractions:',
              style: TextStyle(
                color: Color(0xff443433),
                fontFamily: 'Raleway',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttractionsPage(),
                  ),
                );
                print('passed');
              },
              child: Text(
                'View all attraction',
                style: TextStyle(
                  fontFamily: 'raleway',
                  color: Color(0xff13162b),
                  // Customize the color if needed
                ),
              ),
            ),
          ),
          _buildImageAssetListe1(
              imageAssets, imageDescriptions, _favIconColors),
          ListTile(
            leading: const Text(
              'Hotels:',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 24,
                color: Color(0xff13162b),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelsPage(),
                  ),
                );
                print('passed');
              },
              child: const Text(
                'View all hotels',
                style: TextStyle(
                  color: Color(0xff13162b),
                  fontFamily: 'raleway',
                  // Customize the color if needed
                ),
              ),
            ),
          ),
          _buildImageAssetListe2(imagehotel, villehotel, _favIconColors),
          ListTile(
            leading: const Text(
              'Restaurant:',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 24,
                color: Color(0xff13162b),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RestoPage(),
                  ),
                );
                print('passed');
              },
              child: const Text(
                'View all restaurants',
                style: TextStyle(
                  color: Color(0xff13162b),
                  fontFamily: 'raleway',
                  // Customize the color if needed
                ),
              ),
            ),
          ),
          _buildImageAssetListe3(resto, villehotel, _favIconColors)
        ],
      ),
    );
  }

  Widget _buildImageAssetListe1(
      List<String> images, List<String> descriptions, List<Color> colors) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(5),
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              elevation: 2,
                              content: Text("Tap View all"),
                              contentTextStyle:
                                  const TextStyle(color: Colors.red),
                              actions: [
                                BackButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        // Define your onTap functionality here
                        print('Image tapped: ${images[index]}');
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: SizedBox(
                          width: 340,
                          height: 240,
                          child: Image.asset(
                            images[index],
                            height: 240,
                            width: 350,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageAssetListe2(
      List<String> imagehotel, List<String> villehotel, List<Color> colors) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imagehotel.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 280,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                  child:
                      ClipRRect(

                        borderRadius: BorderRadius.circular(20.0),
                        child: SizedBox(
                          width: 340,
                          height: 240,
                          child: Image.asset(
                            imagehotel[index],
                            height: 240,
                            width: 350,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),),
                      Text(villehotel[index],
                          style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildImageAssetListe3(
    List<String> imagehotel, List<String> villehotel, List<Color> colors) {
  return Column(
    children: [
      SizedBox(
        height: 280,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imagehotel.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: EdgeInsets.all(5),
                height: 280,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        width: 340,
                        height: 240,
                        child: Image.asset(
                          imagehotel[index],
                          height: 240,
                          width: 350,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

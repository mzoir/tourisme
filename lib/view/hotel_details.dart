import 'package:tourisme/view/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'log.dart';
import 'Profile.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:tourisme/models/hotel.dart';
import 'hotels.dart';
import 'hotel_details.dart';
import 'attraction_page.dart';

class eveHotel extends StatefulWidget {
  final Hotel item;
  const eveHotel({super.key, required this.item});
  _eveHotelState createState() => _eveHotelState();
}

class _eveHotelState extends State<eveHotel> {
  String selectedPage = '';
  List im = [""];
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HoMepa(email: ''),
          ),
        );
      } else if (index == 1) {
        setState(() {
          SystemNavigator.pop();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isHovering = false;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Hotel Info',
          style: TextStyle(color: Colors.white, fontSize: 28.0),
        ),
        backgroundColor: Color(0xFF2854B2),
        elevation: 4, // Adding shadow to AppBar
      ),
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        width: 300,
        elevation: 2.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              child: const DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(color: Color(0xff368ff4)),
                child: ListTile(
                  leading: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 22)),
                  trailing: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            ListTile(
              trailing: const Icon(
                Icons.keyboard_arrow_right,
              ),
              leading: const Icon(Icons.home),
              title: const Text(
                'Close it',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              endIndent: 0,
              color: Color(0x319c9292),
            ),
            ListTile(
              trailing: const Icon(
                Icons.keyboard_arrow_right,
              ),
              leading: const Icon(Icons.contact_emergency),
              title: const Text(
                'Contact us',
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
                });
              },
            ),
            const Divider(
              height: 20,
              endIndent: 0,
              color: Color(0x319c9292),
            ),
            ListTile(
              trailing: const Icon(
                Icons.keyboard_arrow_right,
              ),
              leading: const Icon(Icons.logout),
              title: const Text(
                'Log out',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedPage = 'Log_out';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogPage(),
                    ),
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
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
              endIndent: 0,
              color: Color(0x319c9292),
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: im.length,
          itemBuilder: (context, index) {
            return Container(
              height: 650,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.item.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: SizedBox(
                      width: 340,
                      height: 240,
                      child: Image.network(
                        widget.item.images[0], // Assuming image is provided by item
                        height: 240,
                        width: 360,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    endIndent: 0,
                    color: Color(0x319c9292),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: SizedBox(
                      width: 340,
                      height: 240,
                      child: Image.network(
                        widget.item.images[1], // Assuming image is provided by item
                        height: 240,
                        width: 360,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      'Price: \$${widget.item.price}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        final Uri _url = Uri.parse(widget.item.map);
                        Future<void> _launchUrl() async {
                          if (!await launchUrl(_url)) {
                            throw Exception('Could not launch $_url');
                          }
                        }
                        _launchUrl();
                      },
                      icon: const Icon(Icons.map, color: Colors.black, size: 35),
                      tooltip: 'Location!',
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start, // Align to the end (right)
                    children: [
                      ElevatedButton(
                        child: InkWell(
                          onTap: () {
                            final Uri _url = Uri.parse(widget.item.reservation_link);
                            Future<void> _launchUrl() async {
                              if (!await launchUrl(_url)) {
                                throw Exception('Could not launch $_url');
                              }
                            }
                            _launchUrl();
                          },
                          onHover: (hovering) {
                            setState(() => isHovering = hovering);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                            padding: EdgeInsets.all(isHovering ? 16 : 10),
                            decoration: BoxDecoration(
                              color: isHovering ? Colors.indigoAccent : Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'Reserve Hotel',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 5, // button's elevation when it's pressed
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        child: InkWell(
                          onTap: () {
                            final url = "tel:${widget.item.phone_number}";
                            Future<void> _launchUrl(url) async {
                              if (!await launch(url)) {
                                throw Exception('Could not launch $url');
                              }
                            }
                            _launchUrl(url);
                          },
                          onHover: (hovering) {
                            setState(() => isHovering = hovering);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                            padding: EdgeInsets.all(isHovering ? 16 : 10),
                            decoration: BoxDecoration(
                              color: isHovering ? Colors.indigoAccent : Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'Contact',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 5, // button's elevation when it's pressed
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

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
      }
      else if (index == 1) {
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
        title: Text('info', style: TextStyle(color: Colors.white,fontSize: 28.0)),
        backgroundColor: Color(0xFF2854B2), // Set app bar color from palette
      ),
      backgroundColor: Color(0xFF07B0E3),
      endDrawer: Drawer(
        width: 300,
        elevation: 1.0,

        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              child: const DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(color: Color(0xff368ff4)),
                child: ListTile(
                  leading: Text('menu'),
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
                'close it',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                'exit',
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
                      Text(widget.item.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 23.0)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: SizedBox(
                          width: 340,
                          height: 240,
                          child: Image.network(
                            widget.item.images[
                                0], // Assuming image is provided by item
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
                            widget.item.images[
                                1], // Assuming image is provided by item
                            height: 240,
                            width: 360,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Text('price: \$${widget.item.price}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        trailing: IconButton(
                          onPressed: () {
                            final Uri _url = Uri.parse(widget.item.map);
                            print('linkl');
                            Future<void> _launchUrl() async {
                              if (!await launchUrl(_url)) {
                                throw Exception('Could not launch $_url');
                              }
                            }
                            _launchUrl();
                            print('hhh');
                          },

                          icon: const Icon(Icons.map,
                              color: Colors.black, size: 35),
                          tooltip: 'location!',
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Align to the end (right)
                        children: [
                          ElevatedButton(

                            child : InkWell(
                              onTap:() {
                                final Uri _url = Uri.parse(widget.item.reservation_link);
                                print('linkl');
                                Future<void> _launchUrl() async {
                                  if (!await launchUrl(_url)) {
                                    throw Exception('Could not launch $_url');
                                  }
                                }
                                _launchUrl();
                                print('hhh');
                              },
                              onHover: (hovering) {
                                setState(() => isHovering = hovering);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease,
                                padding: EdgeInsets.all(isHovering ? 16: 10),
                                decoration: BoxDecoration(
                                  color: isHovering ? Colors.indigoAccent : Colors.green,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Text(
                                  'Reserver hotel',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                              elevation:
                                  5, // button's elevation when it's pressed
                            ),

                          ),
                          SizedBox(width: 20),
                          ElevatedButton(

                            child : InkWell(
                              onTap:() {
                                final url = "tel:${widget.item.phone_number}";
                                print('linkl');
                                Future<void> _launchUrl(url) async {
                                  if (!await launch(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                }
                                _launchUrl(url);
                                print('hhh');
                                print('linkl');
                              },
                              onHover: (hovering) {
                                setState(() => isHovering = hovering);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease,
                                padding: EdgeInsets.all(isHovering ? 16: 10),
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
                              elevation:
                              5, // button's elevation when it's pressed
                            ),

                          ),// Add some spacing from the edge
                        ],
                      ),
                    ],
                  ));
            }),
      ),
      bottomNavigationBar: Builder(
        // Wrap with Builder widget
        builder: (context) => Stack(
          children: <Widget>[
            SizedBox(
              height: 58,
              child: BottomNavigationBar(
                backgroundColor: Color(0xffc8b7f8),
                elevation: 0.0,
                currentIndex: _currentIndex,
                selectedItemColor: Color(0xf0f6f7fb),
                onTap: _onItemTapped,
                unselectedItemColor: Color(0xf7f8e700),
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
                    icon: Icon(
                      Icons.sort,
                      color: Color(0xff050202),
                      size: 20.0,
                    ),
                    label: 'Exit',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

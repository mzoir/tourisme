import 'package:flutter/material.dart';
import 'package:tourisme/models/attraction.dart';

class AttractionDetails extends StatefulWidget {
  final Attraction item;

  const AttractionDetails({super.key, required this.item});

  @override
  _AttractionDetailsState createState() => _AttractionDetailsState();
}

class _AttractionDetailsState extends State<AttractionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(231, 225, 214, 1.0),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Info', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFACE1AF), // Set app bar color from palette
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            ListTile(
                leading: Text(
                  widget.item.name,
                  style: TextStyle(
                    color: Color(0xff443433),
                    fontFamily: 'Raleway',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing:Text(
                  widget.item.location,
                  style: TextStyle(
                    color: Color(0xffc42d11),
                    fontFamily: 'Raleway',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),),
            if (widget.item.image.isNotEmpty)
              Image.network(
                widget.item.image[0],
                width: 340,
                height: 240,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 10),
            if (widget.item.image.length > 1)
              Image.network(
                widget.item.image[1],
                fit: BoxFit.cover,
                width: 340,
                height: 240,

              ),
            const SizedBox(height: 20),
            Text(
              widget.item.description,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

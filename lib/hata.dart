import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/main.dart';

class Hata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          "Hata!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        shadowColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 40, right: 40, top: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red.shade300,
            ),
            height: 120,
            width: double.infinity,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Bir hata meydana geldi. Lütfen Tekrar deneyiniz.",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GirisSayfasi()));
              },
              child: Text(
                "Giriş sayfasına dön",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ))
        ],
      ),
    );
  }
}

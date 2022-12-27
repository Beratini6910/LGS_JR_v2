import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/dersler/fensorular.dart';
import 'package:lgs_jr_v2/dersler/genel.dart';
import 'package:lgs_jr_v2/dersler/matematiksorular.dart';
import 'package:lgs_jr_v2/dersler/ozel_sinav_girisi.dart';
import 'package:lgs_jr_v2/dersler/sosyalsorular.dart';
import 'package:lgs_jr_v2/dersler/turkcesorular.dart';
import 'package:lgs_jr_v2/dersler/sinav_olustur.dart';
import 'package:lgs_jr_v2/main.dart';
import 'package:page_transition/page_transition.dart';
import 'hesapIslemleri/hesap_olustur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:lgs_jr_v2/globals.dart' as globals;

class Ogretmen_Anasayfa extends StatefulWidget {
  @override
  _Ogretmen_AnasayfaState createState() => _Ogretmen_AnasayfaState();
}

class _Ogretmen_AnasayfaState extends State<Ogretmen_Anasayfa> {
  //final _formKontrol = GlobalKey<FormState>();
  String? kullaniciAdi, email, sifre;

  //final ref =  await FirebaseFirestore.instance
  //   .doc('users/$userId').get();
  //final value = ref.get('name');

  @override
  Widget build(BuildContext context) {

    List? data = [];
    data = (ModalRoute.of(context)!.settings.arguments as List?);
    var kullaniciAdi = data![0];
    var email = data[1];
    var sifre = data[2];

    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Sınav Listesi",
          style: TextStyle(
              color: Colors.white
          ),),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/c1.jpg"),
                fit: BoxFit.cover
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.purple.shade900,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.purple
                        ),
                        child: const Text("Mevcut Sınavlar:",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue.withOpacity(0.5)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red.shade400),
                              ),
                              onPressed: () {
                                Navigator.push(context,PageTransition(type: PageTransitionType.topToBottom,
                                    child: GenelSorular(),
                                    duration: const Duration(milliseconds: 400),
                                    reverseDuration: const Duration(milliseconds: 600),
                                    settings: RouteSettings
                                      (
                                      arguments: data,
                                    )));
                              },
                              child: const Text("Genel Deneme (40 Soru) ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,

                                ),),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  width: 3.0,
                                  color: Colors.blueAccent
                                ),
                                backgroundColor: Colors.blue.shade200
                                //backgroundColor: MaterialStateProperty.all(Colors.blue.shade200),
                              ),
                              onPressed: () {
                                Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft,
                                    child: TurkceSorular(),
                                    duration: const Duration(milliseconds: 600),
                                    reverseDuration: const Duration(milliseconds: 600),
                                    settings: RouteSettings
                                      (
                                      arguments: data,
                                    )));
                              },
                              child: const Text("Türkçe (10 Soru)",
                                style: TextStyle(

                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      width: 3.0,
                                      color: Colors.blueAccent
                                  ),
                                  backgroundColor: Colors.blue.shade200
                                //backgroundColor: MaterialStateProperty.all(Colors.blue.shade200),
                              ),
                              onPressed: () {
                                Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft,
                                    child: MatematikSorular(),
                                    duration: const Duration(milliseconds: 400),
                                    reverseDuration: const Duration(milliseconds: 600),
                                    settings: RouteSettings
                                      (
                                      arguments: data,
                                    )));
                              },
                              child: const Text("Matematik (10 Soru)",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      width: 3.0,
                                      color: Colors.blueAccent
                                  ),
                                  backgroundColor: Colors.blue.shade200
                                //backgroundColor: MaterialStateProperty.all(Colors.blue.shade200),
                              ),
                              onPressed: () {
                                Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft,
                                    child: FenSorular(),
                                    duration: const Duration(milliseconds: 400),
                                    reverseDuration: const Duration(milliseconds: 600),
                                    settings: RouteSettings
                                      (
                                      arguments: data,
                                    )));
                              },
                              child: const Text("Fen Bilimleri (20 Soru)",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      width: 3.0,
                                      color: Colors.blueAccent
                                  ),
                                  backgroundColor: Colors.blue.shade200
                                //backgroundColor: MaterialStateProperty.all(Colors.blue.shade200),
                              ),
                              onPressed: () {
                                Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft,
                                    child: SosyalSorular(),
                                    duration: const Duration(milliseconds: 400),
                                    reverseDuration: const Duration(milliseconds: 600),
                                    settings: RouteSettings
                                      (
                                      arguments: data,
                                    )));
                              },
                              child: const Text("Sosyal Bilgiler (10 Soru)",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),

                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.green),
                              ),
                              onPressed: () {
                                Navigator.push(context,PageTransition(type: PageTransitionType.bottomToTop,
                                    child: Ozel_Sinav_Girisi(),
                                    duration: const Duration(milliseconds: 400),
                                    reverseDuration: const Duration(milliseconds: 600),
                                    settings: RouteSettings
                                      (
                                      arguments: data,
                                    )));
                              },
                              child: const Text("Özel Sınav",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.green),
                              ),
                              onPressed: () {
                                Navigator.push(context,PageTransition(type: PageTransitionType.fade,
                                    child: Sinav_Olustur(),
                                    duration: const Duration(milliseconds: 1000),
                                    reverseDuration: const Duration(milliseconds: 600),
                                    settings: RouteSettings
                                      (
                                      arguments: data,
                                    )));
                              },
                              child: const Text("Özel Sınav Oluştur",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),),

                            ),
                          ),

                        ],
                      ),
                    ),

                    /*ElevatedButton(onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => GirisSayfasi(),
                        settings: RouteSettings(
                        arguments: data,)
                        ),
                        );
                          },
                        child: Text("Çıkış Yap",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),

                      ),*/
                    const SizedBox(height: 10),
                    Center(child: GestureDetector(
                      onDoubleTap: (){
                        globals.kullaniciTuru = 0;
                        Navigator.push(context,PageTransition(type: PageTransitionType.leftToRight,
                            child: GirisSayfasi(),
                            duration: const Duration(milliseconds: 400),
                            reverseDuration: const Duration(milliseconds: 600),
                            settings: RouteSettings
                              (
                              arguments: data,
                            )));
                      },

                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orange,
                            width: 2,
                          ),
                          color: Colors.purple.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Çıkış Yapmak için iki defa tıklayınız",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    ),/*ElevatedButton(onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenelSorular(),
                          settings: RouteSettings(
                            arguments: data,)));
                })*/
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



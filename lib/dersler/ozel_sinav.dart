import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lgs_jr_v2/analizler/ozel_analiz.dart';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/analizler/analiz.dart';
import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/dersler/fensorular.dart';
import 'package:lgs_jr_v2/dersler/ozel_sinav_girisi.dart';
import 'package:lgs_jr_v2/main.dart';
import 'package:lgs_jr_v2/globals.dart' as globals;


class Ozel_Sinav extends StatefulWidget {
  @override
  _Ozel_SinavState createState() => _Ozel_SinavState();
}

String zaman(int milisaniye) {
  var saniye = milisaniye ~/ 1000;
  var dakika = ((saniye % 3600) ~/ 60).toString().padLeft(2, '0');
  var saniyeler = (saniye % 60).toString().padLeft(2, '0');
  return "$dakika:$saniyeler";
}


class _Ozel_SinavState extends State<Ozel_Sinav> with TickerProviderStateMixin{
  bool _isAbsorbing = false;
  bool buttonEnabled = true;

  String kullaniciAdi = '';
  String email = '';
  String sifre = '';
  String sinavAdi1 = 'Genel Deneme';
  int soru2 = 0;
  double net = 0;
  var bilgiler = [];
  int dogru = 0;
  int yanlis = 0;
  var cevaplar = [];

  String konu = "";
  String soru = "";
  String sik1 = "";
  String sik2 = "";
  String sik3 = "";
  String sik4 = "";

  String sinavSuresi1 = "10";
  int sinavSuresi = 0;
  int sayi = 0;
  int sayi1 = 1;
  int sayix = 1;
  String Soru1 = "Soru";
  String A = "A";
  String B = "B";
  String C= "C";
  String D = "D";
  String sonuc = "";
  String sinavAdi = "BoşSınav";
  String sinav_sifresi = "";
  String dogru_cevap = "";
  int soruSayisi = 1;
  int sonSoruHatasi = 0;
  int cozulen = 0;

  late Stopwatch _sayac;
  late Timer _timer;

  void NetYuvarla(deger) {
    String inString = deger.toStringAsFixed(1);
    net = double.parse(inString);
  }

  @override
  void initState() {



    sinavAdi1 = globals.sinavismi;

    FirebaseFirestore.instance.collection("Sinavlar")
        .doc(sinavAdi1)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      sinavAdi = data["0_Sinavin_Adi"];
      sinav_sifresi = data["00_Sinavi_Olusturan_Hesap_Maili"];
      sinavSuresi = data["0_Sinav_Suresi"];
      soruSayisi = data["0_Soru_Sayisi"];


      for(var i = 1; i <= soruSayisi; i++){

        soru = data[sayi1.toString()+"Soru"];
        sik1 = data[sayi1.toString()+"_A"];
        sik2 = data[sayi1.toString()+"_B"];
        sik3 = data[sayi1.toString()+"_C"];
        sik4 = data[sayi1.toString()+"_D"];
        sonuc = data[sayi1.toString()+"_Dogru"];
        konu = data[sayi1.toString()+"_Konu"];

        bilgiler.add(soru);
        bilgiler.add(sik1);
        bilgiler.add(sik2);
        bilgiler.add(sik3);
        bilgiler.add(sik4);
        bilgiler.add(sonuc);
        sayi1++;
      }


      print(sinavAdi);
      print(sinav_sifresi);
      print(sik1);
      print(sonuc);
      setState(() {

      });
    });

    super.initState();


    _sayac = Stopwatch();
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {});
    });

  }
  



  /*
  @override
  void initState() {
    super.initState();
    _sayac = Stopwatch();
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }
 */


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void aktif(){
    if(buttonEnabled == false){
      absorbing: false;
    }
    else{
      absorbing: true;
    }

  }

  void AnalizeGonder(){
    String ders = sinavAdi;
    int ozel = 1;

    NetYuvarla(net);

    var data = [];
    data.add(kullaniciAdi);
    data.add(email);
    data.add(ders);
    data.add(net);
    data.add(zaman(_sayac.elapsedMilliseconds+1000));
    data.add(sayi);
    data.add(dogru);
    data.add(yanlis);
    data.add(ozel);
    data.add(soruSayisi);
    for (var i = 0; i <= cevaplar.length-1; i++){

      data.add(cevaplar[i]);
    }


    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Ozel_Bitir(),
          settings: RouteSettings(
            arguments: data,
          ),
        ));
  }
  void cevapKontrol(deger) {

    if(sonSoruHatasi==1){
      sonuc = bilgiler[(sayi+1)*6-1];
    }

    else{
      sonuc = bilgiler[sayi*6-1];
    }

    if(deger == sonuc&&sayi>=soruSayisi){
      net = net+1;
      dogru++;

      cevaplar.add("Doğru");

      _timer.cancel();
      AnalizeGonder();
    }

    else if(deger != sonuc&&sayi>=soruSayisi){
      net = net - 0.3;
      yanlis++;

      cevaplar.add("Yanlış");

      _timer.cancel();
      AnalizeGonder();
    }

    else if(deger == sonuc && sonSoruHatasi==1){
      net = net +1;
      dogru++;

      cevaplar.add("Doğru");

      _timer.cancel();
      AnalizeGonder();
    }

    else if(deger != sonuc && sonSoruHatasi==1){
      net = net - 0.3;
      yanlis++;

      cevaplar.add("Yanlış");

      _timer.cancel();
      AnalizeGonder();
    }


    else if (deger == sonuc) {
      net = net+1;
      dogru++;

      cevaplar.add("Doğru");

    }

    else if(deger != sonuc){
      net = net - 0.3;
      yanlis++;

      cevaplar.add("Yanlış");

    }


  }

  @override
  Widget build(BuildContext context) {

    List? data = [];
    data = (ModalRoute.of(context)!.settings.arguments as List?);
    kullaniciAdi = data![0];
    email = data[1];
    sifre = data[2];
    sinavAdi1 = data[3];
    _sayac.start();
    if (zaman(sinavSuresi*60000 - _sayac.elapsedMilliseconds) == "00:01") {
      Timer(Duration(milliseconds: 1000), (){

        Future.delayed(Duration.zero, () async {
          _timer.cancel();
          AnalizeGonder();
        });
      });

    }

    return Scaffold(
        backgroundColor: Colors.green.shade200,

        appBar: AppBar(
          backgroundColor: Color.fromRGBO(42, 91, 204, 1.0),
          title: Text(sinavAdi1,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/x0.jpg"),
                  fit: BoxFit.cover
              )
          ),
          child: Center(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 12.0,bottom: 4.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Netiniz: "  + net.toStringAsFixed(1),
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  (sayi+1).toString() + '.Soru  ',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                              "Süre: " +
                                  zaman(sinavSuresi*60000 - _sayac.elapsedMilliseconds),
                              style: TextStyle(fontSize: 18.0)),
                        ),
                      ),

                      SizedBox(
                        width: 10,
                      ),

                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 7,
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 100, maxHeight: 225),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green.shade200,

                            /* gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.blue[500]!,
                                  Colors.yellow[100]!,
                                  Colors.red[500]!,
                                ]) */
                        ),
                        child: SingleChildScrollView(
                          child:
                          Text(
                            soru = bilgiler![sayi*6],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: AbsorbPointer(
                          absorbing: _isAbsorbing,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isAbsorbing = true;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  _isAbsorbing = false;
                                });
                              });
                              Timer(Duration(milliseconds: 500), (){
                                if(sayi+2 <= soruSayisi){
                                  sayi++;
                                  setState(() {

                                    cevapKontrol("A");

                                  });
                                }

                                else {
                                  sonSoruHatasi = 1;
                                  print(sayi);
                                  setState(() {
                                    cevapKontrol("A");
                                  });
                                }
                              });

                            },
                            child: SingleChildScrollView(
                              child: Text(
                                sik1 = "A) " +bilgiler![sayi*6+1],
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ),

                Padding(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AbsorbPointer(
                      absorbing: _isAbsorbing,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isAbsorbing = true;
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              _isAbsorbing = false;
                            });
                          });
                          Timer(Duration(milliseconds: 500), (){
                            if(sayi+2 <= soruSayisi){
                              sayi++;
                              setState(() {

                                cevapKontrol("B");

                              });
                            }

                            else {
                              sonSoruHatasi = 1;
                              print(sayi);
                              setState(() {
                                cevapKontrol("B");
                              });
                            }
                          });

                        },
                        child: SingleChildScrollView(
                          child: Text(
                            sik2 = "B) " +bilgiler![sayi*6+2],
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AbsorbPointer(
                      absorbing: _isAbsorbing,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isAbsorbing = true;
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              _isAbsorbing = false;
                            });
                          });
                          Timer(Duration(milliseconds: 500), (){
                            if(sayi+2 <= soruSayisi){
                              sayi++;
                              setState(() {

                                cevapKontrol("C");

                              });
                            }

                            else {
                              sonSoruHatasi = 1;
                              print(sayi);
                              setState(() {
                                cevapKontrol("C");
                              });
                            }
                          });

                        },
                        child: SingleChildScrollView(
                          child: Text(
                            sik3 = "C) " +bilgiler![sayi*6+3],
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AbsorbPointer(
                      absorbing: _isAbsorbing,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isAbsorbing = true;
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              _isAbsorbing = false;
                            });
                          });
                          Timer(Duration(milliseconds: 500), (){
                            if(sayi+2 <= soruSayisi){
                              sayi++;
                              setState(() {

                                cevapKontrol("D");

                              });
                            }

                            else {
                              sonSoruHatasi = 1;
                              print(sayi);
                              setState(() {
                                cevapKontrol("D");
                              });
                            }
                          });

                        },
                        child: SingleChildScrollView(
                          child: Text(
                            "D) " +bilgiler![sayi*6+4],
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),

                /*Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Anasayfa(),
                                settings: RouteSettings(
                                  arguments: data,
                                )));
                      },
                      child: Text('Anasayfaya Dön'),
                    ),
                  ),*/
              ],
            ),
          ),
        ));
  }
}


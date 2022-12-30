import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/dersler/fensorular.dart';
import 'package:lgs_jr_v2/dersler/genel.dart';
import 'package:lgs_jr_v2/dersler/matematiksorular.dart';
import 'package:lgs_jr_v2/dersler/ozel_sinav_girisi.dart';
import 'package:lgs_jr_v2/dersler/sosyalsorular.dart';
import 'package:lgs_jr_v2/dersler/turkcesorular.dart';
import 'package:lgs_jr_v2/dersler/sinav_olustur.dart';
import 'package:lgs_jr_v2/main.dart';
import 'package:lgs_jr_v2/ozel_sinav_sonuclar.dart';
import 'package:page_transition/page_transition.dart';
import 'hesapIslemleri/hesap_olustur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:lgs_jr_v2/globals.dart' as globals;

class Sonuc_Listesi extends StatefulWidget {
  @override
  _Sonuc_ListesiState createState() => _Sonuc_ListesiState();
}

class _Sonuc_ListesiState extends State<Sonuc_Listesi> {
  //final _formKontrol = GlobalKey<FormState>();
  String? kullaniciAdi, email, sifre;
  String sinavAdi1 = "";
  var cevaplar = [];
  String arananKullanici = "";
  String arananSifre = "";
  int kontrol = 0;
  int soruSayisi = 0;
  String sure = "00:00";
  int dogru = 0;
  int yanlis = 0;
  double net = 0.0;
  String cevap = "";
  String analiz = "";

  @override
  void initState() {
    sinavAdi1 = globals.sinavismi;

    getData();
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('Sinavlar')
        .doc(sinavAdi1)
        .collection('Sonuclar')
        .get()
        .then((QuerySnapshot snapshot) {
      final docs = snapshot.docs;
      setState(() {

      });
    });
    setState(() {

    });
  }

  Future getData() async {
    await FirebaseFirestore.instance.collection("Sinavlar")
        .doc(sinavAdi1)
        .collection("Sonuclar")
        .doc(arananKullanici)
        .get()
        .then((value) {
      if (value.exists) {
        FirebaseFirestore.instance.collection("Sinavlar")
            ..doc(sinavAdi1)
                .collection("Sonuclar")
                .doc(arananKullanici)
            .snapshots()
            .listen((snapshot) {
          final data = snapshot.data() as Map<String, dynamic>;
          net = data["Net"];
          sure= data["Süre"];
          dogru = data["Dogru Sayısı"];
          yanlis = data["Yanlış Sayısı"];
          soruSayisi = dogru + yanlis;
          analiz =
          "Kullanıcının Adı: $arananKullanici \n"
              "Neti: $net \n"
              "Çözülen Soru Sayısı: $soruSayisi \n"
              "Dogru Sayısı: $dogru \n"
              "Yanlış Sayısı: $yanlis \n";
          for(int z = 1; z <= soruSayisi; z++){

            cevap = data[z.toString()+"_Soru"];

            cevaplar.add(cevap);
          }

        });

        kontrol=1;
      }
      else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Kullanıcı Bulunamadı'),
            content: const Text("Bu kullanıcı adıyla sınavınıza giren kimse bulunamadı."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
        kontrol =0;
        return;
      }
    });

  }


  @override
  Widget build(BuildContext context) {

    List? data = [];
    data = (ModalRoute.of(context)!.settings.arguments as List?);
    var kullaniciAdi = data![0];
    var email = data[1];
    var sifre = data[2];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Sınav Sonucları",
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      //margin: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 4,
                          ),
                          //borderRadius: BorderRadius.circular(20),
                          color: Colors.blue.withOpacity(0.5)
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            alignment: Alignment.topLeft,
                            child: Text("Sınav Sonucunu Aradığınız Kullanıcının Adını Giriniz;",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white
                            ),
                            child: TextField(
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,

                              decoration: InputDecoration.collapsed(hintText: "Kullanici Adi;"),
                              onChanged: (String text ){


                                arananKullanici = text;
                              },
                              onSubmitted: (String text ){

                                arananKullanici = text;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red.shade400),
                              ),
                              onPressed: () {

                                getData();

                                Timer(Duration(milliseconds: 1000), (){
                                  setState(() {

                                  });
                                });
                              },
                              child: const Text("Sonucları Gör",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,

                                ),),

                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 400,
                      padding: const EdgeInsets.all(10),
                      //margin: const EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.redAccent,
                            width: 4,
                          ),
                          //borderRadius: BorderRadius.circular(20),
                          color: Colors.blue.withOpacity(0.5)
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 300,
                            padding: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade200.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        analiz!,
                                        textAlign: TextAlign.center,
                                        style:
                                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    for(int i = 0; i <= soruSayisi-1; i++)...[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 3,top: 0),
                                        child: Text((i+1).toString()+"_Soru : "+cevaplar![i],
                                            textAlign: TextAlign.center,
                                            style:
                                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold
                                            )
                                        ),
                                      ),
                                      if(i != soruSayisi-1)...{
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade500,
                                            borderRadius: BorderRadius.circular(50),
                                          ),height: 3,width: double.infinity,),
                                      },
                                    ],
                                  ]),
                            ),
                          )
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



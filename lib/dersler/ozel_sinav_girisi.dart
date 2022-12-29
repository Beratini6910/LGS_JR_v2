import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/dersler/fensorular.dart';
import 'package:lgs_jr_v2/dersler/genel.dart';
import 'package:lgs_jr_v2/dersler/matematiksorular.dart';
import 'package:lgs_jr_v2/dersler/sosyalsorular.dart';
import 'package:lgs_jr_v2/dersler/turkcesorular.dart';
import 'package:lgs_jr_v2/dersler/sinav_olustur.dart';
import 'package:lgs_jr_v2/dersler/ozel_sinav.dart';
import 'package:lgs_jr_v2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:lgs_jr_v2/globals.dart' as globals;
import 'package:page_transition/page_transition.dart';

class Ozel_Sinav_Girisi extends StatefulWidget {
  @override
  _Ozel_Sinav_GirisiState createState() => _Ozel_Sinav_GirisiState();
}

class _Ozel_Sinav_GirisiState extends State<Ozel_Sinav_Girisi> {
  final TextEditingController _temiz1 = new TextEditingController();
  //final _formKontrol = GlobalKey<FormState>();
  String? kullaniciAdi, email, sifre;
  String sinavAdi1 = "";
  String sinavSifresi1 = "0";
  String sinavSifresi0 = "";
  int kontrol = 0;
  int sifreKontrol = 0;
  String sinavAdi = "";

  Future getData() async {
    await FirebaseFirestore.instance.collection("Sinavlar")
        .doc(sinavAdi)
        .get()
        .then((value) {
      if (value.exists) {
        FirebaseFirestore.instance.collection("Sinavlar")
            .doc(sinavAdi)
            .snapshots()
            .listen((snapshot) {
          final data = snapshot.data() as Map<String, dynamic>;
          sinavAdi = data["0_Sinavin_Adi"];
          sinavSifresi0 = data["0_Sinavin_Sifresi"];
        });

        kontrol=1;
      }
      else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Sınav Adı Bulunamadı.'),
            content: const Text("Sınav adını yanlış girdiniz. Lütfen tekrar deneyin."),
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
    var sinavAdi1 = sinavAdi;

    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Özel Sınav Girişi",
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.purple
                        ),
                        child: const Text("Lütfen Girmek İstediğiniz Sınavın Adını ve Şifresini Giriniz:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(0),
                      //margin: const EdgeInsets.only(left: 5, right: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4.0,
                          color: Colors.blueAccent
                        ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.withOpacity(0.5)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  //alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blue
                                  ),
                                  child: Column(
                                    children: [

                                      Container(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        alignment: Alignment.topLeft,
                                        child: Text("Sınavın Adını Giriniz:",
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

                                          decoration: InputDecoration.collapsed(hintText: "Sınav Adını Giriniz;"),
                                          onChanged: (String text ){


                                            sinavAdi = text;
                                          },
                                          onSubmitted: (String text ){

                                            sinavAdi = text;
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(bottom: 5,top: 10),
                                        alignment: Alignment.topLeft,
                                        child: Text("Sınavın Şifresini Giriniz:",
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
                                          controller: _temiz1,
                                          decoration: InputDecoration.collapsed(hintText: "Sınav Şifresini Giriniz;"),
                                          onChanged: (String text ){
                                            sinavSifresi1 = text;

                                          },
                                          onSubmitted: (String text ){
                                            sinavSifresi1 = text;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                              ],
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

                                    if(sinavSifresi1 == sinavSifresi0&&kontrol==1){
                                      FirebaseFirestore.instance.collection("Kullanicilar").doc(email).update({
                                        "Son_Ozel_Sinav" : sinavAdi1
                                        //'Süre' : zaman,
                                      }).whenComplete(() => print("Firestore'a eklenildi."));

                                      sinavAdi1 = sinavAdi;
                                      globals.sinavismi= sinavAdi1 ;

                                      int number = 0;
                                      var data = [];
                                      data.add(kullaniciAdi);
                                      data.add(email);
                                      data.add(sifre);
                                      data.add(sinavAdi);
                                      Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft,
                                          child: Ozel_Sinav(),
                                          duration: const Duration(milliseconds: 400),
                                          reverseDuration: const Duration(milliseconds: 600),
                                          settings: RouteSettings
                                            (
                                            arguments: data,
                                          )));

                                    }
                                    else if(sinavSifresi1 != sinavSifresi0&&kontrol==1){
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(
                                          title: const Text('Şifre Yanlış.'),
                                          content: const Text("Sınav şifresini yanlış girdiniz. Lütfen tekrar deneyin."),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, 'OK'),
                                              child: const Text('Tamam'),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }

                                  });





                                /*
                                Timer(Duration(milliseconds: 1000), (){




                                  if(kontrol ==1){
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Sınav Adı Bulunamadı.'),
                                        content: const Text("Sınav adını yanlış girdiniz. Lütfen tekrar deneyin."),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            child: const Text('Tamam'),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }

                                  if(sinavSifresi0 != sinavSifresi1){

                                  }

                                  if(sinavSifresi0 ==sinavSifresi1){
                                    sifreKontrol =2;
                                  }

                                  if(sifreKontrol==2){




                                  }


                                });


*/
                              },
                              child: const Text("Sınava Gir",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,

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
                    /*ElevatedButton(onPressed: (){
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



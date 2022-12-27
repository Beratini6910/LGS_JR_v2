import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/hata.dart';
import 'package:lgs_jr_v2/hesapIslemleri/hesap_olustur.dart';
import 'package:lgs_jr_v2/hesapIslemleri/ogretmen_hesap_olustur.dart';
import 'package:lgs_jr_v2/main.dart';
import 'package:lgs_jr_v2/ogretmen_anasayfa.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lgs_jr_v2/globals.dart' as globals;

class OgretmenMenusu extends StatefulWidget {
  @override
  _OgretmenMenusuState createState() => _OgretmenMenusuState();
}

class _OgretmenMenusuState extends State<OgretmenMenusu> {
  final _formKontrolog = GlobalKey<FormState>();
  String? email1, sifre1;
  int hesap = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/o1.png"),
              fit: BoxFit.cover
          )
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.purple,
            title: const Text(
              "Öğretmen Girişi",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Center(
            child: Form(
              key: _formKontrolog,
              child: Center(
                child:
                //SizedBox( height: 50),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.purple,
                      width: 4,
                    ),
                      color: Colors.purple.shade300.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Mail Hesabınızı giriniz.",
                              prefixIcon: Icon(Icons.mail),
                            ),
                            autocorrect: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (GirilenDeger) {
                              if (GirilenDeger!.isEmpty) {
                                return "Mail Hesabı boş bırakılamaz.";
                              } else if (!GirilenDeger.contains("@hotmail")&&!GirilenDeger.contains("@gmail")&&!GirilenDeger.contains("edu")&&!GirilenDeger.contains("meb")&&!GirilenDeger.contains("gov.")&&!GirilenDeger.contains("meb.")) {
                                return "Lütfen desteklenen bir Mail formatıf giriniz.";
                              }
                              return null;
                            },
                            onSaved: (GirilenDeger) => email1 = GirilenDeger),
                        TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Şifrenizi giriniz.",
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (GirilenDeger) {
                              if (GirilenDeger!.isEmpty) {
                                return "Şifre boş bırakılamaz.";
                              } else if (GirilenDeger.length < 7) {
                                return "Şifre en az 8 değerden oluşmalıdır.";
                              }
                              return null;
                            },
                            onSaved: (GirilenDeger) => sifre1 = GirilenDeger),
                        const SizedBox(height: 40),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                    width: 3.0,
                                    color: Colors.purple.shade900
                                ),
                                primary: Colors.blue.shade100,
                                padding: const EdgeInsets.all(20)),
                            onPressed:
                              _girisYap,
                            child: const Text(
                              "Öğretmen Olarak Giriş Yap",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            )),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                    width: 2.0,
                                    color: Colors.orange
                                ),
                                primary: Colors.purpleAccent.shade400,
                                padding: const EdgeInsets.all(10)),
                            onPressed: (){
                              Navigator.push(context,PageTransition(type: PageTransitionType.bottomToTop,
                                  child: OgretmenHesapOlustur(),
                                  duration: const Duration(milliseconds: 400),
                                  reverseDuration: const Duration(milliseconds: 600)
                                    ));
                            } ,
                            child: const Text(
                              textAlign: TextAlign.center,
                              "Hesabınız Yoksa Buradan Oluşturabilirsiniz",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            )),
                      ],
                    ),
                  ),
                ),

              ),
            ),
          )),
    );
  }

  Future<void>_girisYap() async {

    var _formState = _formKontrolog.currentState;
    if (_formState!.validate()) {
      _formState!.save();
      print("email" + email1!);
      print("sifre" + sifre1!);
      /*var data = [];
      data = (ModalRoute.of(context).settings.arguments);
      var email = data[1];
      var sifre = data[2];
       if (email == email1 && sifre == sifre1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Anasayfa(),
                settings: RouteSettings(
                  arguments: data,
                )));*/
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Mailiniz veya Şifre Yanlış.'),
          content: const Text("Mailinizi veya şifrenizi yanlış girdiniz. Lütfen tekrar deneyin."),
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

    print(email1);
    print(sifre1);

    var kullaniciAdi = "";

    await FirebaseFirestore.instance
        .collection("Kullanicilar")
        .doc(email1)
        .get()
        .then((adi){
      setState((){
        kullaniciAdi = adi.data()!['KullaniciAdi'];
      });
    });

    FirebaseFirestore.instance.collection("Kullanicilar")
        .doc(email1)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      hesap = data["Hesap"];

    });
    Timer(Duration(milliseconds: 1000), (){



      if (hesap == 1) {

        var data = [];
        data.add(kullaniciAdi);
        data.add(email1);
        data.add(sifre1);

        FirebaseAuth.instance.signInWithEmailAndPassword(email: email1!, password: sifre1!)
            .then((kullanici){
          Navigator.push(context,PageTransition(type: PageTransitionType.bottomToTop,
              child: Ogretmen_Anasayfa(),
              duration: const Duration(milliseconds: 400),
              reverseDuration: const Duration(milliseconds: 600),
              settings: RouteSettings
                (
                arguments: data,
              )));
        });

      }
      else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Öğretmen Hesabı Değil'),
            content: const Text("Bu hesap öğretmen hesabı değildir."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
        hesap = 0;
        return;
      };
      globals.kullaniciTuru = 1;
    });




    print(kullaniciAdi);

  }

/* show() {
    /*Timer timer = Timer(Duration(milliseconds: 3000), (){
      Navigator.of(context, rootNavigator: true).pop();
    });*/
    return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
                title: new Text("Hatalı Giriş Yaptınız"),
                content: new Text(
                    "Hatalı Hotmail veya şifre girdiniz. Lütfen tekrar deneyiniz."),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: new Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  )
                ]));
  }*/
}



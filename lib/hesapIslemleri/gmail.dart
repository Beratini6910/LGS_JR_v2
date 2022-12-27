import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/hata.dart';
import 'dart:async';
import 'package:lgs_jr_v2/hesapIslemleri/hesap_olustur.dart';
import 'package:page_transition/page_transition.dart';

class Gmail extends StatefulWidget {
  @override
  _GmailState createState() => _GmailState();

}

class _GmailState extends State<Gmail> {
  final _formKontrolg = GlobalKey<FormState>();
  String? email1, sifre1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            "Gmail ile Giriş",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.purple.shade200,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/a2.jpg"),
                  fit: BoxFit.cover
              )
          ),
          child: Form(
            key: _formKontrolg,
            child: Center(
              child:
                //SizedBox( height: 50),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: Colors.red.shade100.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Gmail Hesabınızı giriniz.",
                              prefixIcon: Icon(Icons.mail),
                            ),
                            autocorrect: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (GirilenDeger) {
                              if (GirilenDeger!.isEmpty) {
                                return "Gmail Hesabı boş bırakılamaz.";
                              } else if (!GirilenDeger.contains("@gmail")) {
                                return "Lütfen sadece Gmail formatı giriniz.";
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
                                primary: Colors.blue.shade100,
                                padding: const EdgeInsets.all(20)),
                            onPressed: _girisYap,
                            child: const Text(
                              "Gmail ile Giriş yap",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.red),
                            )),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context,PageTransition(type: PageTransitionType.topToBottom,
                                child: HesapOlustur(),
                                duration: Duration(milliseconds: 600),
                                reverseDuration: Duration(milliseconds: 600),
                              ));
                                        },
                            child: const Text(
                              "Hesabınız yok mu? Hemen üye olun!",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue),
                            ))
                      ],
                    ),
                  ),
                ),

            ),
          ),
        ));
  }

  Future<void> _girisYap() async {


    var _formState = _formKontrolg.currentState;
    if (_formState!.validate()) {
      _formState.save();
      } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Gmailiniz veya Şifre Yanlış.'),
          content: const Text("Gmailinizi veya şifrenizi yanlış girdiniz. Lütfen tekrar deneyin."),
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

    var data = [];
    data.add(kullaniciAdi);
    data.add(email1);
    data.add(sifre1);

    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email1!, password: sifre1!)
        .then((kullanici){
      Navigator.push(context,PageTransition(type: PageTransitionType.bottomToTop,
          child: Anasayfa(),
          duration: const Duration(milliseconds: 400),
          reverseDuration: const Duration(milliseconds: 600),
          settings: RouteSettings
            (
            arguments: data,
          )));
    });

    print(kullaniciAdi);


  }

  Future show() {
    /*Timer timer = Timer(Duration(milliseconds: 3000), (){
      Navigator.of(context, rootNavigator: true).pop();
    });*/
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text("Hatalı Giriş Yaptınız"),
                content: const Text(
                    "Hatalı Gmail veya şifre girdiniz. Lütfen tekrar deneyiniz."),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  )
                ]));
  }
}

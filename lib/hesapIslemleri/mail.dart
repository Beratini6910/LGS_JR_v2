import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/hata.dart';
import 'package:lgs_jr_v2/hesapIslemleri/hesap_olustur.dart';
import 'package:lgs_jr_v2/main.dart';
import 'package:page_transition/page_transition.dart';

class Mail extends StatefulWidget {
  @override
  _MailState createState() => _MailState();
}

class _MailState extends State<Mail> {
  final _formKontrolm = GlobalKey<FormState>();
  String? email1, sifre1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/a1.jpg"),
              fit: BoxFit.cover
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              "Mail ile Giriş",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Center(
            child: Form(
              key: _formKontrolm,
              child: Center(
                child:
                //SizedBox( height: 50),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.redAccent,
                        width: 3,
                      ),
                      color: Colors.red.shade100.withOpacity(0.8),
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
                              } else if (!GirilenDeger.contains("@")) {
                                return "Lütfen sadece Mail formatı giriniz.";
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
                                    color: Colors.blueAccent
                                ),
                                backgroundColor: Colors.blue.shade100,
                                padding: EdgeInsets.all(20)
                              //backgroundColor: MaterialStateProperty.all(Colors.blue.shade200),
                            ),
                            onPressed: _girisYap,
                            child: const Text(
                              "Giriş Yap",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue),
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
                            child: Container(
                              padding: EdgeInsets.only(left: 20,right: 20,top: 8,bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red.shade100.withOpacity(0.7),

                                /* gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.blue[500]!,
                                  Colors.yellow[100]!,
                                  Colors.red[500]!,
                                ]) */
                              ),
                              child: const Text(
                                "Hesabınız yok mu? Hemen üye olun!",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue),
                              ),
                            ))
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


    var _formState = _formKontrolm.currentState;
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



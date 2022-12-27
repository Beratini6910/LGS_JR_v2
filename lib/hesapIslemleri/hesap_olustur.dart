import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/hesapIslemleri/gmail.dart';
import 'package:lgs_jr_v2/hesapIslemleri/mail.dart';
import 'package:page_transition/page_transition.dart';



class HesapOlustur extends StatefulWidget {

  @override
  _HesapOlusturState createState() => _HesapOlusturState();

}


class _HesapOlusturState extends State<HesapOlustur> {
  final _formKontrol = GlobalKey<FormState>();
  String? kullaniciAdi, email, sifre;
  static String? x1 = "denemess";

  dynamic fieldValue = "initial";

  @override
  void initState() {
    FirebaseFirestore.instance
        .doc("Kullanicilar/11@gmail.com")
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      fieldValue = data["Dersiniz"];
      print(fieldValue);
      setState(() {
        x1 = fieldValue;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Hesap Oluştur",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/b4.png"),
                  fit: BoxFit.cover
              )
          ),
          child: Form(
            key: _formKontrol,
            child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Kullanmak istediğiniz Kullanıcı adını giriniz.",
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (GirilenDeger) {
                              if (GirilenDeger!.isEmpty) {
                                return "Kullanıcı adı boş bırakılamaz.";
                              } else if (GirilenDeger.length < 3) {
                                return "Kullanıcı adı en az 4 değerden oluşmalıdır.";
                              }
                              return null;
                            },
                            onSaved: (GirilenDeger) => kullaniciAdi = GirilenDeger,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Hotmail veya Gmail Hesabınızı giriniz.",
                              prefixIcon: Icon(Icons.mail),
                            ),
                            autocorrect: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (GirilenDeger) {
                              if (GirilenDeger!.isEmpty) {
                                return "Email veya Gmail Hesabı boş bırakılamaz.";
                              } else if (!GirilenDeger.contains("@")) {
                                // else if (!GirilenDeger.contains("@hotmail")&&!GirilenDeger.contains("@gmail")) {
                                return "Girdiğiniz değer Hotmail veya Gmail formatı olmalıdır.";
                              }
                              return null;
                            },
                            onSaved: (GirilenDeger) => email = GirilenDeger,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
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
                            onSaved: (GirilenDeger) => sifre = GirilenDeger,
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      width: 3.0,
                                      color: Colors.blue.shade200
                                  ),
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.all(20)
                                //backgroundColor: MaterialStateProperty.all(Colors.blue.shade200),
                              ),

                              onPressed: _kullaniciOlustur,
                              child: Text(
                                "Hesabımı Oluştur",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                          SizedBox(height: 10),
                          /*
                          ElevatedButton(
                            onPressed: _kullaniciOlustur2,
                            child: Text(
                              "Gmail Hesabımı Oluştur.",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red),
                            ),
                          ),
                          */
                        ],
                      ),
                    ),
                  ),
                ),

            ),
          ),
        );
  }

  /*_kullaniciOlustur() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: sifre);
  }*/
   static void veriCek() async{
    final ref =  await FirebaseFirestore.instance
        .doc('Kullanicilar/11@gmail.com').get();
    var xxxx = ref.get('KullaniciEposta');
    print(xxxx);
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    x1 = xxxx;
  }


void _kullaniciOlustur() {
    var _formState = _formKontrol.currentState;
    if (_formState!.validate()) {
      _formState!.save();
      /*var data = [];
      data.add(kullaniciAdi);
      data.add(email);
      data.add(sifre);
      print(email);
      print(sifre);*/
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: sifre!).then((kullanici){
        FirebaseFirestore.instance.collection("Kullanicilar").doc(email).set({
          'Hesap' : 0,
          'KullaniciEposta' : email,
          'KullaniciSifre' : sifre,
          'KullaniciAdi' : kullaniciAdi,
          'Dersiniz' : "",
          'Netiniz' : "",
          'Süreniz' : "",
        }).whenComplete(() => print("Firestore'a eklenildi."));
      });
      Navigator.push(context,PageTransition(type: PageTransitionType.leftToRight,
          child: Mail(),
          duration: Duration(milliseconds: 600),
          reverseDuration: Duration(milliseconds: 600),
          ));

    }
  }

 Future<void> _kullaniciOlustur2() async{
    @override
    var _formState = _formKontrol.currentState;

    print(email);
    print(sifre);

    if (_formState!.validate()) {
      _formState.save();
      var data = [];
      data.add(kullaniciAdi);
      data.add(email);
      data.add(sifre);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: sifre!).then((kullanici){
            FirebaseFirestore.instance.collection("Kullanicilar").doc(email).set({
              'Hesap' : 0,
              'KullaniciEposta' : email,
              'KullaniciSifre' : sifre,
              'KullaniciAdi' : kullaniciAdi,
              'Dersiniz' : "",
              'Netiniz' : "",
              'Süreniz' : "",
            }).whenComplete(() => print("Firestore'a eklenildi."));
      });
      Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeft,
          child: Gmail(),
          duration: Duration(milliseconds: 600),
          reverseDuration: Duration(milliseconds: 600),

            ));
    }
  }
}

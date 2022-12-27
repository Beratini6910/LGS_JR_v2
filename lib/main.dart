import 'dart:convert';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lgs_jr_v2/hesapIslemleri/gmail.dart';
import 'package:lgs_jr_v2/hesapIslemleri/hesap_olustur.dart';
import 'package:lgs_jr_v2/hesapIslemleri/mail.dart';
import 'package:lgs_jr_v2/hesapIslemleri/ogretmen_menusu.dart';
import 'package:page_transition/page_transition.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  FirebaseFirestore.instance.doc("Kullanicilar").snapshots();

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Giriş Sayfası',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.purple.shade600,
        accentColor: Colors.red,
      ),
      home: GirisSayfasi(),
    );
  }
}
class HesapOlusturScreen extends StatelessWidget {
  const HesapOlusturScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(children: <Widget>[
          Image.asset("assets/images/new_logo.png",height: 300, width: 300,),
          Container(
            alignment: Alignment.center,
            width: 250,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(5, 5),
                  blurRadius: 40,
                  color: Colors.black.withOpacity(0.9),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("Yükleniyor...",style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Color.fromRGBO(107, 2, 225, 1), fontStyle: FontStyle.italic),),
          ),

        ]),
      ),
      backgroundColor: Colors.purple[400]!,
      nextScreen: HesapOlustur(),
      pageTransitionType: PageTransitionType.bottomToTop,
      duration: 100,
      splashIconSize: 450,
    );
  }
  }
class MailScreen extends StatelessWidget {
  const MailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(children: <Widget>[
          Image.asset("assets/images/new_logo.png",height: 300, width: 300,),
          Container(
            alignment: Alignment.center,
            width: 250,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(5, 5),
                  blurRadius: 40,
                  color: Colors.black.withOpacity(0.9),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("Yükleniyor...",style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Color.fromRGBO(5, 25, 232, 1), fontStyle: FontStyle.italic),),
          ),

        ]),
      ),
      backgroundColor: Colors.blue,
      nextScreen: Mail(),
      pageTransitionType: PageTransitionType.rightToLeft,
      duration: 100,
      splashIconSize: 450,
    );
  }
}
class GmailScreen extends StatelessWidget {
  const GmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(children: <Widget>[
          Image.asset("assets/images/new_logo.png",height: 300, width: 300,),
          Container(
              alignment: Alignment.center,
            width: 250,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(5, 5),
                  blurRadius: 40,
                  color: Colors.black.withOpacity(0.9),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
              child: const Text("Yükleniyor...",style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Color.fromRGBO(160, 1, 13, 1), fontStyle: FontStyle.italic),),
          ),

        ]),
      ),
      backgroundColor: Colors.red,
      nextScreen: Gmail(),
      pageTransitionType: PageTransitionType.rightToLeft,
      duration: 100,
      splashIconSize: 450,
    );
  }
}

class OgretmenMenusuScreen extends StatelessWidget {
  const OgretmenMenusuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(children: <Widget>[
          Image.asset("assets/images/new_logo.png",height: 300, width: 300,),
          Container(
            alignment: Alignment.center,
            width: 250,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: const Offset(5, 5),
                  blurRadius: 40,
                  color: Colors.black.withOpacity(0.9),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("Yükleniyor...",style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Color.fromRGBO(5, 25, 232, 1), fontStyle: FontStyle.italic),),
          ),

        ]),
      ),
      backgroundColor: Colors.purpleAccent.shade700,
      nextScreen: OgretmenMenusu(),
      pageTransitionType: PageTransitionType.rightToLeft,
      duration: 100,
      splashIconSize: 450,
    );
  }
}

/*Container(
alignment: Alignment.center,
child: Text(
"Mail ile Giriş",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Colors.white,
),
),
height: 52,
decoration: BoxDecoration(
color: Colors.blue.shade600.withOpacity(1),
borderRadius: BorderRadius.circular(10),
),
),*/



/*DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final DocumentSnapshot docUser =
    firestore.collection('users').doc('sALkf983l3j5RGjsk82lfds').get() as DocumentSnapshot<Object?>; */


/*Future<void> veriCek() async {
  final ref = await FirebaseFirestore.instance
      .doc('Kullanicilar/11@gmail.com').get();
  String xxxx = ref.get('KullaniciEposta');
  await String; xxxx = "aaaaaaaaaaaa";
  print(xxxx);
  xxxx;
}*/

String xyz = "deneme1";


class GirisSayfasi extends StatefulWidget {

  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();

}


class _GirisSayfasiState extends State<GirisSayfasi> {
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
        xyz = fieldValue;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {




    //FirebaseFirestore.instance.doc("Kullanicilar/11@gmail.com").snapshots();
    /*StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.doc("Kullanicilar/11@gmail.com").snapshots(), // Stream
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final currentData = snapshot.data!.data() as Map<String, dynamic>;
          final fieldValue = currentData["KullaniciAdi"];
          return fieldValue;
        }
        return Text("something else");
      },
    );
    var fieldValue;
    FirebaseFirestore.instance
        .doc("Kullanicilar/11@gmail.com")
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      fieldValue = data["Dersiniz"];
      print(fieldValue);
      xyz = fieldValue;
    });

    setState(()  {
      xyz = fieldValue;
    });
*/
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body:
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/x1.png"),
              fit: BoxFit.cover
            )
          ),

          child: Center(
            child: Column(children: <Widget>[

              const SizedBox(height: 45),
              //SizedBox(height: 30),
              Image.asset("assets/images/new_logo.png",
                height: 270,
                width: 270,),
              /*Text(
                "LGS JR.",
                style: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    shadows: [Shadow(color: Colors.black, offset: Offset(3, 3))]),
              ),*/
              Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 30,
                child: Container(
                  decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage("assets/images/b5.jpg"),
                            fit: BoxFit.cover
                        ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.purple,
                            Colors.purple,
                            Colors.purple,
                          ])),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width - 70,
                  height: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 10,bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HesapOlusturScreen()));
                          },

                          child: Container(
                            alignment: Alignment.center,
                            width: 280,
                            height: 52,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.purple.shade900,
                                width: 4,
                              ),
                              color: Colors.indigo.withOpacity(1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Hesap Oluştur",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[100],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15,left: 20,right: 20,top: 10),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.leftToRight,
                                            child: const MailScreen()));
                                  },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueAccent.shade100,
                                      width: 4,
                                    ),
                                    color: Colors.blue.shade600.withOpacity(1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "Kullanıcı Girişi",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                /* Expanded(

                              child: GestureDetector(


                                onTap: () {
                                  Navigator.push(
                                    context,
                                      PageTransition(
                                        type: PageTransitionType.leftToRight,
                                          child: const GmailScreen()));
                            },

                                child: Container(
                                  alignment: Alignment.center,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.red[600]!.withOpacity(1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "Gmail ile Giriş",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: const OgretmenMenusuScreen()));
                  },

                  child: Container(
                    width: MediaQuery.of(context).size.width - 140,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 6),
                      color: Colors.purple!.withOpacity(1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Öğretmen Menüsü",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 30),
              const FlutterLogo(
                size: 80.0,
              ),

            ]),
          ),
        ));

  }


}



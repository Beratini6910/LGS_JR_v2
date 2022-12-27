import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:lgs_jr_v2/analizler/genelgrafik.dart';
//import 'package:lgs_jr_v2/analizler/grafik.dart';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/main.dart';
import 'package:lgs_jr_v2/globals.dart' as globals;
import 'package:lgs_jr_v2/ogretmen_anasayfa.dart';

class GenelBitir extends StatefulWidget {
  @override
  _GenelBitirState createState() => _GenelBitirState();
}

class _GenelBitirState extends State<GenelBitir> {
  String? kullaniciAdi, zaman, ders, analiz,email;
  double? trOrt, net;
  //double net;

  @override
  Widget build(BuildContext context) {
    List? data = [];
    data = ModalRoute.of(context)!.settings.arguments as List?;
    kullaniciAdi = data![0];
    email = data[1];
    ders = data[2];
    net = data[3];
    zaman = data[4];

    FirebaseFirestore.instance.collection("Kullanicilar").doc(email).update({
      'Dersiniz' : ders,
      'Netiniz' : net,
      'Süreniz' : zaman,
      'Dersiniz' : ders,
      'Netiniz' : net,
      'Süreniz' : zaman,
    }).whenComplete(() => print("Firestore'a eklenildi."));

    if(ders=="Genel Sınav"){
      trOrt = 17.17;
    }

    if (ders=="Genel Sınav"&&net! > trOrt!) {
      analiz = "Tebrikler! Türkiye " +
          ders! +
          " net ortalaması olan 40 soruda " +
          trOrt.toString() +
          " netin üzerindesiniz. Başarılarınızın devamını dileriz!";
    } else if (ders=="Genel Sınav"&&net == trOrt) {
      analiz = "Netiniz Türkiye " +
          ders! +
          " net ortalaması olan 40 soruda " +
          trOrt.toString() +
          " nete eşit. Eğer sıkı çalışırsanız eminiz ki ortalamayı geçeceksiniz.";
    } else if(ders=="Genel Sınav"&&net! < trOrt!){
      analiz = "Ne yazık ki netiniz Türkiye " +
          ders! +
          " net ortalaması olan 40 soruda " +
          trOrt.toString() +
          " netin altında. Daha sıkı çalışmanız gerekli gibi görünüyor.";
    }
    return Scaffold(
        backgroundColor: Colors.grey,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/b4.png"),
                  fit: BoxFit.cover
              )
          ),
          child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue.shade100,
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.only(right: 20.0, left: 20, top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sayın "+kullaniciAdi! + ",  Sınav Analiziniz: ",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.red),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Sınavda Geçirdiğiniz Süre: " + zaman!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Toplam Netiniz: " + net.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Testini Çözdüğünüz Ders: " + ders!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 25),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                analiz!,
                                style:
                                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                          //Text(trOrt.toString()),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if(globals.kullaniciTuru == 1){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Ogretmen_Anasayfa(),
                                  settings: RouteSettings(arguments: data)));
                        }
                        else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Anasayfa(),
                                  settings: RouteSettings(arguments: data)));
                        }

                      },
                      child: Text("Anasayfaya Geri Dön ve Tekrar Dene"),
                    ),
                    SizedBox(height: 20),
                    /*
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Anasayfa(),
                                settings: RouteSettings(arguments: data)));
                      },
                      child: Text("Grafik Analizine git"),
                    ),

                     */
                  ])),
        ));
  }
}

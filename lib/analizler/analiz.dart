import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:lgs_jr_v2/analizler/genelgrafik.dart';
//import 'package:lgs_jr_v2/analizler/grafik.dart';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/main.dart';
import 'package:lgs_jr_v2/globals.dart' as globals;
import 'package:lgs_jr_v2/ogretmen_anasayfa.dart';

class Bitir extends StatefulWidget {
  @override
  _BitirState createState() => _BitirState();
}

class _BitirState extends State<Bitir> {
  String? kullaniciAdi, ders, analiz,email;
  String zaman = "00:00";
  double? trOrt, net;
  int? cozulenSoruSayisi,dogru,yanlis,soruSayisi;
  int ozel = 0;
  int sayi = 0;
  //double net;

  @override
  Widget build(BuildContext context) {



    List? data = [];
    data = ModalRoute.of(context)!.settings.arguments as List?;
    kullaniciAdi = data![0];
    email = data[1];
    ders = data[2];
    net = data[3];


    //cozulenSoruSayisi= data[5];

    FirebaseFirestore.instance.collection("Kullanicilar").doc(email).update({
      'Dersiniz' : ders,
      'Netiniz' : net,
      'Süreniz' : zaman,
      'Dersiniz' : ders,
      'Netiniz' : net,
      'Süreniz' : zaman,
    }).whenComplete(() => print("Firestore'a eklenildi."));

    if (ders == "Türkçe") {
      trOrt = 5;
    }

    else if (ders == "Matematik") {
      trOrt = 2.45;
    }

    else if (ders == "Fen Bilimleri") {
      trOrt = 10.20;
    }

    else if (ders == "Sosyal Bilimler") {
      trOrt = 5.05;
    }
    else if(ders=="Genel Sınav"){
      trOrt = 17.17;
    }
    else{
      trOrt = 101;
    }
    ;
    if(ozel ==1){
      analiz = "Girdiğiniz Özel Sınav :$ders \n "
          "Sınavın İçerdiği Soru Sayısı: $soruSayisi \n"
          "Çözdüğünüz Soru Sayısı: $sayi \n"
          "Dogru Sayınız: $dogru \n"
      "Yanlış Sayınız: $yanlis \n";

    }
    else if (ders!="Fen Bilimleri" && net! > trOrt!) {
      analiz = "Tebrikler! Türkiye " +
          ders! +
          " net ortalaması olan 10 soruda " +
          trOrt.toString() +
          " netin üzerindesiniz. Başarılarınızın devamını dileriz!";
    } else if (ders!="Fen Bilimleri" &&net == trOrt) {
      analiz = "Netiniz Türkiye " +
          ders! +
          " net ortalaması olan 10 soruda " +
          trOrt.toString() +
          " nete eşit. Eğer sıkı çalışırsanız eminiz ki ortalamayı geçeceksiniz.";
    } else if(ders!="Fen Bilimleri" &&net! < trOrt!){
      analiz = "Ne yazık ki netiniz Türkiye " +
          ders! +
          " net ortalaması olan 10 soruda " +
          trOrt.toString() +
          " netin altında. Daha sıkı çalışmanız gerekli gibi görünüyor.";
    }
    else if(ders=="Fen Bilimleri" &&net! < trOrt!){
      analiz = "Ne yazık ki netiniz Türkiye " +
          ders! +
          " net ortalaması olan 20 soruda " +
          trOrt.toString() +
          " netin altında. Daha sıkı çalışmanız gerekli gibi görünüyor.";
    }
    else if (ders=="Fen Bilimleri" &&net == trOrt!) {
      analiz = "Netiniz Türkiye " +
          ders! +
          " net ortalaması olan 20 soruda " +
          trOrt.toString() +
          " nete eşit. Eğer sıkı çalışırsanız eminiz ki ortalamayı geçeceksiniz.";
    }
    else if(ders=="Fen Bilimleri" && net! > trOrt!) {
      analiz = "Tebrikler! Türkiye " +
          ders! +
          " net ortalaması olan 20 soruda " +
          trOrt.toString() +
          " netin üzerindesiniz. Başarılarınızın devamını dileriz!";
    }

    if (ders! =="Genel Sınav"&&net! > trOrt!) {
      analiz = "Tebrikler! Türkiye " +
          ders! +
          " net ortalaması olan 40 soruda " +
          trOrt.toString() +
          " netin üzerindesiniz. Başarılarınızın devamını dileriz!";
    } else if (ders! =="Genel Sınav"&&net == trOrt) {
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
        image: AssetImage("assets/images/c1.jpg"),
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
                color: Colors.blue.shade100.withOpacity(0.4),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.only(right: 20.0, left: 20, top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sayın "+kullaniciAdi! + ",  Sınav Analiziniz: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Sınavın Adı: " + ders!,
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
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

                  SizedBox(height: 25),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade200.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(

                        analiz!,
                        textAlign: TextAlign.center,
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

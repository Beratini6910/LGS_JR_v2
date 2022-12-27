import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:lgs_jr_v2/analizler/genelgrafik.dart';
//import 'package:lgs_jr_v2/analizler/grafik.dart';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/main.dart';
import 'package:lgs_jr_v2/globals.dart' as globals;
import 'package:lgs_jr_v2/ogretmen_anasayfa.dart';

class Ozel_Bitir extends StatefulWidget {
  @override
  _Ozel_BitirState createState() => _Ozel_BitirState();
}

class _Ozel_BitirState extends State<Ozel_Bitir> {
  String? kullaniciAdi, ders, analiz,email,analiz1;
  String zaman = "00:00";
  String sinavAdi1 = "";
  var konular = [];
  int sinavSoruSayisi = 0;
  double? trOrt, net;
  int? cozulenSoruSayisi,dogru,yanlis,soruSayisi;
  int ozel = 0;
  int sayi = 0;
  int sayi1 = 0;
  int cevaplar = 0;
  //double net;

  @override
  void initState() {



    sinavAdi1 = globals.sinavismi;

    FirebaseFirestore.instance.collection("Sinavlar")
        .doc(sinavAdi1)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      sinavSoruSayisi = data["0_Soru_Sayisi"];
      for(var i = 1; i <= sinavSoruSayisi; i++){

        konular.add(data[i.toString()+"_Konu"]);
        sayi1++;
      }

      setState(() {

      });
    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    List? data = [];
    data = ModalRoute.of(context)!.settings.arguments as List?;
    kullaniciAdi = data![0];
    email = data[1];
    ders = data[2];
    net = data[3];
    zaman = data![4];
    sayi = data![5];
    dogru = data![6];
    yanlis = data![7];
    ozel = data![8];
    soruSayisi = data![9];

    sayi = (dogru! + yanlis!)!;

    /*
    for(int i = 0; i <= sayi-1; i++){
      int $i = data![i+10];
    }

     */

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
    };
    if(ozel ==1){
      analiz = "Girdiğiniz Özel Sınav :$ders \n "
          "Sınavın İçerdiği Soru Sayısı: $soruSayisi \n"
          "Çözdüğünüz Soru Sayısı: $sayi \n"
          "Dogru Sayınız: $dogru \n"
          "Yanlış Sayınız: $yanlis \n";

      for(var i = 0; i <= sayi; i++){
        "Dogru Sayınız: $dogru \n"
            "$i. Soru Sonucu:  \n";
      }


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
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white12.withOpacity(0.4),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(right: 10.0, left: 10, top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sayın "+kullaniciAdi! + ",  Sınav Analiziniz: ",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Sınavın Adı: " + ders!,
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Sınavda Geçirdiğiniz Süre: " + zaman!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Toplam Netiniz: " + net.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 5),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: Colors.red.shade200.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    analiz!,
                                    textAlign: TextAlign.center,
                                    style:
                                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
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
                                  for(int i = 0; i <= sayi-1; i++)...[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 3,top: 3),
                                      child: Text(""+ (i+1).toString() +". Soru(Konusu :"+konular![i].toString()+"): "+ data![i+10].toString(),
                                        textAlign: TextAlign.center,
                                        style:
                                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold
                                      )
                                      ),
                                    ),
                                    if(i != sayi-1)...{
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

                              ])),

                        /*for(var i = 0; i <= sayi; i++){
          "Dogru Sayınız: $dogru \n"
          "$i. Soru Sonucu: 1\n";
          }*/

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

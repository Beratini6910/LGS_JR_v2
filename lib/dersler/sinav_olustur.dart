import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lgs_jr_v2/analizler/analiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lgs_jr_v2/globals.dart' as globals;

class Sinav_Olustur extends StatefulWidget {
  @override
  _Sinav_OlusturState createState() => _Sinav_OlusturState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

String zaman(int milisaniye) {
  var saniye = milisaniye ~/ 1000;
  var dakika = ((saniye % 3600) ~/ 60).toString().padLeft(2, '0');
  var saniyeler = (saniye % 60).toString().padLeft(2, '0');

  return "$dakika:$saniyeler";
}

class _Sinav_OlusturState extends State<Sinav_Olustur> {
  String kullaniciAdi = '';
  String email = '';
  String sifre = '';
  String cevap = '';
  double net = 0;
  String soru = "";
  String sik1 = "";
  String sik2 = "";
  String sik3 = "";
  String sik4 = "";
  String konu = "";

  final TextEditingController _temiz1 = new TextEditingController();
  final TextEditingController _temiz2 = new TextEditingController();
  final TextEditingController _temiz3 = new TextEditingController();
  final TextEditingController _temiz4 = new TextEditingController();
  final TextEditingController _temiz5 = new TextEditingController();
  final TextEditingController _temiz6 = new TextEditingController();
  final TextEditingController _konu = new TextEditingController();
  String sinavSuresi1 = "10";
  int sinavSuresi = 0;
  int sayi = 1;
  String Soru1 = "Soru";
  String A = "A";
  String B = "B";
  String C= "C";
  String D = "D";
  String sonuc = "";
  String sinavAdi = "BoşSınav";
  String sinav_sifresi = "";
  String dogru_cevap = "";

  void SoruKaydet(deger) {
    deger = sayi.toString() + deger;
  }

  /* void AnalizeGonder() {
    var data = [];
    String ders = "Matematik";
    data.add(kullaniciAdi);
    data.add(email);
    data.add(ders);
    data.add(net);
    data.add(zaman(_sayac.elapsedMilliseconds));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Bitir(),
          settings: RouteSettings(
            arguments: data,
          ),
        ));
  }
*/

  @override
  Widget build(BuildContext context) {

    List? data = [];
    data = ModalRoute.of(context)!.settings.arguments as List?;
    kullaniciAdi = data![0];
    email = data[1];
    sifre = data[2];

    // String sik5 = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.deepPurple.shade400,
        appBar: AppBar(
          backgroundColor: Colors.green.shade400,
          title: Text(
            "Sınav Oluşturma",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Container(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/quiz.jpg"),
                      fit: BoxFit.cover
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.blue.shade200,

                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[

                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      (sayi).toString() + '.Soru  ',
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(color: Colors.green.shade500,height: 35,width:3),
                                Expanded(
                                  child: Container(

                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text("Sınav Süresi:"),
                                        Center(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  textAlign: TextAlign.right,
                                                  decoration: InputDecoration.collapsed(hintText: "Sınav kaç dakika sürecek?"),
                                                  onChanged: (String text ){
                                                    setState(() {
                                                      sinavSuresi1 = text;
                                                      sinavSuresi = int.parse(sinavSuresi1);
                                                    });
                                                  },
                                                  onSubmitted: (String text ){
                                                    setState(() {
                                                      sinavSuresi1 = text;
                                                      sinavSuresi = int.parse(sinavSuresi1);
                                                    });
                                                  },
                                                ),
                                              ),
                                              Expanded(child: Text("   dakika"))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  width: 3,
                                ),

                              ],
                            ),
                            Container(color: Colors.green.shade500,width: double.infinity, height: 3,),
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 1),
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(child: Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                " Sınav Parolası:",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),

                                              Expanded(
                                                child: TextField(
                                                  textAlign: TextAlign.left,
                                                  decoration: InputDecoration.collapsed(hintText: " Parola"),
                                                  style: TextStyle(fontSize: 18),
                                                  onChanged: (String text ){
                                                    setState(() {
                                                      sinav_sifresi = text;
                                                    });
                                                  },
                                                  onSubmitted: (String text ){
                                                    setState(() {
                                                      sinav_sifresi = text;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(color: Colors.green.shade500,height: 20,width:3),

                                            ],

                                          )
                                      )),
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Text(
                                              "Sınav Adı:",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                                            Expanded(
                                              child: TextField(
                                                textAlign: TextAlign.left,
                                                decoration: InputDecoration.collapsed(hintText: " Sınav Adı"),
                                                style: TextStyle(fontSize: 18),
                                                onChanged: (String text ){
                                                  setState(() {
                                                    sinavAdi = text;
                                                  });
                                                },
                                                onSubmitted: (String text ){
                                                  setState(() {
                                                    sinavAdi = text;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(color: Colors.green.shade500,width: double.infinity, height: 3,),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 4,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Sorunun Konusu:",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),

                                        Expanded(
                                          child: TextField(
                                            controller: _konu,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration.collapsed(hintText: " Konu"),
                                            style: TextStyle(fontSize: 18),
                                            onChanged: (String text ){
                                              setState(() {
                                                konu = text;
                                              });
                                            },
                                            onSubmitted: (String text ){
                                              setState(() {
                                                konu = text;
                                              });
                                            },
                                          ),
                                        ),
                                        //Container(color: Colors.green.shade500,height: 20,width:3),

                                      ],

                                    ),
                                  )
                                ],
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                      SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 3,bottom: 5),
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 10,
                              child: Container(

                                width: double.infinity,

                                padding: const EdgeInsets.all(20.0),

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green.shade100,


                                  /*gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.yellow,
                                  Colors.purple,
                                  Colors.green,
                                ])*/

                                ),
                                child: SingleChildScrollView(
                                  child: TextField(

                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 5,
                                    maxLines: 10,  // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.

                                    // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                                    controller: _temiz1,
                                    decoration: InputDecoration.collapsed(hintText: "Sorunuzu giriniz"),
                                    onChanged: (String text ){
                                      setState(() {
                                        soru = text;
                                      });
                                    },
                                    onSubmitted: (String text ){
                                      setState(() {
                                        soru = text;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: Container(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0,bottom: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                                width: 4,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.blue.shade100,
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: TextField(
                                                  textInputAction: TextInputAction.newline,
                                                  keyboardType: TextInputType.multiline,
                                                  minLines: 5,
                                                  maxLines: 15,
                                                  controller: _temiz2,
                                                  decoration: InputDecoration.collapsed(hintText: "A) Şıkkını giriniz"),
                                                  onChanged: (String text ){
                                                    setState(() {
                                                      sik1 = text;
                                                    });
                                                  },
                                                  onSubmitted: (String text ){
                                                    setState(() {
                                                      sik1 = text;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 0,bottom: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                                width: 4,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.blue.shade100,
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: TextField(
                                                  textInputAction: TextInputAction.newline,
                                                  keyboardType: TextInputType.multiline,
                                                  minLines: 5,
                                                  maxLines: 15,
                                                  controller: _temiz3,
                                                  decoration: InputDecoration.collapsed(hintText: "B) Şıkkını giriniz"),
                                                  onChanged: (String text ){
                                                    setState(() {
                                                      sik2 = text;
                                                    });
                                                  },
                                                  onSubmitted: (String text ){
                                                    setState(() {
                                                      sik2 = text;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0,bottom: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                                width: 4,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.blue.shade100,
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: TextField(
                                                  textInputAction: TextInputAction.newline,
                                                  keyboardType: TextInputType.multiline,
                                                  minLines: 5,
                                                  maxLines: 15,
                                                  controller: _temiz4,
                                                  decoration: InputDecoration.collapsed(hintText: "C) Şıkkını giriniz"),
                                                  onChanged: (String text ){
                                                    setState(() {
                                                      sik3 = text;
                                                    });
                                                  },
                                                  onSubmitted: (String text ){
                                                    setState(() {
                                                      sik3 = text;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0,bottom: 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                                width: 4,
                                              ),
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.blue.shade100,
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: TextField(
                                                  textInputAction: TextInputAction.newline,
                                                  keyboardType: TextInputType.multiline,
                                                  minLines: 5,
                                                  maxLines: 15,
                                                  controller: _temiz5,
                                                  decoration: InputDecoration.collapsed(hintText: "D) Şıkkını giriniz"),
                                                  onChanged: (String text ){
                                                    setState(() {
                                                      sik4 = text;
                                                    });
                                                  },
                                                  onSubmitted: (String text ){
                                                    setState(() {
                                                      sik4 = text;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])),


                  Row(
                    children: <Widget>[
                      Expanded(
                          child:
                          Container(
                            margin: const EdgeInsets.only(left: 3,right: 5),
                            padding: const EdgeInsets.only(top: 10,bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blue.shade100,
                            ),

                            child: TextField(

                              controller: _temiz6,
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                                LengthLimitingTextInputFormatter(1),
                              ],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration.collapsed(hintText: "Doğru Şıkkı Giriniz."),

                              style: TextStyle(fontSize: 18),
                              onChanged: (String text ){
                                setState(() {
                                  dogru_cevap = text;
                                });
                              },
                              onSubmitted: (String text ){
                                setState(() {
                                  dogru_cevap = text;
                                });
                              },
                            ),
                          ),),
                      Flexible(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 20),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red.shade400),
                            ),
                            onPressed: () {

                              /*
                              SoruKaydet(Soru1);
                              SoruKaydet(A);
                              SoruKaydet(B);
                              SoruKaydet(C);
                              SoruKaydet(D);
                              */


                              if(sayi == 1){
                                FirebaseFirestore.instance.collection("Sinavlar").doc(sinavAdi).set(
                                    {
                                    });
                              }

                              if(sinavAdi==""){
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Sınav Adı Boş Olamaz'),
                                    content: const Text("Sınav adı boş olamaz. Lütfen Düzeltin."),
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

                              if(sinav_sifresi==""){
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Sınav Şifresi Boş Olamaz'),
                                    content: const Text("Sınav şifresi boş Olamaz. Lütfen Düzeltin."),
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

                              if(soru==""){
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Soru Boş Olamaz'),
                                    content: const Text("Soru Metni boş olamaz. Lütfen Düzeltin."),
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

                              if(sik1 ==""||sik2 ==""||sik3 ==""||sik4 ==""){
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Şıklar Boş Olamaz'),
                                    content: const Text("Şıklardan en az bir tanesi boş. Lütfen Düzeltin."),
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

                              if(sinavSuresi ==0){
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Sınav Süresi Hatalı!'),
                                    content: const Text("Sınav Süresi boş olamaz."),
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

                              if(dogru_cevap !="A"&&dogru_cevap !="B"&&dogru_cevap !="C"&&dogru_cevap !="D"){
                                _temiz6.clear();
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Doğru Cevap Hatalı!'),
                                    content: const Text("Doğru Cevap A', 'B' , 'C' veya 'D' olmaıdır."),
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

                              FirebaseFirestore.instance.collection("Sinavlar").doc(sinavAdi).update({
                                "00_Sinavi_Olusturan_Hesap_Maili": email,
                                "0_Sinavin_Adi" : sinavAdi,
                                "0_Sinavin_Sifresi" : sinav_sifresi,
                                "0_Sinav_Suresi" : sinavSuresi,
                                "0_Soru_Sayisi" : sayi,
                                sayi.toString() + Soru1 : soru,
                                sayi.toString()+ "_" + A : sik1,
                                sayi.toString()+ "_" + B : sik2,
                                sayi.toString()+ "_" + C : sik3,
                                sayi.toString()+ "_" + D : sik4,
                                sayi.toString()+ "_Dogru"  : dogru_cevap,
                                sayi.toString()+ "_Konu" : konu,
                                //'Süre' : zaman,
                              }).whenComplete(() => print("Firestore'a eklenildi."));
                              setState(() {
                                sayi = sayi+1;
                              });

                              _temiz1.clear();
                              _temiz2.clear();
                              _temiz3.clear();
                              _temiz4.clear();
                              _temiz5.clear();
                              _temiz6.clear();
                              //_konu.clear();

                            },
                            child: const Text("Soruyu Kaydet",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),),

                          ),
                        ),
                      ),
                    ],
                  ),


                  /*Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Anasayfa(),
                            settings: RouteSettings(
                              arguments: data,
                            )));
                  },
                  child: Text('Anasayfaya Dön'),
                ),
              ),*/
                ],
              ),
            ),
          ),
        )
    );


  }

}

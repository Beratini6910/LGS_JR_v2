import 'dart:async';
import 'package:lgs_jr_v2/analizler/analiz.dart';
import 'package:flutter/material.dart';

class MatematikSorular extends StatefulWidget {
  @override
  _MatematikSorularState createState() => _MatematikSorularState();
}

String zaman(int milisaniye) {
  var saniye = milisaniye ~/ 1000;
  var dakika = ((saniye % 3600) ~/ 60).toString().padLeft(2, '0');
  var saniyeler = (saniye % 60).toString().padLeft(2, '0');

  return "$dakika:$saniyeler";
}

class _MatematikSorularState extends State<MatematikSorular> {
  bool _isAbsorbing = false;
  String kullaniciAdi = '';
  String email = '';
  String sifre = '';
  int soru = 0;
  String cevap = '';
  double net = 0;

  void NetYuvarla(deger) {
    String inString = deger.toStringAsFixed(1);
    net = double.parse(inString);
  }

  late Stopwatch _sayac;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _sayac = Stopwatch();
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void AnalizeGonder() {
    NetYuvarla(net);
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

  void cevapKontrol() {
    if (soru >= 9 &&cevap.contains(sorular[soru]['dogrucevap'])) {
      net = net+1;
      soru = 0;
      _timer.cancel();
      AnalizeGonder();
    }
    else if(soru >= 9 &&!cevap.contains(sorular[soru]['dogrucevap'])){
      net = net - 0.3;
      soru = 0;
      _timer.cancel();
      AnalizeGonder();
    }
    else {
      if (cevap.contains(sorular[soru]['dogrucevap'])) {
        net = net + 1;
        soru++;
      } else {
        net = net - 0.3;
        soru++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List? data = [];
    data = ModalRoute.of(context)!.settings.arguments as List?;
    kullaniciAdi = data![0];
    email = data[1];
    sifre = data[2];

    _sayac.start();
    if (soru <= 9 && _sayac.elapsedMilliseconds == 1200000) {
      Future.delayed(Duration.zero, () async {
        _timer.cancel();
        soru = 0;
        AnalizeGonder();
      });
    }

    List cevapdeposu = [];
    for (var u in sorular[soru]['cevap']) {
      cevapdeposu.add(u);
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade400,
      appBar: AppBar(
        backgroundColor: Colors.red.shade400,
        title: Text(
          "Matematik Testi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
    child: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/images/x2.jpg"),
    fit: BoxFit.cover
    )
    ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12.0,bottom: 4.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Netiniz: ' + net.toStringAsFixed(1),
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          (soru + 1).toString() + '.Soru  ',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                            "Süre: " +
                                zaman(1200000 - _sayac.elapsedMilliseconds),
                            style: TextStyle(fontSize: 18.0)),
                      ),
                    ),

                    SizedBox(
                      width: 10,
                    ),

                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 7,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 100, maxHeight: 225),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.shade200,
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.yellow,
                              Colors.purple,
                              Colors.green,
                            ])),
                    child: SingleChildScrollView(
                      child: Text(
                        sorular[soru]['soru'],
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: AbsorbPointer(
                        absorbing: _isAbsorbing,
                        child: ElevatedButton(
                          onPressed: () {

                            setState(() {
                              _isAbsorbing = true;
                            });
                            Future.delayed(Duration(seconds: 1), () {
                              setState(() {
                                _isAbsorbing = false;
                              });
                            });

                            Timer(Duration(milliseconds: 500), (){

                              setState(() {
                                cevap = cevapdeposu[0].toString();
                                cevapKontrol();
                              });
                            });
                          },
                          child: SingleChildScrollView(
                            child: Text(
                              cevapdeposu[0],
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ),

              Padding(
                padding:
                const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: AbsorbPointer(
                    absorbing: _isAbsorbing,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isAbsorbing = true;
                        });
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            _isAbsorbing = false;
                          });
                        });
                        Timer(Duration(milliseconds: 500), (){

                          setState(() {
                            cevap = cevapdeposu[1].toString();
                            cevapKontrol();
                          });
                        });
                      },
                      child: SingleChildScrollView(
                        child: Text(
                          cevapdeposu[1],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: AbsorbPointer(
                    absorbing: _isAbsorbing,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isAbsorbing = true;
                        });
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            _isAbsorbing = false;
                          });
                        });
                        Timer(Duration(milliseconds: 500), (){

                          setState(() {
                            cevap = cevapdeposu[2].toString();
                            cevapKontrol();
                          });
                        });
                      },
                      child: SingleChildScrollView(
                        child: Text(
                          cevapdeposu[2],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: AbsorbPointer(
                    absorbing: _isAbsorbing,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isAbsorbing = true;
                        });
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            _isAbsorbing = false;
                          });
                        });
                        Timer(Duration(milliseconds: 500), (){

                          setState(() {
                            cevap = cevapdeposu[3].toString();
                            cevapKontrol();
                          });
                        });
                      },
                      child: SingleChildScrollView(
                        child: Text(
                          cevapdeposu[3],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
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
    ));
  }

  List sorular = [
    {
      'soru':
          "Bir inşaat firması Erzurum’daki bir fabrikadan 50 kilogramlık paketler hâlinde satılan çimentoyu nakliye hariç paketi 12 liradan, Rize’deki bir fabrikadan ise 25 kilogramlık paketler hâlinde satılan çimentoyu nakliye hariç 7 liradan satın alabilmektedir. İnşaat firmasının alacağı çimentoyu şantiyesine getirmek için Erzurum’dan alması durumunda 1200 TL, Rize’den alması durumunda ise 700 TL nakliye ücreti ödemesi gerekmektedir. Buna göre inşaat firmasının almayı düşündüğü çimento kaç kilogramdır?",
      'cevap': [' A) 17 500', 'B) 15 000', 'C) 12 500', 'D) 7500'],
      'dogrucevap': 'A)'
    },
    {
      'soru': "Bir kurstaki piyano ve keman dersi alan öğrenciler arasından birer kişi seçilerek piyano ve keman dinletisi yapılacaktır. İki dersi de alan öğrencinin bulunmadığı bu kursta piyano dersi alanların listesindeki öğrenciler 1’den 15’e kadar, keman dersi alanların listesindeki öğrenciler 1’den 20’ye kadar numaralandırılmıştır." +
          "Seçilecek olan kişilerin sıra numaralarının birbirinden farklı tam kare sayılar olmaları istenmektedir." +
          "Buna göre bu seçim için kaç farklı olası durum vardır?",
      'cevap': ['A) 6', 'B) 7', 'C) 8', 'D) 9'],
      'dogrucevap': ("A)")
    },
    {
      'soru':
          "Bir bilgisayar programı, koordinat sisteminde bir noktayı, her bir adımında noktanın x eksenine uzaklığını 1 birim azaltacak ve y eksenine uzaklığını 2 birim artıracak şekilde hareket ettirmektedir. A(–2, 7) noktası bu bilgisayar programı ile orijinden geçen ve eğimi 2 1 - olan doğru üzerine getirilmeye çalışılıyor.",
      'cevap': ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      'dogrucevap': 'B) '
    },
    {
      'soru': "Eylül Hanım, kredi kartı için her hanesinde bir rakam olan dört haneli bir şifre belirleyecektir. Bunun için soldan sağa doğru ilk haneye yazdığı rakamın karesini ikinci haneye ve ikinci haneye yazdığı rakamın karesini son iki haneye yazarak şifresini oluşturuyor." +
          "Eylül Hanım’ın oluşturduğu şifrenin son rakamı 6 olduğuna göre ilk rakamı kaçtır?",
      'cevap': ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      'dogrucevap': 'A) '
    },
    {
      'soru': "Bir sınıftaki öğrencilerin tamamı teknoloji tasarım dersinde her grupta eşit sayıda öğrenci ve en az 2 kız öğrenci olacak şekilde iki gruba ayrılacaktır." +
          "Birinci gruptan seçilen bir öğrencinin kız olma olasılığı 4/3 , ikinci gruptan seçilen bir öğrencinin erkek olma olasılığı 8/7 ’dir.Buna göre bu sınıfta en az kaç kız öğrenci vardır?",
      'cevap': ['A) 10', 'B) 12', 'C) 14', 'D) 16'],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "(2*2)*8/2*2?",
      'cevap': [
        'A) 4',
        'B) 8',
        'C) 16',
        'D) 32'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "6A ve B8 iki basamaklı sayılardır.6 ile A aralarında asaldır.B ile 8 aralarında asaldır.6A sayısı B8 sayısından küçüktür.Bu şartları sağlayan kaç farklı A B + değeri vardır?",
      'cevap': ['A) 3', 'B) 5', 'C) 6', 'D) 8'],
      'dogrucevap': 'B) '
    },
    {
      'soru': "Merdivenlerin basamaklarının yüksekliği belli standartlara göre yapılmaktadır. Bu standartlara göre basamak yüksekliği 18 cm’den fazla olmamalıdır. Aşağıda bu standartlara göre zeminden birinci duvarın üstüne ve birinci duvardan ikinci duvarın üstüne doğru yapılacak eş basamaklardan oluşan merdiven modellenmiştir." +
          "Modeldeki merdivenin basamaklarının yüksekliği santimetre cinsinden tam sayı olduğuna göre bu merdiven en az kaç basamaktan oluşmuştur?",
      'cevap': ['A) 10', 'B) 15', 'C) 20', 'D) 30'],
      'dogrucevap': 'B) '
    },
    {
      'soru': "Deniz, mahalle muhtarı ile görüşerek evinin bulunduğu sokağın kaldırımlarına kedi ve köpekler için mama kapları koymuştur.Deniz, 180 m uzunluğundaki birbirine paralel kaldırımlardan birine 12’şer metre arayla kediler için, diğerine 15’er metre" +
          "arayla köpekler için kaldırımların başında ve sonunda karşılıklı birer tane olacak şekilde mama kapları koymuştur. Mahalle muhtarı da karşılıklı aynı hizada bulunan mama kaplarının yanlarına birer tane su kabı koymuştur. Buna göre mahalle muhtarı kaç tane su kabı koymuştur?",
      'cevap': ['A) 6', 'B) 8', 'C) 10', 'D) 12'],
      'dogrucevap': 'D) '
    },
    {
      'soru': "Kerem, okuduğu bir dergide 1 liralık madenî paraların kütlesinin 8200 miligram, 50 kuruşlukların ise 6800 miligram olduğunu öğreniyor.Kumbarasında 50 kuruşluk ve 1 liralık madenî paralar biriktiren Kerem, bu paraları saymak yerine tartarak ne kadar para biriktirdiğini bulmak istiyor." +
          "Kerem elektronik bir tartıda, biriktirdiği 1 liralık tüm madenî paraları ve 50 kuruşluk tüm madenî paraları ayrı ayrı tartıyor. Bu iki tartma işleminin sonucu birbirine eşit olduğuna göre Kerem’in biriktirdiği para en az kaç liradır?",
      'cevap': ['A) 49', 'B) 50', 'C) 51', 'D) 55'],
      'dogrucevap': 'D) '
    },
  ];
}

import 'dart:async';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/analizler/analiz.dart';
import 'package:flutter/material.dart';

class SosyalSorular extends StatefulWidget {
  @override
  _SosyalSorularState createState() => _SosyalSorularState();
}

String zaman(int milisaniye) {
  var saniye = milisaniye ~/ 1000;
  var dakika = ((saniye % 3600) ~/ 60).toString().padLeft(2, '0');
  var saniyeler = (saniye % 60).toString().padLeft(2, '0');

  return "$dakika:$saniyeler";
}

class _SosyalSorularState extends State<SosyalSorular> {
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
    String ders = "Sosyal Bilimler";
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
    email = data![1];
    sifre = data![2];

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
      backgroundColor: Colors.orange.shade200,
      appBar: AppBar(
        backgroundColor: Colors.red.shade400,
        title: Text(
          "Sosyal Bilimleri Testi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
    child: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/images/x3.png"),
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
                              Colors.grey[500]!,
                              Colors.yellow[300]!,
                              Colors.purple[500]!,
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
          "Aşağıdakilerden hangisi ilköğretim altıncı sınıf öğrencisi Bahadır’ın evde alabileceği sorumluluklardan biri olamaz?",
      'cevap': [
        'A) Sabah uyandığında yatağını düzeltmek',
        'B) Odasını temiz ve düzenli tutmak',
        'C) Yemek için sofranın hazırlanmasına yardım etmek',
        'D) Ailesinin ekonomik ihtiyaçlarını karşılamak'
      ],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "Toplumsal yaşamın vazgeçilmezi olan değerlerin, örf ve âdetlerin, gelenek ve göreneklerin nesilden nesile aktarılmasını sağlayan kültürel öge aşağıdakilerden hangisidir?",
      'cevap': ['A) Din', 'B) Dil', 'C) Tarih', 'D) Ahlak'],
      'dogrucevap': 'D) '
    },
    {
      'soru': "Önyargılar insanlar arasındaki ilişkileri nasıl etkiler?",
      'cevap': [
        'A) Arkadaşlık bağlarını kuvvetlendirir.',
        'B) İletişimdeki hataları azaltır',
        'C) Kişilerin doğru anlaşılmasını sağlar.',
        'D) İnsanları birbirinden uzaklaştırır.'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Aşağıdakilerden hangisi sivil toplum örgütlerinin kuruluş amaçlarından değildir?",
      'cevap': [
        'A) Toplumun sorunlarına çözüm bulmak',
        'B) Toplumun birlik ve beraberliğini artırmak',
        'C) Üyelerinin ekonomik ihtiyaçlarını karşılamak',
        'D) Toplumu bilinçlendirmek'
      ],
      'dogrucevap': 'C) '
    },
    {
      'soru':
          "Aşağıdakilerden hangisi sosyal yardımlaşma ve dayanışmanın sonuçlarından biri değildir?",
      'cevap': [
        'A) İnsanlar arasında dostluk duyguları kuvvetlenir.',
        'B) Birlik ve beraberlik duyguları artar.',
        'C) Zengin ile yoksul arasındaki farklılık artar.',
        'D) Toplumsal huzur ve mutluluk artar.'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "İnsanların piknik yapıp açık havada eğlenme hakları vardır. Ancak piknik yaparken çevreyi kirletmeye hakları yoktur. Çünkü tüm insanların temiz bir çevrede yaşama hakları vardır. Buna göre aşağıdakilerden hangisi söylenemez?",
      'cevap': [
        'A) İnsanlar birbirlerinin haklarına saygı göstermelidir.',
        'B) Kişilerin özgürlüğü başkasının hakkını çiğnememelidir',
        'C) İnsanlar haklarını sınırsızca kullanabilmelidir.',
        'D) Haklarımızı kullanırken başkalarının hakkına zarar vermemeliyiz.'
      ],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "Kültürel ögelerimizden biri de düğünlerimizdir. Toplumun her kesiminden insanların katılımıyla gerçekleşen düğünlerde türküler söylenir, yemekler verilir ve evlenenlerin mutluluğu için dualar edilir. Buna göre aşağıdakilerden hangisine ulaşılamaz?",
      'cevap': [
        'A) Kültürel ögeler toplumda kaynaştırıcı bir özelliğe sahiptir',
        'B) Düğünler ülkenin her yerinde aynı şekilde kutlanır.',
        'C) Kültürel ögeler bir arada yaşama isteğinin önemli göstergelerinden biridir.',
        'D) Düğünlerde dini uygulamalar da yerini almıştır.'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          " Aşağıdakilerden hangisi ilköğretim altıncı sınıf öğrencisi Bahadır’ın evde alabileceği sorumluluklardan biri olamaz?",
      'cevap': [
        'A) Sabah uyandığında yatağını düzeltmek',
        'B) Odasını temiz ve düzenli tutmak',
        'C) Yemek için sofranın hazırlanmasına yardım etmek',
        'D) Ailesinin ekonomik ihtiyaçlarını karşılamak'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Aşağıdakilerden hangisi kurultayın özelliklerinden biri değildir?",
      'cevap': [
        'A) Siyasi, askerî ve ekonomik kararların alınması',
        'B) Devlet yönetiminde önemli bir meclis olması',
        'C) Kurultaya boy beylerinin ve hatunun da katılması',
        'D) Yönetimde son sözün kurultaya ait olması'
      ],
      'dogrucevap': ' D) '
    },
    {
      'soru':
          "Aşağıdakilerden hangisi Uygurların yerleşik hayata geçtiğini gösterir?",
      'cevap': [
        'A) Sözlü edebiyatı devam ettirmeleri',
        'B) Hayvancılıkla uğraşmaları',
        'C) Saraylar ve tapınaklar inşa etmeler',
        'D) Hükümdarlığın babadan oğula geçmesi'
      ],
      'dogrucevap': 'C) '
    },
  ];
}

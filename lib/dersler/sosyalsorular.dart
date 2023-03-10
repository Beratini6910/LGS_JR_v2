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
                            "S??re: " +
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
                  child: Text('Anasayfaya D??n'),
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
          "A??a????dakilerden hangisi ilk????retim alt??nc?? s??n??f ????rencisi Bahad??r?????n evde alabilece??i sorumluluklardan biri olamaz?",
      'cevap': [
        'A) Sabah uyand??????nda yata????n?? d??zeltmek',
        'B) Odas??n?? temiz ve d??zenli tutmak',
        'C) Yemek i??in sofran??n haz??rlanmas??na yard??m etmek',
        'D) Ailesinin ekonomik ihtiya??lar??n?? kar????lamak'
      ],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "Toplumsal ya??am??n vazge??ilmezi olan de??erlerin, ??rf ve ??detlerin, gelenek ve g??reneklerin nesilden nesile aktar??lmas??n?? sa??layan k??lt??rel ??ge a??a????dakilerden hangisidir?",
      'cevap': ['A) Din', 'B) Dil', 'C) Tarih', 'D) Ahlak'],
      'dogrucevap': 'D) '
    },
    {
      'soru': "??nyarg??lar insanlar aras??ndaki ili??kileri nas??l etkiler?",
      'cevap': [
        'A) Arkada??l??k ba??lar??n?? kuvvetlendirir.',
        'B) ??leti??imdeki hatalar?? azalt??r',
        'C) Ki??ilerin do??ru anla????lmas??n?? sa??lar.',
        'D) ??nsanlar?? birbirinden uzakla??t??r??r.'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "A??a????dakilerden hangisi sivil toplum ??rg??tlerinin kurulu?? ama??lar??ndan de??ildir?",
      'cevap': [
        'A) Toplumun sorunlar??na ????z??m bulmak',
        'B) Toplumun birlik ve beraberli??ini art??rmak',
        'C) ??yelerinin ekonomik ihtiya??lar??n?? kar????lamak',
        'D) Toplumu bilin??lendirmek'
      ],
      'dogrucevap': 'C) '
    },
    {
      'soru':
          "A??a????dakilerden hangisi sosyal yard??mla??ma ve dayan????man??n sonu??lar??ndan biri de??ildir?",
      'cevap': [
        'A) ??nsanlar aras??nda dostluk duygular?? kuvvetlenir.',
        'B) Birlik ve beraberlik duygular?? artar.',
        'C) Zengin ile yoksul aras??ndaki farkl??l??k artar.',
        'D) Toplumsal huzur ve mutluluk artar.'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "??nsanlar??n piknik yap??p a????k havada e??lenme haklar?? vard??r. Ancak piknik yaparken ??evreyi kirletmeye haklar?? yoktur. ????nk?? t??m insanlar??n temiz bir ??evrede ya??ama haklar?? vard??r. Buna g??re a??a????dakilerden hangisi s??ylenemez?",
      'cevap': [
        'A) ??nsanlar birbirlerinin haklar??na sayg?? g??stermelidir.',
        'B) Ki??ilerin ??zg??rl?????? ba??kas??n??n hakk??n?? ??i??nememelidir',
        'C) ??nsanlar haklar??n?? s??n??rs??zca kullanabilmelidir.',
        'D) Haklar??m??z?? kullan??rken ba??kalar??n??n hakk??na zarar vermemeliyiz.'
      ],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "K??lt??rel ??gelerimizden biri de d??????nlerimizdir. Toplumun her kesiminden insanlar??n kat??l??m??yla ger??ekle??en d??????nlerde t??rk??ler s??ylenir, yemekler verilir ve evlenenlerin mutlulu??u i??in dualar edilir. Buna g??re a??a????dakilerden hangisine ula????lamaz?",
      'cevap': [
        'A) K??lt??rel ??geler toplumda kayna??t??r??c?? bir ??zelli??e sahiptir',
        'B) D??????nler ??lkenin her yerinde ayn?? ??ekilde kutlan??r.',
        'C) K??lt??rel ??geler bir arada ya??ama iste??inin ??nemli g??stergelerinden biridir.',
        'D) D??????nlerde dini uygulamalar da yerini alm????t??r.'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          " A??a????dakilerden hangisi ilk????retim alt??nc?? s??n??f ????rencisi Bahad??r?????n evde alabilece??i sorumluluklardan biri olamaz?",
      'cevap': [
        'A) Sabah uyand??????nda yata????n?? d??zeltmek',
        'B) Odas??n?? temiz ve d??zenli tutmak',
        'C) Yemek i??in sofran??n haz??rlanmas??na yard??m etmek',
        'D) Ailesinin ekonomik ihtiya??lar??n?? kar????lamak'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "A??a????dakilerden hangisi kurultay??n ??zelliklerinden biri de??ildir?",
      'cevap': [
        'A) Siyasi, asker?? ve ekonomik kararlar??n al??nmas??',
        'B) Devlet y??netiminde ??nemli bir meclis olmas??',
        'C) Kurultaya boy beylerinin ve hatunun da kat??lmas??',
        'D) Y??netimde son s??z??n kurultaya ait olmas??'
      ],
      'dogrucevap': ' D) '
    },
    {
      'soru':
          "A??a????dakilerden hangisi Uygurlar??n yerle??ik hayata ge??ti??ini g??sterir?",
      'cevap': [
        'A) S??zl?? edebiyat?? devam ettirmeleri',
        'B) Hayvanc??l??kla u??ra??malar??',
        'C) Saraylar ve tap??naklar in??a etmeler',
        'D) H??k??mdarl??????n babadan o??ula ge??mesi'
      ],
      'dogrucevap': 'C) '
    },
  ];
}

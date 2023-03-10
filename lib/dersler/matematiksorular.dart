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
          "Bir in??aat firmas?? Erzurum???daki bir fabrikadan 50 kilograml??k paketler h??linde sat??lan ??imentoyu nakliye hari?? paketi 12 liradan, Rize???deki bir fabrikadan ise 25 kilograml??k paketler h??linde sat??lan ??imentoyu nakliye hari?? 7 liradan sat??n alabilmektedir. ??n??aat firmas??n??n alaca???? ??imentoyu ??antiyesine getirmek i??in Erzurum???dan almas?? durumunda 1200 TL, Rize???den almas?? durumunda ise 700 TL nakliye ??creti ??demesi gerekmektedir. Buna g??re in??aat firmas??n??n almay?? d??????nd?????? ??imento ka?? kilogramd??r?",
      'cevap': [' A) 17 500', 'B) 15 000', 'C) 12 500', 'D) 7500'],
      'dogrucevap': 'A)'
    },
    {
      'soru': "Bir kurstaki piyano ve keman dersi alan ????renciler aras??ndan birer ki??i se??ilerek piyano ve keman dinletisi yap??lacakt??r. ??ki dersi de alan ????rencinin bulunmad?????? bu kursta piyano dersi alanlar??n listesindeki ????renciler 1???den 15???e kadar, keman dersi alanlar??n listesindeki ????renciler 1???den 20???ye kadar numaraland??r??lm????t??r." +
          "Se??ilecek olan ki??ilerin s??ra numaralar??n??n birbirinden farkl?? tam kare say??lar olmalar?? istenmektedir." +
          "Buna g??re bu se??im i??in ka?? farkl?? olas?? durum vard??r?",
      'cevap': ['A) 6', 'B) 7', 'C) 8', 'D) 9'],
      'dogrucevap': ("A)")
    },
    {
      'soru':
          "Bir bilgisayar program??, koordinat sisteminde bir noktay??, her bir ad??m??nda noktan??n x eksenine uzakl??????n?? 1 birim azaltacak ve y eksenine uzakl??????n?? 2 birim art??racak ??ekilde hareket ettirmektedir. A(???2, 7) noktas?? bu bilgisayar program?? ile orijinden ge??en ve e??imi 2 1 - olan do??ru ??zerine getirilmeye ??al??????l??yor.",
      'cevap': ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      'dogrucevap': 'B) '
    },
    {
      'soru': "Eyl??l Han??m, kredi kart?? i??in her hanesinde bir rakam olan d??rt haneli bir ??ifre belirleyecektir. Bunun i??in soldan sa??a do??ru ilk haneye yazd?????? rakam??n karesini ikinci haneye ve ikinci haneye yazd?????? rakam??n karesini son iki haneye yazarak ??ifresini olu??turuyor." +
          "Eyl??l Han??m?????n olu??turdu??u ??ifrenin son rakam?? 6 oldu??una g??re ilk rakam?? ka??t??r?",
      'cevap': ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      'dogrucevap': 'A) '
    },
    {
      'soru': "Bir s??n??ftaki ????rencilerin tamam?? teknoloji tasar??m dersinde her grupta e??it say??da ????renci ve en az 2 k??z ????renci olacak ??ekilde iki gruba ayr??lacakt??r." +
          "Birinci gruptan se??ilen bir ????rencinin k??z olma olas??l?????? 4/3 , ikinci gruptan se??ilen bir ????rencinin erkek olma olas??l?????? 8/7 ???dir.Buna g??re bu s??n??fta en az ka?? k??z ????renci vard??r?",
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
          "6A ve B8 iki basamakl?? say??lard??r.6 ile A aralar??nda asald??r.B ile 8 aralar??nda asald??r.6A say??s?? B8 say??s??ndan k??????kt??r.Bu ??artlar?? sa??layan ka?? farkl?? A B + de??eri vard??r?",
      'cevap': ['A) 3', 'B) 5', 'C) 6', 'D) 8'],
      'dogrucevap': 'B) '
    },
    {
      'soru': "Merdivenlerin basamaklar??n??n y??ksekli??i belli standartlara g??re yap??lmaktad??r. Bu standartlara g??re basamak y??ksekli??i 18 cm???den fazla olmamal??d??r. A??a????da bu standartlara g??re zeminden birinci duvar??n ??st??ne ve birinci duvardan ikinci duvar??n ??st??ne do??ru yap??lacak e?? basamaklardan olu??an merdiven modellenmi??tir." +
          "Modeldeki merdivenin basamaklar??n??n y??ksekli??i santimetre cinsinden tam say?? oldu??una g??re bu merdiven en az ka?? basamaktan olu??mu??tur?",
      'cevap': ['A) 10', 'B) 15', 'C) 20', 'D) 30'],
      'dogrucevap': 'B) '
    },
    {
      'soru': "Deniz, mahalle muhtar?? ile g??r????erek evinin bulundu??u soka????n kald??r??mlar??na kedi ve k??pekler i??in mama kaplar?? koymu??tur.Deniz, 180 m uzunlu??undaki birbirine paralel kald??r??mlardan birine 12?????er metre arayla kediler i??in, di??erine 15???er metre" +
          "arayla k??pekler i??in kald??r??mlar??n ba????nda ve sonunda kar????l??kl?? birer tane olacak ??ekilde mama kaplar?? koymu??tur. Mahalle muhtar?? da kar????l??kl?? ayn?? hizada bulunan mama kaplar??n??n yanlar??na birer tane su kab?? koymu??tur. Buna g??re mahalle muhtar?? ka?? tane su kab?? koymu??tur?",
      'cevap': ['A) 6', 'B) 8', 'C) 10', 'D) 12'],
      'dogrucevap': 'D) '
    },
    {
      'soru': "Kerem, okudu??u bir dergide 1 liral??k maden?? paralar??n k??tlesinin 8200 miligram, 50 kuru??luklar??n ise 6800 miligram oldu??unu ????reniyor.Kumbaras??nda 50 kuru??luk ve 1 liral??k maden?? paralar biriktiren Kerem, bu paralar?? saymak yerine tartarak ne kadar para biriktirdi??ini bulmak istiyor." +
          "Kerem elektronik bir tart??da, biriktirdi??i 1 liral??k t??m maden?? paralar?? ve 50 kuru??luk t??m maden?? paralar?? ayr?? ayr?? tart??yor. Bu iki tartma i??leminin sonucu birbirine e??it oldu??una g??re Kerem???in biriktirdi??i para en az ka?? lirad??r?",
      'cevap': ['A) 49', 'B) 50', 'C) 51', 'D) 55'],
      'dogrucevap': 'D) '
    },
  ];
}

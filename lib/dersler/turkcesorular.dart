import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/analizler/analiz.dart';
import 'package:flutter/material.dart';

class TurkceSorular extends StatefulWidget {
  @override
  _TurkceSorularState createState() => _TurkceSorularState();
}

String zaman(int milisaniye) {
  var saniye = milisaniye ~/ 1000;
  var dakika = ((saniye % 3600) ~/ 60).toString().padLeft(2, '0');
  var saniyeler = (saniye % 60).toString().padLeft(2, '0');

  return "$dakika:$saniyeler";
}

class _TurkceSorularState extends State<TurkceSorular> {
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

  void AnalizeGonder(){
    NetYuvarla(net);
    var data = [];
    String ders = "Türkçe";
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
        backgroundColor: Colors.green.shade200,
        appBar: AppBar(
          backgroundColor: Colors.red.shade400,
          title: Text("Türkçe Testi",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/x0.jpg"),
                  fit: BoxFit.cover
              )
          ),
          child: Center(
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
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                (soru + 1).toString() + '.Soru  ',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 100, maxHeight: 225),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green.shade200,
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.blue[500]!,
                                  Colors.yellow[100]!,
                                  Colors.red[500]!,
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
        ));
  }
  List sorular = [
    {//1
      'soru': "(I) Bizim memlekette dağ taş, orman ağaç hayatın hikâyesini anlatır. \n(II) Toprak burada ustanın elinden çıkmış bir çinidir, desen. \n(III) Toprak verimlidir; kuru çubuk diksen meyve verir, salkım salkım. \n(IV) Portakallar dallarında birer güneştir, turuncu turuncu.\nBu metinde numaralanmış cümlelerin hangilerinde aynı söz sanatı kullanılmıştır?",
      'cevap': [
        'A) I ve III',
        'B) I ve IV',
        'C) II ve III',
        'D) II ve IV'
      ],
      'dogrucevap': 'B) '
    },
    {//2
      'soru': "Bir sanatçıya, gazetecilerle yaptığı sohbet sırasında gazetecinin biri “Efendim, uzunsüredir yeni bir eser vermiyorsunuz. Yoksadüşüncelerinizin üzerine kar mı yağdı?” diyesordu. Bunun üzerine sanatçı “Kışın yağankar, toprağı örterek bitkileri şiddetli soğuktankorur. Toprağın altındaki bitki ve hayvanlarilkbahara hazırlanır. Karlar eridiğinde tümcanlılıklarıyla hayatlarına devam eder. Evet,benim düşüncelerimin üzerine kar yağdı.”şeklinde cevap verdi."+
          "Bu metinde sanatçının “Evet, benim düşüncelerimin üzerine kar yağdı.” sözüyle anlatmak istediği aşağıdakilerden hangisidir?",
      'cevap': [
        'A) Sanatçılar ürettikçe var olur, bu yüzden her zaman ortaya koyacakları bir eserleri olmalıdır.',
        'B) Eser üretmekte zorlanan sanatçılar, sanat güçlerini gittikçe kaybederler.',
        'C) Sanatçılar verimsiz bir dönemde gibi görünseler de yeni eserleri için zihinlerinde hazırlık yaparlar.',
        'D) Düşünce kısırlığı çeken sanatçılar, düşüncelerini zenginleştirmek için çok iyi gözlem yapmalıdır'
      ],
      'dogrucevap': 'A) '
    },
    {//3
      'soru': "(I) Çayın hikâyesi yaklaşık beşbin yıl evvel Çin’de başladı. (II) Efsaneye göre İmparator Shen Nung bir öğle istirahatindeyken hizmetkârları, içmesi için ona bir kapta su kaynatıyorlardı. (III) Bu sırada tatlı bir rüzgâr, sıcak suya birkaç çay yaprağı düşürdü. (IV) İmparator, bu suyu içince öyle beğendi ki çay bir içecek olarak keşfedilmiş oldu.",
      'cevap': [
        'A) I',
        'B) II',
        'C) III',
        'D) IV'
      ],
      'dogrucevap': 'A) '
    },
    {//4
      'soru': "Birden çok yüklemli cümlelerde öznenin bütün yüklemlerle uyumlu olması gerekir. Aksi takdirde özne eksikliğinden kaynaklanan anlatım bozukluğu meydana gelir. Aşağıdakilerin hangisinde bu açıklamayı örnekleyen bir anlatım bozukluğu vardır?",
      'cevap': [
        'A) Tarlaya tohumlar ekimde atılacak, ürün haziranda toplanacak.',
        'B) Bu hastalığın tedavisi bulunmalı, insanlığa tehdit olmaktan çıkarılmalı.',
        'C) Yazarın her kitabını okuyorum ve takdir ediyorum.',
        'D) Her akşam bizimle ilgilenir, yemek getirirdi.'
      ],
      'dogrucevap': 'B) '
    },
    {//5
      'soru': "Aşağıdaki cümlelerin hangisinde “tecrübe”yi anlatan bir söz kullanılmamıştır?",
      'cevap': [
        'A) Bizim takımın teknik direktörü eski kurttur, maçlarda takıma iyi taktik veriyor.',
        'B) Sütten ağzı yandı, yoğurdu üfleyerek yiyor; artık arkadaş seçiminde daha dikkatli.',
        'C) Ben insan sarrafı oldum, beni kolay kolay kandıramazlar',
        'D) İnce eleyip sık dokuduğundan işlerinde başarılı oluyor.'
      ],
      'dogrucevap': 'D) '
    },
    {//6
      'soru': "Ön yargı, kişinin bir kimse veya bir şeyle ilgili peşinen varsaydığı olumlu veya olumsuz tutumların tümüdür. Buna göre aşağıdakilerin hangisinde ön yargılı bir tutumdan söz edilemez?",
      'cevap': [
        'A) Emanete hıyanet olmaz.',
        'B) Kişi arkadaşından bellidir',
        'C) İnsan yedisinde ne ise yetmişinde de odur.',
        'D) Çok havlayan köpek ısırmaz.'
      ],
      'dogrucevap': 'A) '
    },
    {//7
      'soru':
      "Aşağıdaki hangi Anadolu takımı Türkiye Süper Liginde şampiyon olmuştur?",
      'cevap': [
        'A) Kocaelispor',
        'B) Bursaspor',
        'C) Eskişehirspor',
        'D) Hürrem Sultan'
      ],
      'dogrucevap': 'B) '
    },
    {//8
      'soru': "Anadolu’yu köy köy dolaşmış bir gezgin olarak Maçka’yı her zaman özlerim. Bu cümleyi dile getiren kişi için aşağıdakilerden hangisi kesin olarak söylenir?",
      'cevap': [
        'A) Anadolu’da en son Maçka’yı gezmiştir.',
        'B) Anadolu’nun dışında başka bir yer dolaşmamıştır.',
        'C) Gezdiği yerler içinde aklında sadece Maçka kalmıştır.',
        'D) Maçka’yı tekrar görmek istemektedir.'
      ],
      'dogrucevap': 'D) '
    },
    {//9
      'soru': "Vermez selâm o serv-i hırâmân gelir geçer Yollarda ömr-i âşık-ı nâlân gelir geçer Bu beyitte altı çizili sözle yapılan edebî sanat aşağıdakilerden hangisidir?",
      'cevap': [
        'A) İstiare',
        'B) Teshis',
        'C) Tevriye',
        'D) Intak'
      ],
      'dogrucevap': 'A) '
    },
    {//10
      'soru': "Doğup büyüdüğüm mahallede herkes birbirini tanırdı. Kimse aç uyumaz; kimsenin düğünü, cenazesi unutulmazdı. Pek az küslük olur, kalpler kolay kolay kırılmazdı. Bugüne kıyasla masal gibi bir yerdi mahallemiz. Şüphesiz, burası eserlerimdeki konuya ve karakterlere yön verdi.",
      'cevap': [
        'A) Nasıl bir çocukluk geçirdiniz?',
        'B) Çocukluğunuzun geçtiği yerler eserlerinizi nasıl etkiledi?',
        'C) Usta bir yazar, yaşadığı yeri eserlerinde ne ölçüde anlatmalıdır?',
        'D) Günümüzdeki toplumsal ilişkileri nasıl değerlendiriyorsunuz?'
      ],
      'dogrucevap': 'B) '
    },

  ];
}
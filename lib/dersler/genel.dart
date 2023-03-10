import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:lgs_jr_v2/analizler/genelanaliz.dart';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/analizler/analiz.dart';
import 'package:flutter/material.dart';

class GenelSorular extends StatefulWidget {
  @override
  _GenelSorularState createState() => _GenelSorularState();
}

/*final ref = FirebaseDatabase.instance.ref();
final snapshot = await ref.child('users/11@gmail.com').get();
if (snapshot.exists) {
print(snapshot.value);
} else {
print('No data available.');
}*/

/*DatabaseReference ref= FirebaseDatabase.instance.ref("Kullanicilar/11@gmail.com");
DatabaseReference child = ref.child("KullaniciAdi");
print(ref.key);*/

/*var refKullanicilar = FirebaseDatabase.instance.ref().child("Kullanicilar");
Future<void> veriOkumaOnce() async {

  refKullanicilar.once().then((value){
    var gelenDegerler = value.snapshot.value as dynamic;

    if(gelenDegerler != null){
      gelenDegerler.forEach((key,nesne){
  var gelenKisi = Kullanicilar.fromJson(nesne);
        print("****************************************");
        print("Kisi ad : ${gelenKisi.KullaniciAdi}" );
      }
      );
    }
  });
}*/

String zaman(int milisaniye) {
  var saniye = milisaniye ~/ 1000;
  var dakika = ((saniye % 3600) ~/ 60).toString().padLeft(2, '0');
  var saniyeler = (saniye % 60).toString().padLeft(2, '0');

  return "$dakika:$saniyeler";
}

class _GenelSorularState extends State<GenelSorular> {
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
    String ders = "Genel S??nav";
    data.add(kullaniciAdi);
    data.add(email);
    data.add(ders);
    data.add(net);
    data.add(zaman(_sayac.elapsedMilliseconds));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenelBitir(),
          settings: RouteSettings(
            arguments: data,
          ),
        ));
  }

  void cevapKontrol() {
    if (soru >= 39 && cevap.contains(sorular[soru]['dogrucevap'])) {
      net = net + 1;
      soru = 0;
      _timer.cancel();
      AnalizeGonder();
    } else if (soru >= 39 && !cevap.contains(sorular[soru]['dogrucevap'])) {
      net = net - 0.3;
      soru = 0;
      _timer.cancel();
      AnalizeGonder();
    } else {
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
    if (soru <= 39 && _sayac.elapsedMilliseconds == 3600000) {
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
        title: Text(
          "Genel S??nav",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
    child: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/images/x1.png"),
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
                          style: TextStyle(fontSize: 18.0,color: Colors.red.shade300),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          (soru + 1).toString() + '.Soru  ',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.red.shade300),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                            "S??re: " +
                                zaman(3600000 - _sayac.elapsedMilliseconds),
                            style: TextStyle(fontSize: 18.0,color: Colors.red.shade300)),
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
                              Colors.red[500]!,
                              Colors.red[100]!,
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
          "(I) Bizim memlekette da?? ta??, orman a??a?? hayat??n hik??yesini anlat??r. (II) Toprak burada ustan??n elinden ????km???? bir ??inidir, desen. (III) Toprak verimlidir; kuru ??ubuk diksen meyve verir, salk??m salk??m. (IV) Portakallar dallar??nda birer g??ne??tir, turuncu turuncu.Bu metinde numaralanm???? c??mlelerin hangilerinde ayn?? s??z sanat?? kullan??lm????t??r?",
      'cevap': ['A) I ve III', 'B) I ve IV', 'C) II ve III', 'D) II ve IV'],
      'dogrucevap': 'B) '
    },
    {
      'soru': "Bir sanat????ya, gazetecilerle yapt?????? sohbet s??ras??nda gazetecinin biri ???Efendim, uzuns??redir yeni bir eser vermiyorsunuz. Yoksad??????ncelerinizin ??zerine kar m?? ya??d?????? diyesordu. Bunun ??zerine sanat???? ???K??????n ya??ankar, topra???? ??rterek bitkileri ??iddetli so??uktankorur. Topra????n alt??ndaki bitki ve hayvanlarilkbahara haz??rlan??r. Karlar eridi??inde t??mcanl??l??klar??yla hayatlar??na devam eder. Evet,benim d??????ncelerimin ??zerine kar ya??d??.?????eklinde cevap verdi." +
          "Bu metinde sanat????n??n ???Evet, benim d??????ncelerimin ??zerine kar ya??d??.??? s??z??yle anlatmak istedi??i a??a????dakilerden hangisidir?",
      'cevap': [
        'A) Sanat????lar ??rettik??e var olur, bu y??zden her zaman ortaya koyacaklar?? bir eserleri olmal??d??r.',
        'B) Eser ??retmekte zorlanan sanat????lar, sanat g????lerini gittik??e kaybederler.',
        'C) Sanat????lar verimsiz bir d??nemde gibi g??r??nseler de yeni eserleri i??in zihinlerinde haz??rl??k yaparlar.',
        'D) D??????nce k??s??rl?????? ??eken sanat????lar, d??????ncelerini zenginle??tirmek i??in ??ok iyi g??zlem yapmal??d??r'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "(I) ??ay??n hik??yesi yakla????k be??bin y??l evvel ??in???de ba??lad??. (II) Efsaneye g??re ??mparator Shen Nung bir ????le istirahatindeyken hizmetk??rlar??, i??mesi i??in ona bir kapta su kaynat??yorlard??. (III) Bu s??rada tatl?? bir r??zg??r, s??cak suya birka?? ??ay yapra???? d??????rd??. (IV) ??mparator, bu suyu i??ince ??yle be??endi ki ??ay bir i??ecek olarak ke??fedilmi?? oldu.",
      'cevap': ['A) I', 'B) II', 'C) III', 'D) IV'],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Birden ??ok y??klemli c??mlelerde ??znenin b??t??n y??klemlerle uyumlu olmas?? gerekir. Aksi takdirde ??zne eksikli??inden kaynaklanan anlat??m bozuklu??u meydana gelir. A??a????dakilerin hangisinde bu a????klamay?? ??rnekleyen bir anlat??m bozuklu??u vard??r?",
      'cevap': [
        'A) Tarlaya tohumlar ekimde at??lacak, ??r??n haziranda toplanacak.',
        'B) Bu hastal??????n tedavisi bulunmal??, insanl????a tehdit olmaktan ????kar??lmal??.',
        'C) Yazar??n her kitab??n?? okuyorum ve takdir ediyorum.',
        'D) Her ak??am bizimle ilgilenir, yemek getirirdi.'
      ],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "A??a????daki c??mlelerin hangisinde ???tecr??be???yi anlatan bir s??z kullan??lmam????t??r?",
      'cevap': [
        'A) Bizim tak??m??n teknik direkt??r?? eski kurttur, ma??larda tak??ma iyi taktik veriyor.',
        'B) S??tten a??z?? yand??, yo??urdu ??fleyerek yiyor; art??k arkada?? se??iminde daha dikkatli.',
        'C) Ben insan sarraf?? oldum, beni kolay kolay kand??ramazlar',
        'D) ??nce eleyip s??k dokudu??undan i??lerinde ba??ar??l?? oluyor.'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "??n yarg??, ki??inin bir kimse veya bir ??eyle ilgili pe??inen varsayd?????? olumlu veya olumsuz tutumlar??n t??m??d??r. Buna g??re a??a????dakilerin hangisinde ??n yarg??l?? bir tutumdan s??z edilemez?",
      'cevap': [
        'A) Emanete h??yanet olmaz.',
        'B) Ki??i arkada????ndan bellidir',
        'C) ??nsan yedisinde ne ise yetmi??inde de odur.',
        'D) ??ok havlayan k??pek ??s??rmaz.'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "A??a????daki hangi Anadolu tak??m?? T??rkiye S??per Liginde ??ampiyon olmu??tur?",
      'cevap': [
        'A) Kocaelispor',
        'B) Bursaspor',
        'C) Eski??ehirspor',
        'D) H??rrem Sultan'
      ],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "Anadolu???yu k??y k??y dola??m???? bir gezgin olarak Ma??ka???y?? her zaman ??zlerim. Bu c??mleyi dile getiren ki??i i??in a??a????dakilerden hangisi kesin olarak s??ylenir?",
      'cevap': [
        'A) Anadolu???da en son Ma??ka???y?? gezmi??tir.',
        'B) Anadolu???nun d??????nda ba??ka bir yer dola??mam????t??r.',
        'C) Gezdi??i yerler i??inde akl??nda sadece Ma??ka kalm????t??r.',
        'D) Ma??ka???y?? tekrar g??rmek istemektedir.'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "Vermez sel??m o serv-i h??r??m??n gelir ge??er Yollarda ??mr-i ??????k-?? n??l??n gelir ge??er Bu beyitte alt?? ??izili s??zle yap??lan edeb?? sanat a??a????dakilerden hangisidir?",
      'cevap': ['A) ??stiare', 'B) Teshis', 'C) Tevriye', 'D) Intak'],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Do??up b??y??d??????m mahallede herkes birbirini tan??rd??. Kimse a?? uyumaz; kimsenin d??????n??, cenazesi unutulmazd??. Pek az k??sl??k olur, kalpler kolay kolay k??r??lmazd??. Bug??ne k??yasla masal gibi bir yerdi mahallemiz. ????phesiz, buras?? eserlerimdeki konuya ve karakterlere y??n verdi.",
      'cevap': [
        'A) Nas??l bir ??ocukluk ge??irdiniz?',
        'B) ??ocuklu??unuzun ge??ti??i yerler eserlerinizi nas??l etkiledi?',
        'C) Usta bir yazar, ya??ad?????? yeri eserlerinde ne ??l????de anlatmal??d??r?',
        'D) G??n??m??zdeki toplumsal ili??kileri nas??l de??erlendiriyorsunuz?'
      ],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "Asit s??z??nt??s?? meydana gelen bir b??lgede yerler kumla kapat??l??r ve havan??n tamamen temizlenmesi i??in ??al????ma ba??lat??l??r.Bunlara ilave olarak asitin g??zlere ve solunum yollar??na zarar verici ??zelli??inden dolay?? ??evresi de bo??alt??l??r.Verilen bilgilere g??re a??a????dakilerden hangisi s??ylenemez?",
      'cevap': [
        'A) S??z??nt??n??n meydana geldi??i b??lgede toprak yap??s?? zarar g??rebilir.',
        'B) S??z??nt??dan sonra asit ya??muruna y??nelik ??nlem al??nm????t??r.',
        'C)  Asitin g??ze zarar vermesi buharla??t??????n?? g??sterir.',
        'D) Kullan??lan kumun pH derecesi 0-7 aras??ndad??r.'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Aziz Sancar ve arkada??lar??, bir ??al????mada ila??lar??n yan etkilerinden olan DNA hasar??n?? azaltmak i??in ilac??n hangi zaman diliminde kullan??lmas?? gerekti??ini ara??t??rm????lard??r. Bu ama??la farelerde ilac??n olu??turdu??u hasar??n onar??lmas??na y??nelik bir ara??t??rma yapm????lard??r. Ara??t??rma sonucunda canl??lar??n bedenlerinde ger??ekle??en olaylara ayr??lan s??re olan biyolojik" +
              "Bu deneydeki ba????ms??z de??i??ken a??a????dakilerden hangisidir?",
      'cevap': [
        'A) ??la??',
        'B) Fare',
        'C) Biyolojik saat',
        'D) DNA???daki hasar miktar??'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "I.	 Da??da yeti??en karahindiba bitkisi ile evinin bah??esinde yeti??en karahindiba bitkisindeki b??y??meye neden olan genlerin i??leyi??i farkl?? olabilir. II.	 Da??da yeti??en karahindiba bitkisinin tohumu, evinin bah??esine ekildikten sonra genlerinde yap??sal de??i??iklik meydana gelmi??tir. III.	Karahindiba bitkisinin de??i??ik ortamlardaki boylar??n??n farkl?? olmas?? modifikasyona ??rnek olarak verilir. ????kar??mlar??ndan hangileri do??rudur?",
      'cevap': ['A) I ve II', 'B) I ve III', 'C) I, II ve III', 'D) II ve III'],
      'dogrucevap': 'D) '
    },
    {
      'soru': "Ph ??l????mleri hangi  ama??la kullan??l??r?",
      'cevap': [
        'A) Asit Baz ??l????m??',
        'B) S??cakl??k ??l????m??',
        'C) Y??kseklik ??l????m??',
        'D) Mesafe ??l????m??'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Ge??ti??imiz g??nlerde d??nyada ya??anan iki b??y??k f??rt??nadan biri ABD???de etkili olan Florance Kas??rgas?? di??eri ise Filipinler, ??in ve Hongkong???u etkisi alt??na alan Mangkhut Tayfunu???dur. Bu gibi f??rt??nalar??n daha s??k ve ??iddetli ya??anmas??na k??resel ??s??nman??n etkisi ile atmosfer ve deniz s??cakl??klar??ndaki art??????n neden oldu??u d??????n??lmektedir",
      'cevap': [
        'A) Kas??rga ve tayfunlar??n s??rekli olarak ayn?? yerlerde meydana gelmesi',
        'B) Su d??ng??s??n??n ger??ekle??mesinde hava s??cakl??????n??n etkili olmas??',
        'C) Deniz y??zeyi s??cakl??klar?? azald??????nda f??rt??nalar??n ??iddetinin de azalmas??',
        'D) K??resel ??s??nmaya ba??l?? olarak mevsim s??relerinin de??i??mesi'
      ],
      'dogrucevap': 'C) '
    },
    {
      'soru':
          "D??nya???m??za en yak??n y??ld??z olup ????plak g??zle g??r??lebilir.Y??zey s??cakl?????? yakla????k olarak 6000??C???tur.B??y??kl?????? D??nya???m??z??n b??y??kl??????n??n yakla????k olarak 110 kat??d??r. Verilen bilgiler, a??a????daki g??k cisimlerinden hangisine aittir?",
      'cevap': ['A) Ven??s', 'B) G??ne??', 'C) Ay', 'D) Mars'],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "Gezegenler hangi g??k cisminin etraf??nda dolanma hareketi yaparlar?",
      'cevap': ['A) Y??ld??z', 'B) D??nya', 'C) Asteroit', 'D) Uydu'],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "G??ne?? sistemindeki gezegenlerden biri, kendi ekseni etraf??nda yatay olarak d??ner. Gezegenler, G??ne?????e yak??nl??k derecelerine g??re s??raland??????nda bu gezegen ka????nc?? s??rada yer al??r?",
      'cevap': ['A) 1.', 'B) 2.', 'C) 3.', 'D) 4.'],
      'dogrucevap': 'C) '
    },
    {
      'soru':
          " K??????k g??k cisimleri olarak da bilinen asteroitler, G??ne?????in ??evresinde dolan??rlar. Ancak asteroitlerin iki gezegenin y??r??ngeleri aras??nda yo??un olarak bulunduklar?? bir b??lge vard??r ki buraya ???Asteroit Ku??a??????? denir. Buna g??re bu gezegen ??ifti a??a????dakilerin hangisinde verilmi??tir?",
      'cevap': [
        'A) Mars - J??piter',
        'B) J??piter - Sat??rn',
        'C) Merk??r - Ven??s',
        'D) Uran??s - Nept??n'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "G??ne?? sisteminde bulunan gezegenler ile ilgili a??a????da verilen bilgilerden hangisi yanl????t??r?",
      'cevap': [
        'A) B??y??kl??kleri ve G??ne?????e olan uzakl??klar?? farkl??d??r.',
        'B) G??ne?? etraf??nda bulunan y??r??ngelerinde, hepsi ayn?? y??nde dolan??r.',
        'C) Baz??lar?? i?? gezegen, baz??lar?? da d???? gezegen olarak grupland??r??l??r.',
        'D) Hepsinin kendi ekseni etraf??nda d??n?????? saatin d??nme y??n??ne terstir.'
      ],
      'dogrucevap': 'A) '
    },
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
      'soru': "(2*2)*8/2*2?",
      'cevap': ['A) 4', 'B) 8', 'C) 16', 'D) 32'],
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

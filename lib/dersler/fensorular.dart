import 'dart:async';
import 'package:lgs_jr_v2/anasayfa.dart';
import 'package:lgs_jr_v2/analizler/analiz.dart';
import 'package:flutter/material.dart';
//import 'package:page_transition/page_transition.dart';

class FenSorular extends StatefulWidget {
  @override
  _FenSorularState createState() => _FenSorularState();
}

String zaman(int milisaniye) {
  var saniye = milisaniye ~/ 1000;
  var dakika = ((saniye % 3600) ~/ 60).toString().padLeft(2, '0');
  var saniyeler = (saniye % 60).toString().padLeft(2, '0');

  return "$dakika:$saniyeler";
}

class _FenSorularState extends State<FenSorular> {
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
    _timer = new Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void analizeGonder() {
    NetYuvarla(net);
    var data = [];
    String ders = "Fen Bilimleri";
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
    if (soru >= 19 &&cevap.contains(sorular[soru]['dogrucevap'])) {
      net = net+1;
      soru = 0;
      _timer.cancel();
      analizeGonder();
    }
    else if(soru >= 19 &&!cevap.contains(sorular[soru]['dogrucevap'])){
      net = net - 0.3;
      soru = 0;
      _timer.cancel();
      analizeGonder();
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
    if (soru <= 19 && _sayac.elapsedMilliseconds == 1800000) {
      Future.delayed(Duration.zero, () async {
        _timer.cancel();
        soru = 0;
        analizeGonder();
      });
    }

    List cevapdeposu = [];
    for (var u in sorular[soru]['cevap']) {
      cevapdeposu.add(u);
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      appBar: AppBar(
        backgroundColor: Colors.red.shade400,
        title: Text(
          "Fen Bilimleri Testi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/x4.jpg"),
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
                          style: TextStyle(fontSize: 18.0,color: Colors.orange),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          (soru + 1).toString() + '.Soru  ',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                            "S??re: " +
                                zaman(1800000 - _sayac.elapsedMilliseconds),
                            style: TextStyle(fontSize: 18.0,color: Colors.orange)),
                      ),
                    ),

                    SizedBox(
                      width: 10,
                    ),

                  ],
                ),
              ),
              /*Row(
                children: [

                  Text(
                    (soru + 1).toString() + '.Soru  ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "S??re: " +
                          zaman(1800000 - _sayac.elapsedMilliseconds),
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Netiniz: ' + net.toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),*/

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
                              Colors.red,
                              Colors.red,
                              Colors.purple,
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
    );
  }

  List sorular = [
    {//1
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
    {//2
      'soru': "Aziz Sancar ve arkada??lar??, bir ??al????mada ila??lar??n yan etkilerinden olan DNA hasar??n?? azaltmak i??in ilac??n hangi zaman diliminde kullan??lmas?? gerekti??ini ara??t??rm????lard??r. Bu ama??la farelerde ilac??n olu??turdu??u hasar??n onar??lmas??na y??nelik bir ara??t??rma yapm????lard??r. Ara??t??rma sonucunda canl??lar??n bedenlerinde ger??ekle??en olaylara ayr??lan s??re olan biyolojik" +
          "Bu deneydeki ba????ms??z de??i??ken a??a????dakilerden hangisidir?",
      'cevap': ['A) ??la??', 'B) Fare', 'C) Biyolojik saat', 'D) DNA???daki hasar miktar??'],
      'dogrucevap': 'A) '
    },
    {//3
      'soru':
      "I.	 Da??da yeti??en karahindiba bitkisi ile evinin bah??esinde yeti??en karahindiba bitkisindeki b??y??meye neden olan genlerin i??leyi??i farkl?? olabilir. II.	 Da??da yeti??en karahindiba bitkisinin tohumu, evinin bah??esine ekildikten sonra genlerinde yap??sal de??i??iklik meydana gelmi??tir. III.	Karahindiba bitkisinin de??i??ik ortamlardaki boylar??n??n farkl?? olmas?? modifikasyona ??rnek olarak verilir. ????kar??mlar??ndan hangileri do??rudur?",
      'cevap': ['A) I ve II', 'B) I ve III', 'C) I, II ve III', 'D) II ve III'],
      'dogrucevap': 'D) '
    },
    {//4
      'soru': "Ph ??l????mleri hangi  ama??la kullan??l??r?",
      'cevap': [
        'A) Asit Baz ??l????m??',
        'B) S??cakl??k ??l????m??',
        'C) Y??kseklik ??l????m??',
        'D) Mesafe ??l????m??'
      ],
      'dogrucevap': 'A) '
    },
    {//5
      'soru':
      "Ge??ti??imiz g??nlerde d??nyada ya??anan iki b??y??k f??rt??nadan biri ABD???de etkili olan Florance Kas??rgas?? di??eri ise Filipinler, ??in ve Hongkong???u etkisi alt??na alan Mangkhut Tayfunu???dur. Bu gibi f??rt??nalar??n daha s??k ve ??iddetli ya??anmas??na k??resel ??s??nman??n etkisi ile atmosfer ve deniz s??cakl??klar??ndaki art??????n neden oldu??u d??????n??lmektedir",
      'cevap': [
        'A) Kas??rga ve tayfunlar??n s??rekli olarak ayn?? yerlerde meydana gelmesi',
        'B) Su d??ng??s??n??n ger??ekle??mesinde hava s??cakl??????n??n etkili olmas??',
        'C) Deniz y??zeyi s??cakl??klar?? azald??????nda f??rt??nalar??n ??iddetinin de azalmas??',
        'D) K??resel ??s??nmaya ba??l?? olarak mevsim s??relerinin de??i??mesi'
      ],
      'dogrucevap':
      'C) '
    },
    {//6
      'soru':
      "D??nya???m??za en yak??n y??ld??z olup ????plak g??zle g??r??lebilir.Y??zey s??cakl?????? yakla????k olarak 6000??C???tur.B??y??kl?????? D??nya???m??z??n b??y??kl??????n??n yakla????k olarak 110 kat??d??r. Verilen bilgiler, a??a????daki g??k cisimlerinden hangisine aittir?",
      'cevap': ['A) Ven??s', 'B) G??ne??', 'C) Ay', 'D) Mars'],
      'dogrucevap': 'B) '
    },
    {//7
      'soru':
      "Gezegenler hangi g??k cisminin etraf??nda dolanma hareketi yaparlar?",
      'cevap': ['A) Y??ld??z', 'B) D??nya', 'C) Asteroit', 'D) Uydu'],
      'dogrucevap': 'D) '
    },
    {//8
      'soru':
      "G??ne?? sistemindeki gezegenlerden biri, kendi ekseni etraf??nda yatay olarak d??ner. Gezegenler, G??ne?????e yak??nl??k derecelerine g??re s??raland??????nda bu gezegen ka????nc?? s??rada yer al??r?",
      'cevap': ['A) 1.', 'B) 2.', 'C) 3.', 'D) 4.'],
      'dogrucevap': 'C) '
    },
    {//9
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
    {//10
      'soru':
      "G??ne?? sisteminde bulunan gezegenler ile ilgili a??a????da verilen bilgilerden hangisi yanl????t??r?",
      'cevap': [
        'A) B??y??kl??kleri ve G??ne?????e olan uzakl??klar?? farkl??d??r',
        'B) G??ne?? etraf??nda bulunan y??r??ngelerinde, hepsi ayn?? y??nde dolan??r.',
        'C) Baz??lar?? i?? gezegen, baz??lar?? da d???? gezegen olarak grupland??r??l??r.',
        'D) Hepsinin kendi ekseni etraf??nda d??n?????? saatin d??nme y??n??ne terstir'
      ],
      'dogrucevap': 'A) '
    },
    {//11
      'soru':
      "Ay??e, odada ??almakta olan radyonun sesini a??t??????nda odan??n tavan??nda as??l?? olan balonun titre??meye ba??lad??????n?? fark ediyor Ay??e bu olay?? \nI. Ses dalgalar?? enerji ta????r.\nII. Sesin s??rati yay??ld?????? ortama g??re de??i??ir. \nIII. Ses enerjisi ba??ka bir enerji t??r??ne d??n????ebilir. \nyarg??lar??ndan hangileri ile a????klar?",
      'cevap': [
        'A) I ve II.',
        'B) I ve III.',
        'C) II ve III.',
        'D) I, II ve III.'
      ],
      'dogrucevap': 'B) '
    },
    {//12
      'soru':
      "Tatl?? su kaynaklar?? D??nya???daki su kaynaklar??n??n yakla????k %3????? kadard??r. Baz?? ara??t??rmac??lar bu kaynaklar??n bilin??siz kullan??m??n??n devam etmesi h??linde yak??n bir gelecekte D??nya ??zerinde su k??tl?????? ya??anaca????n?? ??ng??rmektedirler. \n   Buna g??re a??a????dakilerden hangisi ara??t??rmac??lar??n ??ne s??rd?????? bu sorunu ??nlemeye y??nelik uygulamalardan biri olamaz?",
      'cevap': [
        'A) Ya??mur sular??n??n depolanarak bah??e sulamas??nda kullan??lmas??na y??nelik sistem tasarlanmas??',
        'B) Tarlalar??n zaman??ndan ??nce ve fazla su lanmas??n?? engellemek i??in topra????n nemini ??l??en bir ara?? geli??tirilmesi',
        'C) Barajlarda toplanan suyun da????t??m sistemi ne g??nderilmeden ??nce ar??tma sistemine al??nmas??',
        'D) Lavabo giderlerinden akan suyun toplanarak ar??t??lmas?? ve bah??elerde kullan??labilecek h??le getirilmesi'
      ],
      'dogrucevap': 'C) '
    },
    {//13
      'soru':
      "Bir ara??t??rmada bezelye bitkisinin g??vde uzunlu??unun kal??t??m?? incelenmi??tir. \nBu ara??t??rmada; \n??? ??nce iki uzun boylu bezelye ??aprazlanarak birinci ku??ak elde edilmi??tir. \n??? Daha sonra birinci ku??aktan al??nan iki uzun boylu bezelye ??aprazlanm????t??r. \n??? Bu ??aprazlama sonucunda ikinci ku??akta uzun boylu bezelyelerin yan?? s??ra k??sa boylu bezelyelerin de ortaya ????kt?????? g??r??lm????t??r. Verilen bilgilere g??re a??a????daki yorumlardan hangisi yap??labilir?",
      'cevap': [
        'A) Birinci ku??aktaki bezelyelerin tamam?? saf d??ld??r.',
        'B) ??kinci ??aprazlama i??in se??ilen bezelyelerin genotipi heterozigottur.',
        'C) ??kinci ??aprazlama sonucu olu??an bezelyelerin genotiplerinin heterozigot olma ihtimali yoktur.',
        'D) ??kinci ku??akta k??sa boylu bezelyelerin ortaya ????kmas??n??n tek nedeni mutasyon ge??irmi?? olmalar??d??r.'
      ],
      'dogrucevap': 'B) '
    },
    {//14
      'soru':
      "Deney Yapan Ali ilk denemede negatif (-) y??kle y??kledi??i e??yan??n metal y??zeyine n??tr boya tanecikleri p??sk??rtt??????nde boyan??n d??zg??n da????lmad??????n?? g??r??yor.Bu sorunu ????zmek i??in Ali ikinci denemede, denemedekiyle ??zde?? olan metal bir y??zeyi yine negatif (-) y??kleyerek metalin ??zeyine bu kez pozitif (+) boya taneciklerini p??sk??rtt??????nde boyan??n y??zeye d??zg??n da????ld??????n?? g??r??yor.\nBuna g??re ikinci denemede e??yan??n metal y??zeyine boyan??n d??zg??n da????lmas??n??n sebebi a??a????dakilerden hangisidir?",
      'cevap': [
        'A) N??tr cisimlerin y??kl?? cisimler taraf??ndan ??ekilmesi',
        'B) Z??t y??kl?? cisimlerin birbirini ??ekmesi',
        'C) Ayn?? y??kl?? cisimlerin birbirini itmesi',
        'D) N??tr bir cismin ba??ka bir n??tr cisim taraf??ndan etkilenmemesi'
      ],
      'dogrucevap': 'C) '
    },
    {//15
      'soru':
      "N??tr bir elektroskobun topuzuna bir cisim dokunduran Mustafa, elektroskobun yapraklar??n??n a????ld??????n?? g??zlemliyor. Bu g??zlemine dayal?? olarak Mustafa, dokundurdu??u cismin pozitif (+) y??kl?? oldu??unu iddia ediyor. Zeynep ise cismin y??k cinsinin belirlenmesi i??in Mustafa???n??n g??zleminin yetersiz oldu??unu ??ne s??r??yor. \nBuna g??re Zeynep a??a????dakilerden hangisini yaparsa kendi d??????ncesini destekler?",
      'cevap': [
        'A) Negatif (-) y??kl?? oldu??u bilinen bir cismi n??tr bir elektroskobun topuzuna dokundurursa',
        'B) Pozitif (+) y??kl?? oldu??u bilinen bir cismi n??tr bir elektroskobun topuzuna dokundurursa',
        'C) N??tr bir cismi, n??tr bir elektroskobun topuzuna dokundurursa',
        'D) Yapraklar?? a????k bir elektroskobu topuzundan topraklarsa'
      ],
      'dogrucevap': 'A) '
    },
    {//16
      'soru':
        "Bir ????renci, saf bir maddenin s??cakl??k de??i??iminin k??tleye ba??l?? oldu??unu g??zlemlemek i??in iki ayr?? d??zenek olu??turup bu d??zenekleri belirli bir s??re ??s??t??yor. \nA??a????dakilerden hangisi ????rencinin haz??rlayaca???? deney d??zeneklerinde sabit tuttu??u (kontroll??) de??i??kenlerden biri olamaz?",
      'cevap': [
        'A) Kullan??lan maddelerin miktar??',
        'B) D??zeneklerde yer alan ??s??t??c??lar??n say??s??',
        'C) Kullan??lan maddelerin cinsi',
        'D) D??zenekleri ??s??tma s??resi'
      ],
      'dogrucevap': 'A) '
    },
    {//17
      'soru':
        "T??rkiye???de bir b??lgede 21 Temmuz 2015 tarihindeki sa??anak ya??mur; sel ve su ta??k??nlar??na yol a??m????t??r. Uzmanlar bu ya????????n sel ve su ta??k??nlar??na yol a??abilece??i konusunda insanlar?? daha ??nceden uyarm????t??r. Bu b??lgede yaz aylar??n??n genellikle ya??????s??z ve s??cak olmas??na ra??men ya??anan bu durum ile ilgili a??a????daki yorumlardan hangisi do??rudur?",
      'cevap': [
        'A) Sel olmas?? b??lgenin ikliminin de??i??ti??ini g??sterir.',
        'B) Bu tarihte ya??mur ya??mas?? b??lgenin iklim ??zelliklerinin bir sonucudur.',
        'C) Bu tarihte ya??mur ya??mas?? bir hava olay??d??r.',
        'D) Bu tahmin sadece iklim bilimci taraf??ndan yap??labilir.'
      ],
      'dogrucevap': 'C) '
    },
    {//18
      'soru':
        "Bezelyelerde sar?? tohum ??zelli??i bask??n, ye??il tohum ??zelli??i ??ekiniktir. Mendel kural??na uygun olarak yap??lan bir ??aprazlamada, tohum rengi bilinmeyen iki bezelyenin ??aprazlanmas??ndan birinci ku??akta (F1) 3:1 fenotip oran?? elde edilmi??tir. Bu oran, bu ??aprazlamada olu??an ??ok say??daki bezelyenin d??rtte ??????n??n sar??, d??rtte birinin de ye??il tohum ??retti??i anlam??na gelmektedir. \nBu ??aprazlamada 3:1 fenotip oran??n??n elde edilmesi i??in a??a????dakilerden hangisi ger??ekle??tirilmi??tir?",
      'cevap': [
        'A) Homozigot sar?? tohumlu iki bezelye ??aprazlanm????t??r.',
        'B) Heterozigot sar?? tohumlu iki bezelye ??aprazlanm????t??r.',
        'C) Heterozigot sar?? tohumlu bezelye ile homozigot sar?? tohumlu bezelye ??aprazlanm????t??r.',
        'D) Homozigot ye??il tohumlu iki bezelye ??aprazlanm????t??r.'
      ],
      'dogrucevap': 'B) '
    },
    {//19
      'soru':
        "Bilim insanlar??, ??nemli tar??m bitkilerinin verimini art??rmak i??in g??n??m??zde geleneksel y??ntemler yerine DNA teknolojilerini kullanmaktad??r. M??s??r bu y??ntemlerin kullan??ld?????? bitkilerden biridir. \nUygulama: M??s??r bitkilerine bakterilerden aktar??lan bir genle bir m??s??r kurdunun m??s??rlara zarar vermesi engellenerek m??s??r??n verimi art??r??labilmektedir. \nSadece bu uygulamayla ilgili a??a????daki yarg??lardan hangisi do??rudur?",
      'cevap': [
        'A) Bu uygulamayla m??s??r kurdunun genetik yap??s?? de??i??tirilmi??tir.',
        'B) Bu uygulamayla m??s??r bitkisine kazand??r??lan ??zellik, sonraki nesillerine de aktar??labilir.',
        'C) Bu uygulama, m??s??r bitkilerinin t??m zararl?? canl??lara kar???? korunmas??n?? sa??lar.',
        'D) Bu uygulama, m??s??r kurdunda yapay se??ilimi sa??lamak i??in yap??lm????t??r.'
      ],
      'dogrucevap': 'B) '
    },
    {//20
      'soru':
        "Yerk??renin do??al dengesini korumak amac??yla 2002 y??l??nda yap??lan bir d??nya zirvesinde kabul edilen ilkelerden biri ???Tehlikeyi ??nleme ??lkesi???dir. Bu ilkeyle, do??al dengeyi korumak i??in s??z konusu sorun ortaya ????kmadan ??nlem al??nmas?? ama??lanm????t??r. Buna g??re a??a????da verilenlerden hangisi ???Tehlikeyi ??nleme ??lkesi??? kapsam??nda yap??lan bir uygulama de??ildir?",
      'cevap': [
        'A) Akarsulara evsel at??klar??n kar????mas??n??n ??nlenmesi',
        'B) Atmosfere karbondioksit veren enerji kaynaklar??n??n kullan??m??n??n art??r??lmas??',
        'C) Plastik ve cam gibi malzemelerin geri d??n??????m??n??n sa??lanmas??',
        'D) Orman varl??????n??n korunmas?? i??in k??????t kullan??m??n??n azalt??lmas??'
      ],
      'dogrucevap': 'B) '
    },

  ];
}

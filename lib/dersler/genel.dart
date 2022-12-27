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
    String ders = "Genel Sınav";
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
          "Genel Sınav",
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
                            "Süre: " +
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
          "(I) Bizim memlekette dağ taş, orman ağaç hayatın hikâyesini anlatır. (II) Toprak burada ustanın elinden çıkmış bir çinidir, desen. (III) Toprak verimlidir; kuru çubuk diksen meyve verir, salkım salkım. (IV) Portakallar dallarında birer güneştir, turuncu turuncu.Bu metinde numaralanmış cümlelerin hangilerinde aynı söz sanatı kullanılmıştır?",
      'cevap': ['A) I ve III', 'B) I ve IV', 'C) II ve III', 'D) II ve IV'],
      'dogrucevap': 'B) '
    },
    {
      'soru': "Bir sanatçıya, gazetecilerle yaptığı sohbet sırasında gazetecinin biri “Efendim, uzunsüredir yeni bir eser vermiyorsunuz. Yoksadüşüncelerinizin üzerine kar mı yağdı?” diyesordu. Bunun üzerine sanatçı “Kışın yağankar, toprağı örterek bitkileri şiddetli soğuktankorur. Toprağın altındaki bitki ve hayvanlarilkbahara hazırlanır. Karlar eridiğinde tümcanlılıklarıyla hayatlarına devam eder. Evet,benim düşüncelerimin üzerine kar yağdı.”şeklinde cevap verdi." +
          "Bu metinde sanatçının “Evet, benim düşüncelerimin üzerine kar yağdı.” sözüyle anlatmak istediği aşağıdakilerden hangisidir?",
      'cevap': [
        'A) Sanatçılar ürettikçe var olur, bu yüzden her zaman ortaya koyacakları bir eserleri olmalıdır.',
        'B) Eser üretmekte zorlanan sanatçılar, sanat güçlerini gittikçe kaybederler.',
        'C) Sanatçılar verimsiz bir dönemde gibi görünseler de yeni eserleri için zihinlerinde hazırlık yaparlar.',
        'D) Düşünce kısırlığı çeken sanatçılar, düşüncelerini zenginleştirmek için çok iyi gözlem yapmalıdır'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "(I) Çayın hikâyesi yaklaşık beşbin yıl evvel Çin’de başladı. (II) Efsaneye göre İmparator Shen Nung bir öğle istirahatindeyken hizmetkârları, içmesi için ona bir kapta su kaynatıyorlardı. (III) Bu sırada tatlı bir rüzgâr, sıcak suya birkaç çay yaprağı düşürdü. (IV) İmparator, bu suyu içince öyle beğendi ki çay bir içecek olarak keşfedilmiş oldu.",
      'cevap': ['A) I', 'B) II', 'C) III', 'D) IV'],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Birden çok yüklemli cümlelerde öznenin bütün yüklemlerle uyumlu olması gerekir. Aksi takdirde özne eksikliğinden kaynaklanan anlatım bozukluğu meydana gelir. Aşağıdakilerin hangisinde bu açıklamayı örnekleyen bir anlatım bozukluğu vardır?",
      'cevap': [
        'A) Tarlaya tohumlar ekimde atılacak, ürün haziranda toplanacak.',
        'B) Bu hastalığın tedavisi bulunmalı, insanlığa tehdit olmaktan çıkarılmalı.',
        'C) Yazarın her kitabını okuyorum ve takdir ediyorum.',
        'D) Her akşam bizimle ilgilenir, yemek getirirdi.'
      ],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "Aşağıdaki cümlelerin hangisinde “tecrübe”yi anlatan bir söz kullanılmamıştır?",
      'cevap': [
        'A) Bizim takımın teknik direktörü eski kurttur, maçlarda takıma iyi taktik veriyor.',
        'B) Sütten ağzı yandı, yoğurdu üfleyerek yiyor; artık arkadaş seçiminde daha dikkatli.',
        'C) Ben insan sarrafı oldum, beni kolay kolay kandıramazlar',
        'D) İnce eleyip sık dokuduğundan işlerinde başarılı oluyor.'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "Ön yargı, kişinin bir kimse veya bir şeyle ilgili peşinen varsaydığı olumlu veya olumsuz tutumların tümüdür. Buna göre aşağıdakilerin hangisinde ön yargılı bir tutumdan söz edilemez?",
      'cevap': [
        'A) Emanete hıyanet olmaz.',
        'B) Kişi arkadaşından bellidir',
        'C) İnsan yedisinde ne ise yetmişinde de odur.',
        'D) Çok havlayan köpek ısırmaz.'
      ],
      'dogrucevap': 'A) '
    },
    {
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
    {
      'soru':
          "Anadolu’yu köy köy dolaşmış bir gezgin olarak Maçka’yı her zaman özlerim. Bu cümleyi dile getiren kişi için aşağıdakilerden hangisi kesin olarak söylenir?",
      'cevap': [
        'A) Anadolu’da en son Maçka’yı gezmiştir.',
        'B) Anadolu’nun dışında başka bir yer dolaşmamıştır.',
        'C) Gezdiği yerler içinde aklında sadece Maçka kalmıştır.',
        'D) Maçka’yı tekrar görmek istemektedir.'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "Vermez selâm o serv-i hırâmân gelir geçer Yollarda ömr-i âşık-ı nâlân gelir geçer Bu beyitte altı çizili sözle yapılan edebî sanat aşağıdakilerden hangisidir?",
      'cevap': ['A) İstiare', 'B) Teshis', 'C) Tevriye', 'D) Intak'],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Doğup büyüdüğüm mahallede herkes birbirini tanırdı. Kimse aç uyumaz; kimsenin düğünü, cenazesi unutulmazdı. Pek az küslük olur, kalpler kolay kolay kırılmazdı. Bugüne kıyasla masal gibi bir yerdi mahallemiz. Şüphesiz, burası eserlerimdeki konuya ve karakterlere yön verdi.",
      'cevap': [
        'A) Nasıl bir çocukluk geçirdiniz?',
        'B) Çocukluğunuzun geçtiği yerler eserlerinizi nasıl etkiledi?',
        'C) Usta bir yazar, yaşadığı yeri eserlerinde ne ölçüde anlatmalıdır?',
        'D) Günümüzdeki toplumsal ilişkileri nasıl değerlendiriyorsunuz?'
      ],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "Asit sızıntısı meydana gelen bir bölgede yerler kumla kapatılır ve havanın tamamen temizlenmesi için çalışma başlatılır.Bunlara ilave olarak asitin gözlere ve solunum yollarına zarar verici özelliğinden dolayı çevresi de boşaltılır.Verilen bilgilere göre aşağıdakilerden hangisi söylenemez?",
      'cevap': [
        'A) Sızıntının meydana geldiği bölgede toprak yapısı zarar görebilir.',
        'B) Sızıntıdan sonra asit yağmuruna yönelik önlem alınmıştır.',
        'C)  Asitin göze zarar vermesi buharlaştığını gösterir.',
        'D) Kullanılan kumun pH derecesi 0-7 arasındadır.'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Aziz Sancar ve arkadaşları, bir çalışmada ilaçların yan etkilerinden olan DNA hasarını azaltmak için ilacın hangi zaman diliminde kullanılması gerektiğini araştırmışlardır. Bu amaçla farelerde ilacın oluşturduğu hasarın onarılmasına yönelik bir araştırma yapmışlardır. Araştırma sonucunda canlıların bedenlerinde gerçekleşen olaylara ayrılan süre olan biyolojik" +
              "Bu deneydeki bağımsız değişken aşağıdakilerden hangisidir?",
      'cevap': [
        'A) İlaç',
        'B) Fare',
        'C) Biyolojik saat',
        'D) DNA’daki hasar miktarı'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "I.	 Dağda yetişen karahindiba bitkisi ile evinin bahçesinde yetişen karahindiba bitkisindeki büyümeye neden olan genlerin işleyişi farklı olabilir. II.	 Dağda yetişen karahindiba bitkisinin tohumu, evinin bahçesine ekildikten sonra genlerinde yapısal değişiklik meydana gelmiştir. III.	Karahindiba bitkisinin değişik ortamlardaki boylarının farklı olması modifikasyona örnek olarak verilir. çıkarımlarından hangileri doğrudur?",
      'cevap': ['A) I ve II', 'B) I ve III', 'C) I, II ve III', 'D) II ve III'],
      'dogrucevap': 'D) '
    },
    {
      'soru': "Ph ölçümleri hangi  amaçla kullanılır?",
      'cevap': [
        'A) Asit Baz ölçümü',
        'B) Sıcaklık ölçümü',
        'C) Yükseklik ölçümü',
        'D) Mesafe ölçümü'
      ],
      'dogrucevap': 'A) '
    },
    {
      'soru':
          "Geçtiğimiz günlerde dünyada yaşanan iki büyük fırtınadan biri ABD’de etkili olan Florance Kasırgası diğeri ise Filipinler, Çin ve Hongkong’u etkisi altına alan Mangkhut Tayfunu’dur. Bu gibi fırtınaların daha sık ve şiddetli yaşanmasına küresel ısınmanın etkisi ile atmosfer ve deniz sıcaklıklarındaki artışın neden olduğu düşünülmektedir",
      'cevap': [
        'A) Kasırga ve tayfunların sürekli olarak aynı yerlerde meydana gelmesi',
        'B) Su döngüsünün gerçekleşmesinde hava sıcaklığının etkili olması',
        'C) Deniz yüzeyi sıcaklıkları azaldığında fırtınaların şiddetinin de azalması',
        'D) Küresel ısınmaya bağlı olarak mevsim sürelerinin değişmesi'
      ],
      'dogrucevap': 'C) '
    },
    {
      'soru':
          "Dünya’mıza en yakın yıldız olup çıplak gözle görülebilir.Yüzey sıcaklığı yaklaşık olarak 6000°C’tur.Büyüklüğü Dünya’mızın büyüklüğünün yaklaşık olarak 110 katıdır. Verilen bilgiler, aşağıdaki gök cisimlerinden hangisine aittir?",
      'cevap': ['A) Venüs', 'B) Güneş', 'C) Ay', 'D) Mars'],
      'dogrucevap': 'B) '
    },
    {
      'soru':
          "Gezegenler hangi gök cisminin etrafında dolanma hareketi yaparlar?",
      'cevap': ['A) Yıldız', 'B) Dünya', 'C) Asteroit', 'D) Uydu'],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "Güneş sistemindeki gezegenlerden biri, kendi ekseni etrafında yatay olarak döner. Gezegenler, Güneş’e yakınlık derecelerine göre sıralandığında bu gezegen kaçıncı sırada yer alır?",
      'cevap': ['A) 1.', 'B) 2.', 'C) 3.', 'D) 4.'],
      'dogrucevap': 'C) '
    },
    {
      'soru':
          " Küçük gök cisimleri olarak da bilinen asteroitler, Güneş’in çevresinde dolanırlar. Ancak asteroitlerin iki gezegenin yörüngeleri arasında yoğun olarak bulundukları bir bölge vardır ki buraya “Asteroit Kuşağı” denir. Buna göre bu gezegen çifti aşağıdakilerin hangisinde verilmiştir?",
      'cevap': [
        'A) Mars - Jüpiter',
        'B) Jüpiter - Satürn',
        'C) Merkür - Venüs',
        'D) Uranüs - Neptün'
      ],
      'dogrucevap': 'D) '
    },
    {
      'soru':
          "Güneş sisteminde bulunan gezegenler ile ilgili aşağıda verilen bilgilerden hangisi yanlıştır?",
      'cevap': [
        'A) Büyüklükleri ve Güneş’e olan uzaklıkları farklıdır.',
        'B) Güneş etrafında bulunan yörüngelerinde, hepsi aynı yönde dolanır.',
        'C) Bazıları iç gezegen, bazıları da dış gezegen olarak gruplandırılır.',
        'D) Hepsinin kendi ekseni etrafında dönüşü saatin dönme yönüne terstir.'
      ],
      'dogrucevap': 'A) '
    },
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
      'soru': "(2*2)*8/2*2?",
      'cevap': ['A) 4', 'B) 8', 'C) 16', 'D) 32'],
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

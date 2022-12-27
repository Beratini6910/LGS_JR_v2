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
                            "Süre: " +
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
                      "Süre: " +
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
                  child: Text('Anasayfaya Dön'),
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
      "Asit sızıntısı meydana gelen bir bölgede yerler kumla kapatılır ve havanın tamamen temizlenmesi için çalışma başlatılır.Bunlara ilave olarak asitin gözlere ve solunum yollarına zarar verici özelliğinden dolayı çevresi de boşaltılır.Verilen bilgilere göre aşağıdakilerden hangisi söylenemez?",
      'cevap': [
        'A) Sızıntının meydana geldiği bölgede toprak yapısı zarar görebilir.',
        'B) Sızıntıdan sonra asit yağmuruna yönelik önlem alınmıştır.',
        'C)  Asitin göze zarar vermesi buharlaştığını gösterir.',
        'D) Kullanılan kumun pH derecesi 0-7 arasındadır.'
      ],
      'dogrucevap': 'A) '
    },
    {//2
      'soru': "Aziz Sancar ve arkadaşları, bir çalışmada ilaçların yan etkilerinden olan DNA hasarını azaltmak için ilacın hangi zaman diliminde kullanılması gerektiğini araştırmışlardır. Bu amaçla farelerde ilacın oluşturduğu hasarın onarılmasına yönelik bir araştırma yapmışlardır. Araştırma sonucunda canlıların bedenlerinde gerçekleşen olaylara ayrılan süre olan biyolojik" +
          "Bu deneydeki bağımsız değişken aşağıdakilerden hangisidir?",
      'cevap': ['A) İlaç', 'B) Fare', 'C) Biyolojik saat', 'D) DNA’daki hasar miktarı'],
      'dogrucevap': 'A) '
    },
    {//3
      'soru':
      "I.	 Dağda yetişen karahindiba bitkisi ile evinin bahçesinde yetişen karahindiba bitkisindeki büyümeye neden olan genlerin işleyişi farklı olabilir. II.	 Dağda yetişen karahindiba bitkisinin tohumu, evinin bahçesine ekildikten sonra genlerinde yapısal değişiklik meydana gelmiştir. III.	Karahindiba bitkisinin değişik ortamlardaki boylarının farklı olması modifikasyona örnek olarak verilir. çıkarımlarından hangileri doğrudur?",
      'cevap': ['A) I ve II', 'B) I ve III', 'C) I, II ve III', 'D) II ve III'],
      'dogrucevap': 'D) '
    },
    {//4
      'soru': "Ph ölçümleri hangi  amaçla kullanılır?",
      'cevap': [
        'A) Asit Baz ölçümü',
        'B) Sıcaklık ölçümü',
        'C) Yükseklik ölçümü',
        'D) Mesafe ölçümü'
      ],
      'dogrucevap': 'A) '
    },
    {//5
      'soru':
      "Geçtiğimiz günlerde dünyada yaşanan iki büyük fırtınadan biri ABD’de etkili olan Florance Kasırgası diğeri ise Filipinler, Çin ve Hongkong’u etkisi altına alan Mangkhut Tayfunu’dur. Bu gibi fırtınaların daha sık ve şiddetli yaşanmasına küresel ısınmanın etkisi ile atmosfer ve deniz sıcaklıklarındaki artışın neden olduğu düşünülmektedir",
      'cevap': [
        'A) Kasırga ve tayfunların sürekli olarak aynı yerlerde meydana gelmesi',
        'B) Su döngüsünün gerçekleşmesinde hava sıcaklığının etkili olması',
        'C) Deniz yüzeyi sıcaklıkları azaldığında fırtınaların şiddetinin de azalması',
        'D) Küresel ısınmaya bağlı olarak mevsim sürelerinin değişmesi'
      ],
      'dogrucevap':
      'C) '
    },
    {//6
      'soru':
      "Dünya’mıza en yakın yıldız olup çıplak gözle görülebilir.Yüzey sıcaklığı yaklaşık olarak 6000°C’tur.Büyüklüğü Dünya’mızın büyüklüğünün yaklaşık olarak 110 katıdır. Verilen bilgiler, aşağıdaki gök cisimlerinden hangisine aittir?",
      'cevap': ['A) Venüs', 'B) Güneş', 'C) Ay', 'D) Mars'],
      'dogrucevap': 'B) '
    },
    {//7
      'soru':
      "Gezegenler hangi gök cisminin etrafında dolanma hareketi yaparlar?",
      'cevap': ['A) Yıldız', 'B) Dünya', 'C) Asteroit', 'D) Uydu'],
      'dogrucevap': 'D) '
    },
    {//8
      'soru':
      "Güneş sistemindeki gezegenlerden biri, kendi ekseni etrafında yatay olarak döner. Gezegenler, Güneş’e yakınlık derecelerine göre sıralandığında bu gezegen kaçıncı sırada yer alır?",
      'cevap': ['A) 1.', 'B) 2.', 'C) 3.', 'D) 4.'],
      'dogrucevap': 'C) '
    },
    {//9
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
    {//10
      'soru':
      "Güneş sisteminde bulunan gezegenler ile ilgili aşağıda verilen bilgilerden hangisi yanlıştır?",
      'cevap': [
        'A) Büyüklükleri ve Güneş’e olan uzaklıkları farklıdır',
        'B) Güneş etrafında bulunan yörüngelerinde, hepsi aynı yönde dolanır.',
        'C) Bazıları iç gezegen, bazıları da dış gezegen olarak gruplandırılır.',
        'D) Hepsinin kendi ekseni etrafında dönüşü saatin dönme yönüne terstir'
      ],
      'dogrucevap': 'A) '
    },
    {//11
      'soru':
      "Ayşe, odada çalmakta olan radyonun sesini açtığında odanın tavanında asılı olan balonun titreşmeye başladığını fark ediyor Ayşe bu olayı \nI. Ses dalgaları enerji taşır.\nII. Sesin sürati yayıldığı ortama göre değişir. \nIII. Ses enerjisi başka bir enerji türüne dönüşebilir. \nyargılarından hangileri ile açıklar?",
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
      "Tatlı su kaynakları Dünya’daki su kaynaklarının yaklaşık %3’ü kadardır. Bazı araştırmacılar bu kaynakların bilinçsiz kullanımının devam etmesi hâlinde yakın bir gelecekte Dünya üzerinde su kıtlığı yaşanacağını öngörmektedirler. \n   Buna göre aşağıdakilerden hangisi araştırmacıların öne sürdüğü bu sorunu önlemeye yönelik uygulamalardan biri olamaz?",
      'cevap': [
        'A) Yağmur sularının depolanarak bahçe sulamasında kullanılmasına yönelik sistem tasarlanması',
        'B) Tarlaların zamanından önce ve fazla su lanmasını engellemek için toprağın nemini ölçen bir araç geliştirilmesi',
        'C) Barajlarda toplanan suyun dağıtım sistemi ne gönderilmeden önce arıtma sistemine alınması',
        'D) Lavabo giderlerinden akan suyun toplanarak arıtılması ve bahçelerde kullanılabilecek hâle getirilmesi'
      ],
      'dogrucevap': 'C) '
    },
    {//13
      'soru':
      "Bir araştırmada bezelye bitkisinin gövde uzunluğunun kalıtımı incelenmiştir. \nBu araştırmada; \n• Önce iki uzun boylu bezelye çaprazlanarak birinci kuşak elde edilmiştir. \n• Daha sonra birinci kuşaktan alınan iki uzun boylu bezelye çaprazlanmıştır. \n• Bu çaprazlama sonucunda ikinci kuşakta uzun boylu bezelyelerin yanı sıra kısa boylu bezelyelerin de ortaya çıktığı görülmüştür. Verilen bilgilere göre aşağıdaki yorumlardan hangisi yapılabilir?",
      'cevap': [
        'A) Birinci kuşaktaki bezelyelerin tamamı saf döldür.',
        'B) İkinci çaprazlama için seçilen bezelyelerin genotipi heterozigottur.',
        'C) İkinci çaprazlama sonucu oluşan bezelyelerin genotiplerinin heterozigot olma ihtimali yoktur.',
        'D) İkinci kuşakta kısa boylu bezelyelerin ortaya çıkmasının tek nedeni mutasyon geçirmiş olmalarıdır.'
      ],
      'dogrucevap': 'B) '
    },
    {//14
      'soru':
      "Deney Yapan Ali ilk denemede negatif (-) yükle yüklediği eşyanın metal yüzeyine nötr boya tanecikleri püskürttüğünde boyanın düzgün dağılmadığını görüyor.Bu sorunu çözmek için Ali ikinci denemede, denemedekiyle özdeş olan metal bir yüzeyi yine negatif (-) yükleyerek metalin üzeyine bu kez pozitif (+) boya taneciklerini püskürttüğünde boyanın yüzeye düzgün dağıldığını görüyor.\nBuna göre ikinci denemede eşyanın metal yüzeyine boyanın düzgün dağılmasının sebebi aşağıdakilerden hangisidir?",
      'cevap': [
        'A) Nötr cisimlerin yüklü cisimler tarafından çekilmesi',
        'B) Zıt yüklü cisimlerin birbirini çekmesi',
        'C) Aynı yüklü cisimlerin birbirini itmesi',
        'D) Nötr bir cismin başka bir nötr cisim tarafından etkilenmemesi'
      ],
      'dogrucevap': 'C) '
    },
    {//15
      'soru':
      "Nötr bir elektroskobun topuzuna bir cisim dokunduran Mustafa, elektroskobun yapraklarının açıldığını gözlemliyor. Bu gözlemine dayalı olarak Mustafa, dokundurduğu cismin pozitif (+) yüklü olduğunu iddia ediyor. Zeynep ise cismin yük cinsinin belirlenmesi için Mustafa’nın gözleminin yetersiz olduğunu öne sürüyor. \nBuna göre Zeynep aşağıdakilerden hangisini yaparsa kendi düşüncesini destekler?",
      'cevap': [
        'A) Negatif (-) yüklü olduğu bilinen bir cismi nötr bir elektroskobun topuzuna dokundurursa',
        'B) Pozitif (+) yüklü olduğu bilinen bir cismi nötr bir elektroskobun topuzuna dokundurursa',
        'C) Nötr bir cismi, nötr bir elektroskobun topuzuna dokundurursa',
        'D) Yaprakları açık bir elektroskobu topuzundan topraklarsa'
      ],
      'dogrucevap': 'A) '
    },
    {//16
      'soru':
        "Bir öğrenci, saf bir maddenin sıcaklık değişiminin kütleye bağlı olduğunu gözlemlemek için iki ayrı düzenek oluşturup bu düzenekleri belirli bir süre ısıtıyor. \nAşağıdakilerden hangisi öğrencinin hazırlayacağı deney düzeneklerinde sabit tuttuğu (kontrollü) değişkenlerden biri olamaz?",
      'cevap': [
        'A) Kullanılan maddelerin miktarı',
        'B) Düzeneklerde yer alan ısıtıcıların sayısı',
        'C) Kullanılan maddelerin cinsi',
        'D) Düzenekleri ısıtma süresi'
      ],
      'dogrucevap': 'A) '
    },
    {//17
      'soru':
        "Türkiye’de bir bölgede 21 Temmuz 2015 tarihindeki sağanak yağmur; sel ve su taşkınlarına yol açmıştır. Uzmanlar bu yağışın sel ve su taşkınlarına yol açabileceği konusunda insanları daha önceden uyarmıştır. Bu bölgede yaz aylarının genellikle yağışsız ve sıcak olmasına rağmen yaşanan bu durum ile ilgili aşağıdaki yorumlardan hangisi doğrudur?",
      'cevap': [
        'A) Sel olması bölgenin ikliminin değiştiğini gösterir.',
        'B) Bu tarihte yağmur yağması bölgenin iklim özelliklerinin bir sonucudur.',
        'C) Bu tarihte yağmur yağması bir hava olayıdır.',
        'D) Bu tahmin sadece iklim bilimci tarafından yapılabilir.'
      ],
      'dogrucevap': 'C) '
    },
    {//18
      'soru':
        "Bezelyelerde sarı tohum özelliği baskın, yeşil tohum özelliği çekiniktir. Mendel kuralına uygun olarak yapılan bir çaprazlamada, tohum rengi bilinmeyen iki bezelyenin çaprazlanmasından birinci kuşakta (F1) 3:1 fenotip oranı elde edilmiştir. Bu oran, bu çaprazlamada oluşan çok sayıdaki bezelyenin dörtte üçünün sarı, dörtte birinin de yeşil tohum ürettiği anlamına gelmektedir. \nBu çaprazlamada 3:1 fenotip oranının elde edilmesi için aşağıdakilerden hangisi gerçekleştirilmiştir?",
      'cevap': [
        'A) Homozigot sarı tohumlu iki bezelye çaprazlanmıştır.',
        'B) Heterozigot sarı tohumlu iki bezelye çaprazlanmıştır.',
        'C) Heterozigot sarı tohumlu bezelye ile homozigot sarı tohumlu bezelye çaprazlanmıştır.',
        'D) Homozigot yeşil tohumlu iki bezelye çaprazlanmıştır.'
      ],
      'dogrucevap': 'B) '
    },
    {//19
      'soru':
        "Bilim insanları, önemli tarım bitkilerinin verimini artırmak için günümüzde geleneksel yöntemler yerine DNA teknolojilerini kullanmaktadır. Mısır bu yöntemlerin kullanıldığı bitkilerden biridir. \nUygulama: Mısır bitkilerine bakterilerden aktarılan bir genle bir mısır kurdunun mısırlara zarar vermesi engellenerek mısırın verimi artırılabilmektedir. \nSadece bu uygulamayla ilgili aşağıdaki yargılardan hangisi doğrudur?",
      'cevap': [
        'A) Bu uygulamayla mısır kurdunun genetik yapısı değiştirilmiştir.',
        'B) Bu uygulamayla mısır bitkisine kazandırılan özellik, sonraki nesillerine de aktarılabilir.',
        'C) Bu uygulama, mısır bitkilerinin tüm zararlı canlılara karşı korunmasını sağlar.',
        'D) Bu uygulama, mısır kurdunda yapay seçilimi sağlamak için yapılmıştır.'
      ],
      'dogrucevap': 'B) '
    },
    {//20
      'soru':
        "Yerkürenin doğal dengesini korumak amacıyla 2002 yılında yapılan bir dünya zirvesinde kabul edilen ilkelerden biri “Tehlikeyi Önleme İlkesi”dir. Bu ilkeyle, doğal dengeyi korumak için söz konusu sorun ortaya çıkmadan önlem alınması amaçlanmıştır. Buna göre aşağıda verilenlerden hangisi “Tehlikeyi Önleme İlkesi” kapsamında yapılan bir uygulama değildir?",
      'cevap': [
        'A) Akarsulara evsel atıkların karışmasının önlenmesi',
        'B) Atmosfere karbondioksit veren enerji kaynaklarının kullanımının artırılması',
        'C) Plastik ve cam gibi malzemelerin geri dönüşümünün sağlanması',
        'D) Orman varlığının korunması için kâğıt kullanımının azaltılması'
      ],
      'dogrucevap': 'B) '
    },

  ];
}

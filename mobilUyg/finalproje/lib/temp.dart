import 'package:finalproje/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kayıt ve Giriş Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedRole;

  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(message)));
  }

  void login() async {
    // Loading göstermek için dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (selectedRole == "Şirket Sahibi") {
        final authorizedEmails = ["ugur@gmail.com", "erkan@gmail.com"];
        const authorPassword = "sifre";
        if (authorizedEmails.contains(_emailController.text.trim())) {
          if (authorPassword == _passwordController.text.trim()) {
            Navigator.pop(context); // Loading dialog kapatılır
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CompanyOwnerScreen()),
            );
          }
        } else {
          Navigator.pop(context); // Loading dialog kapatılır
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Yetkili bir şirket sahibi hesabı bulunamadı.")),
          );
        }
      } else if (selectedRole == "Müşteri") {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          Navigator.pop(context); // Loading dialog kapatılır
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarsList()),
          );
        } on FirebaseAuthException catch (e) {
          Navigator.pop(context);
          displayMessageToUser(e.code, context);
        }
      } else {
        Navigator.pop(context); // Loading dialog kapatılır
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen bir rol seçin.")),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Loading dialog kapatılır
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş yapılamadı: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100], // Arka plan rengi
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "KARABAŞ OTOMOTİV",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown, // Metin rengi koyu kahve
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "E-posta",
                    labelStyle: TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.brown), // Çerçeve rengi
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.brown), // Aktif değilken çerçeve
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.brown, width: 2.0), // Aktifken çerçeve
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.brown),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.brown),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Şifre",
                    labelStyle: TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.brown),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.brown),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Rol Seçin",
                    labelStyle: TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                  ),
                  value: selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "Şirket Sahibi",
                      child: Text(
                        "Şirket Sahibi",
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Müşteri",
                      child: Text(
                        "Müşteri",
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: Colors.brown, // Buton rengi koyu kahve
                    foregroundColor: Colors.white, // Yazı rengi beyaz
                  ),
                  onPressed: login,
                  child: const Text("Giriş Yap"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    "Hesabınız yok mu? Kayıt Olun",
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(message)));
  }

  void registeruser() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);

      displayMessageToUser("Şifreler uyuşmuyor!", context);
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        Navigator.pop(context); // Geri dönmek için
        // Kullanıcı kimliğini almak
        final User? user = userCredential.user;

        if (user != null) {
          // Firestore'a kaydetme
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'uid': user.uid,
            'createdAt': Timestamp.now(),
          });
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        foregroundColor: Colors.brown,
        title: const Text("Kayıt Ol"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // E-posta alanı
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "E-posta",
                labelStyle: TextStyle(color: Colors.brown), // Yazı rengi
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.brown), // Alt çizgi rengi
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.brown), // Odaklanıldığında alt çizgi
                ),
              ),
            ),
            // Şifre alanı
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Şifre",
                labelStyle: TextStyle(color: Colors.brown), // Yazı rengi
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.brown), // Alt çizgi rengi
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.brown), // Odaklanıldığında alt çizgi
                ),
              ),
              obscureText: true,
            ),
            // Şifre doğrulama alanı
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Şifreyi Doğrula",
                labelStyle: TextStyle(color: Colors.brown), // Yazı rengi
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.brown), // Alt çizgi rengi
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.brown), // Odaklanıldığında alt çizgi
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Kayıt Ol butonu
            ElevatedButton(
              onPressed: () {
                registeruser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown, // Buton arka plan rengi
                foregroundColor: Colors.white, // Buton yazı rengi
              ),
              child: const Text("Kayıt Ol"),
            ),
          ],
        ),
      ),
    );
  }
}

class CarsList extends StatefulWidget {
  const CarsList({super.key});

  @override
  State<CarsList> createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  final CollectionReference carsCollection =
      FirebaseFirestore.instance.collection('cars');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hoşgeldiniz"),
        centerTitle: true,
        backgroundColor: Colors.brown[200],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: carsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Henüz araba eklenmedi."));
                }

                var cars = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    var car = cars[index];
                    return ListTile(
                      leading: Image.network(
                        car['image'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(car['title'] ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CarDetailsScreen(carId: car.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.brown[200],
            padding: const EdgeInsets.all(16.0),
            child: const Column(
              children: [
                Text(
                  "Şirket Bilgileri",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                    "Adres: Bahçelievler, Serpinti Sk. No:15, 34893 Pendik/İstanbul"),
                Text("Uğur KARABAŞ 05398743845\nErkan KARABAŞ 05443133301"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyOwnerScreen extends StatefulWidget {
  const CompanyOwnerScreen({super.key});

  @override
  State<CompanyOwnerScreen> createState() => _CompanyOwnerScreenState();
}

class _CompanyOwnerScreenState extends State<CompanyOwnerScreen> {
  // Yeni araba bilgileri için controller'lar
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bodyTypeController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _fuelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  // Araba ekleme işlemi
  void addCar() async {
    if (_titleController.text.isNotEmpty &&
        _imageController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _bodyTypeController.text.isNotEmpty &&
        _kmController.text.isNotEmpty &&
        _brandController.text.isNotEmpty &&
        _modelController.text.isNotEmpty &&
        _transmissionController.text.isNotEmpty &&
        _fuelController.text.isNotEmpty &&
        _yearController.text.isNotEmpty) {
      try {
        // Firestore'a araba ekleyelim
        await FirebaseFirestore.instance.collection('cars').add({
          'title': _titleController.text,
          'image': _imageController.text,
          'price': _priceController.text,
          'bodyType': _bodyTypeController.text,
          'km': _kmController.text,
          'brand': _brandController.text,
          'model': _modelController.text,
          'transmission': _transmissionController.text,
          'fuel': _fuelController.text,
          'year': _yearController.text,
        });

        // İşlem başarılı olursa kullanıcıyı bilgilendirelim
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Araba başarıyla eklendi!")),
        );

        // Formu sıfırlayalım
        _titleController.clear();
        _imageController.clear();
        _priceController.clear();
        _bodyTypeController.clear();
        _kmController.clear();
        _brandController.clear();
        _modelController.clear();
        _transmissionController.clear();
        _fuelController.clear();
        _yearController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bir hata oluştu: $e")),
        );
      }
    } else {
      // Eğer herhangi bir alan boşsa kullanıcıyı bilgilendirelim
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Şirket Sahibi Paneli"),
          backgroundColor: Colors.brown[400],
          bottom: TabBar(
            indicatorColor: Colors.brown[900],
            labelColor: Colors.brown[900],
            unselectedLabelColor: Colors.brown[700],
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            tabs: const [
              Tab(icon: Icon(Icons.directions_car), text: "Arabalar"),
              Tab(icon: Icon(Icons.add), text: "Araba Ekle"),
              Tab(icon: Icon(Icons.edit), text: "Kaldır"),
            ],
          ),
        ),
        backgroundColor: Colors.brown[200],
        body: TabBarView(
          children: [
            // Arabaları Listeleme
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('cars').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var cars = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    var car = cars[index];
                    return ListTile(
                      leading: Image.network(
                        car['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(car['title']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CarDetailsScreen(carId: car.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            // Araba Ekleme Formu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Yeni Araba Ekle",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // Araba başlığı
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Araba Başlığı",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Araba görseli
                    TextField(
                      controller: _imageController,
                      decoration: const InputDecoration(
                        labelText: "Araba Görseli (URL)",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Fiyat
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Fiyat",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Kasa tipi
                    TextField(
                      controller: _bodyTypeController,
                      decoration: const InputDecoration(
                        labelText: "Kasa Tipi",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Kilometre
                    TextField(
                      controller: _kmController,
                      decoration: const InputDecoration(
                        labelText: "Kilometre",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Marka
                    TextField(
                      controller: _brandController,
                      decoration: const InputDecoration(
                        labelText: "Marka",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Model
                    TextField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: "Model",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Vites
                    TextField(
                      controller: _transmissionController,
                      decoration: const InputDecoration(
                        labelText: "Vites",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Yakıt
                    TextField(
                      controller: _fuelController,
                      decoration: const InputDecoration(
                        labelText: "Yakıt",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Yıl
                    TextField(
                      controller: _yearController,
                      decoration: const InputDecoration(
                        labelText: "Yıl",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: addCar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.brown, // Butonun kahverengi olması
                        foregroundColor: Colors.white, // Yazının beyaz olması
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Yuvarlak köşeler
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                      ),
                      child: const Text("Araba Ekle"),
                    ),
                  ],
                ),
              ),
            ),
            // Arabaları Kaldırma
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('cars').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var cars = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    var car = cars[index];
                    return ListTile(
                      leading: Image.network(
                        car['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(car['title']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('cars')
                              .doc(car.id)
                              .delete();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CarDetailsScreen extends StatelessWidget {
  final String carId; // Belirli bir arabanın ID'si

  const CarDetailsScreen({super.key, required this.carId});

  @override
  Widget build(BuildContext context) {
    // Firestore referansı
    final carRef = FirebaseFirestore.instance.collection('cars').doc(carId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Araba Detayları"),
        centerTitle: true,
        backgroundColor: Colors.brown[200],
      ),
      backgroundColor: Colors.brown[200],
      body: FutureBuilder<DocumentSnapshot>(
        future: carRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              !snapshot.data!.exists) {
            return const Center(child: Text("Araba bilgisi bulunamadı."));
          }

          // Arabayı al
          final carData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  carData['image'] != null
                      ? Image.network(
                          carData['image'],
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  Text(
                    "Fiyat: ${carData['price']} TL",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Marka: ${carData['brand']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Model: ${carData['model']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Yıl: ${carData['year']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Yakıt Türü: ${carData['fuel']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Vites: ${carData['transmission']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Kilometre: ${carData['km']} km",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Kasa Tipi: ${carData['bodyType']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

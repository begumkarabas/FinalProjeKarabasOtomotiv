import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cars_details.dart';

class CompanyOwnerScreen extends StatefulWidget {
  const CompanyOwnerScreen({super.key});

  @override
  State<CompanyOwnerScreen> createState() => _CompanyOwnerScreenState();
}

class _CompanyOwnerScreenState extends State<CompanyOwnerScreen> {
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Araba başarıyla eklendi!")),
        );
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
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                      ),
                      child: const Text("Araba Ekle"),
                    ),
                  ],
                ),
              ),
            ),
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

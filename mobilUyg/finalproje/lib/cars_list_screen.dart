import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproje/cars_details.dart';

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

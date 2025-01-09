import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarDetailsScreen extends StatelessWidget {
  final String carId;

  const CarDetailsScreen({super.key, required this.carId});

  @override
  Widget build(BuildContext context) {
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

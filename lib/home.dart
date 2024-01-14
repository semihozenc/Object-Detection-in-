import 'package:flutter/material.dart';
import 'genel.dart';
import 'TfliteModel.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug banner'ını kaldır
      home: Scaffold(
        appBar: AppBar(
          title: Text("Tespit Türü Seçimi"),
          centerTitle: true, // Yazıyı ortala
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // Genel Tespit butonuna tıklandığında Genel sayfasına yönlendirme
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NesneTespitiModeli()),
                  );
                },
                child: Text(
                  "Genel Tespit",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // İlaç Tespiti butonuna tıklandığında TfliteModel sayfasına yönlendirme
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TfliteModel()),
                  );
                },
                child: Text(
                  "İlaç Tespiti",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class NesneTespitiModeli extends StatefulWidget {
  const NesneTespitiModeli({Key? key}) : super(key: key);

  @override
  _NesneTespitiModelState createState() => _NesneTespitiModelState();
}

class _NesneTespitiModelState extends State<NesneTespitiModeli>
    with TickerProviderStateMixin {
  late File _image;
  late List _results;
  bool imageSelect = false;
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    modelYukle();
  }

  Future modelYukle() async {
    Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
        _animationController.stop();
      });
    });

    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    ))!;
    print("Genel Model yükleme durumu: $res");
  }

  Future imageClassification(File image) async {
    final List? tanimalar = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = tanimalar!;
      _image = image;
      imageSelect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nesne Tespiti"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (isLoading)
            Positioned.fill(
              child: Image.asset(
                "assets/subu.png",
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          Center(
            child: isLoading
                ? Container() // Yüklenirken gösterilen boş container
                : ListView(
              children: [
                (imageSelect)
                    ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.file(_image),
                )
                    : Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: const Opacity(
                    opacity: 0.8,
                    child: Center(
                      child: Text(
                        "Resim Seçilmedi.",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: (imageSelect)
                        ? _results.map((sonuc) {
                      return Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "${sonuc['label']} - ${sonuc['confidence'].toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }).toList()
                        : [],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isLoading
          ? null // Loading sırasında FloatingActionButton'u gizle
          : FloatingActionButton(
        onPressed: resimSec,
        tooltip: "Resim Seçiniz.",
        child: const Icon(Icons.image),
      ),
    );
  }

  Future resimSec() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? secilenDosya = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(secilenDosya!.path);
    imageClassification(image);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

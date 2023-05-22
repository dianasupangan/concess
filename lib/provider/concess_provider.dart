import 'package:flutter/material.dart';

class Concession {
  final String categoryCode;
  final String subCatCode;
  final String classCode;
  final String subClassCode;
  final String locationCode;

  Concession({
    required this.categoryCode,
    required this.subCatCode,
    required this.classCode,
    required this.subClassCode,
    required this.locationCode,
  });
}

class Concess extends ChangeNotifier {
  final List<Concession> items = [];

  void add(
    String categoryCd,
    String subCatCd,
    String classCd,
    String subClassCd,
    String locCd,
  ) async {
    items.add(
      Concession(
        categoryCode: categoryCd,
        subCatCode: subCatCd,
        classCode: classCd,
        subClassCode: subClassCd,
        locationCode: locCd,
      ),
    );

    notifyListeners();
  }

  void clear() {
    items.clear();

    notifyListeners();
  }
}

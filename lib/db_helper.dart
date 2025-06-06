import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataModel {
  String name;
  String desc;
  String price;

  DataModel({required this.name, required this.desc, required this.price});

  Map<String, dynamic> toMap() => {
        'name': name,
        'desc': desc,
        'price': price,
      };

  factory DataModel.fromMap(Map map) => DataModel(
        name: map['name'],
        desc: map['desc'],
        price: map['price'],
      );
}

class DBHelper {
  static const String boxName = 'dataBox';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  static Future<void> insertData(DataModel data) async {
    var box = Hive.box(boxName);
    await box.add(data.toMap());
  }

  static List<DataModel> getData() {
    var box = Hive.box(boxName);
    return box.values
        .map((e) => DataModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> deleteData(int index) async {
    var box = Hive.box(boxName);
    await box.deleteAt(index);
  }
}

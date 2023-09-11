import 'package:hive/hive.dart';
import 'interests.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  User({required this.id, required this.shortLifeJwt, required this.email, required this.name, required this.interests, required this.verifiedStudent});

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String shortLifeJwt;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late  String? name;

  @HiveField(4)
  late  List<String>? interests;

  @HiveField(5)
 late  bool verifiedStudent;

  void updateName(String newName)
  {
    //Query backend, and on sucesfful response update locally
    name = newName;
  }

}

import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  User({required this.id, required this.shortLifeJwt, required this.name, required this.interests, required this.verifiedStudent});

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String shortLifeJwt;
/*
  @HiveField(2)
  late String email;
*/
  @HiveField(2)
  late  String? name;

  @HiveField(3)
  late  List<String>? interests;

  @HiveField(4)
 late  bool verifiedStudent;


  
  void updateName(String newName)
  {
    //Query backend, and on sucesfful response update locally
    name = newName;
  }

  void updateInterests(List<String>? newInterests)
  {
    interests = newInterests;
  }

  void updateVerifiedStatus(bool newStatus)
  {
    verifiedStudent = newStatus;

  }

}

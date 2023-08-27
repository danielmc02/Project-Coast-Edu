import 'package:hive/hive.dart';

part 'user.g.dart';
@HiveType(typeId: 0)
class User
{
  User({
    required this.shortLifeJwt,
    required this.publicKey,
    required this.email
  });

  @HiveField(0)
  late String shortLifeJwt;


  @HiveField(1)
  late String publicKey ;

  @HiveField(2)
  late String email;



}
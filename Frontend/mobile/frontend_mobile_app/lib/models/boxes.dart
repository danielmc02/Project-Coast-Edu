
import 'package:hive/hive.dart';

import 'user.dart';

class Boxes
{
  static Box<User> getUserBox() => Hive.box<User>('mainUser');
  static User? getUser() => Hive.box<User>('mainUser').get('mainUser');
}

import 'package:hive/hive.dart';

import 'user.dart';


/*
Static persisted data models
*/
class Boxes
{
  static Box<User> getUserBox() => Hive.box<User>('mainUser');
  static User? getUser() => Hive.box<User>('mainUser').get('mainUser');
}
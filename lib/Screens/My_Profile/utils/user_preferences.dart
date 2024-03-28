import 'dart:convert';

import 'package:flutter_auth/Screens/My_Profile/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static const _keyUser = 'user';
  static const myUser = User_new(
    imagePath:
        // 'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80',
        'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.researchgate.net%2Fprofile%2FHima-Adimulapu&psig=AOvVaw20j_1I4xuBxRKs79wV2f8g&ust=1711702936390000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCMj17L3MloUDFQAAAAAdAAAAABAE',
    name: 'Sarah Abs',
    email: 'sarah.abs@gmail.com',
    about:
        'Certified Personal Trainer and Nutritionist with years of experience in creating effective diets and training plans focused on achieving individual customers goals in a smooth way.',
    isDarkMode: false,
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User_new user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static User_new getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User_new.fromJson(jsonDecode(json));
  }
}

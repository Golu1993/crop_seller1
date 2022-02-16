import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefences {
  late Future<SharedPreferences> preferences;

  void setIsLogin(bool isLogin) async {
    SharedPreferences preff = await preferences;
    preff.setBool("islogin", isLogin);
  }

  Future<bool> getIsLogin() async {
    SharedPreferences preff = await preferences;
    return preff.getBool("islogin") ?? false;
  }
  void setSession(String isLogin) async {
    SharedPreferences preff = await preferences;
    preff.setString("session", isLogin);
  }

  Future<String> getSession() async {
    SharedPreferences preff = await preferences;
    return preff.getString("session") ?? "";
  }
  void setUserName(String data) async {
    SharedPreferences preff = await preferences;
    preff.setString("user_name", data);
  }

  Future<String> getUserName() async {
    SharedPreferences preff = await preferences;
    return preff.getString("user_name") ?? "";
  }
  void setUserImage(String data) async {
    SharedPreferences preff = await preferences;
    preff.setString("image", data);
  }

  Future<String> getUserImage() async {
    SharedPreferences preff = await preferences;
    return preff.getString("image") ?? "";
  }

  MySharedPrefences() {
     preferences = SharedPreferences.getInstance();
  }
}

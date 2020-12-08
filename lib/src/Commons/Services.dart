import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Services {
  static final String baseUrl = "projekkelas.000webhostapp.com";

  static _requestPost(path, body) {
    print("sent to " + Uri.https(baseUrl, path).toString());
    return http.post(Uri.https(baseUrl, path), body: body);
  }

  static http.MultipartRequest _requestMultipart(path) {
    print("sent to " + Uri.https(baseUrl, path).toString());
    return http.MultipartRequest("POST", Uri.https(baseUrl, path));
  }

  static _requestGet(path, parameters) {
    print("sent to " + Uri.https(baseUrl, path, parameters).toString());
    return http.get(Uri.https(baseUrl, path, parameters));
  }

  static Future<Map<String, Object>> login(String email, String password) async {
    final response = await _requestPost("login.php", {
      "email": email,
      "password": password
    });

    final data = jsonDecode(response.body);
    print("response = " + data.toString());

    return data;
  }

  static Future<Map<String, Object>> register(String username, String email, String password, File profilePic) async {
    final form = _requestMultipart("register.php");
    form.fields['username'] = username;
    form.fields['email'] = email;
    form.fields['password'] = password;

    print("username = $username, email = $email, pass = $password");

    if(profilePic != null) {
      print("ada foto!! $profilePic.path");
      form.files.add(await http.MultipartFile.fromPath('profile_picture', profilePic.path));
    }

    http.Response response = await http.Response.fromStream(await form.send());

    final data = jsonDecode(response.body);
    print("response = " + data.toString());

    return data;
  }
}
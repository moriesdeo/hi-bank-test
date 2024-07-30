import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String url = 'https://jsonplaceholder.typicode.com/posts';

  static Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse(url), headers: {
      "Content-type": "application/json",
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<dynamic> fetchPostById(int id) async {
    final response = await http.get(Uri.parse('$url/$id'), headers: {
      "Content-type": "application/json",
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
}

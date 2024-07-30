import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api_service.dart';
import 'google_sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Flutter HiBank Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _posts;
  dynamic _searchedPost;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _posts = ApiService.fetchPosts();
  }

  void _searchPost() async {
    final id = int.tryParse(_searchController.text);
    if (id != null) {
      final post = await ApiService.fetchPostById(id);
      setState(() {
        _searchedPost = post;
      });
    } else {
      setState(() {
        _searchedPost = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter HiBank Test'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGoogleSignInButton(context),
              const SizedBox(height: 16),
              _buildGoogleSignOutButton(context),
              const SizedBox(height: 16),
              _buildPostSearchField(),
              const SizedBox(height: 16),
              _buildSearchButton(),
              if (_searchedPost != null) _buildSearchedPostCard(_searchedPost),
              const SizedBox(height: 16),
              _buildPostsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.googleLogin();
      },
      icon: const Icon(Icons.login),
      label: const Text('Login with Google'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildGoogleSignOutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.logout();
      },
      icon: const Icon(Icons.logout),
      label: const Text('Logout'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildPostSearchField() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        labelText: 'Search by Post ID',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: _searchPost,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('Search'),
    );
  }

  Widget _buildSearchedPostCard(dynamic post) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(post['body']),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList() {
    return FutureBuilder<List<dynamic>>(
      future: _posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(post['body']),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

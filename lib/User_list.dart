import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'UserProvider.dart';

class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          users = data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.red.shade900,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Logged-in User Info"),
          _buildUserCard(user.name, user.email, user.profilePic, isLocalUser: true),
          SizedBox(height: 16),
          _buildSectionTitle("API Users"),
          ...users.map((u) => _buildUserCard(
            "${u['first_name']} ${u['last_name']}",
            u['email'],
            u['avatar'],
          )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildUserCard(String name, String email, String imageUrl, {bool isLocalUser = false}) {
    return Card(
      color: isLocalUser ? Colors.orange.shade100 : null,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 30,
        ),
        title: Text(name),
        subtitle: Text(email),
      ),
    );
  }
}

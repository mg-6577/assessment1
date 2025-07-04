import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'User List', home: UserListScreen());
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];
  String idInput = '';
  String userOutput = '';

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );
    final data = jsonDecode(response.body);
    setState(() {
      users = List<Map<String, dynamic>>.from(data);
    });
  }

  void findUserById(String idText) {
    final id = int.parse(idText);
    final user = users.firstWhere((u) => u['id'] == id);
    setState(() {
      userOutput =
          'Name: ${user['name']}\nEmail: ${user['email']}\nUsername: ${user['username']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: users
                          .map(
                            (user) => ListTile(
                              title: Text(user['name']),
                              subtitle: Text(user['email']),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter user ID',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      idInput = value;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => findUserById(idInput),
                    child: Text('Find User'),
                  ),
                  SizedBox(height: 10),
                  Text(userOutput, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
    );
  }
}

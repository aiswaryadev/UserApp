import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:user_application/user.dart';
import 'package:user_application/base_url.dart';
import 'package:user_application/details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: UserListScreen(),
    );
  }
}
class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> _users = [];
  bool _loading = false;
  int _skip = 0;

  final ScrollController _scrollController = ScrollController();
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchUsers();
    }
  }

  Future<void> _fetchUsers() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      final response = await _dio.get(BaseUrlclass.getUsersUrl(_skip));
      List<User> newUsers = (response.data['users'] as List)
          .map((user) => User.fromJson(user))
          .toList();

      setState(() {
        _users.addAll(newUsers);
        _skip += 10;
      });
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: _users.isEmpty && _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.image),
                        ),
                        title: Text(user.firstName),
                        subtitle: Text(user.email),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(userId: user.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (_loading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}

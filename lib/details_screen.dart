import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:user_application/user.dart';
import 'package:user_application/base_url.dart';

class DetailsScreen extends StatelessWidget {
  final int userId;

   DetailsScreen({required this.userId});

  Future<User> _fetchUserDetails() async {
    final Dio dio = Dio();
    final response = await dio.get(BaseUrlclass.getUserDetailUrl(userId));
    return User.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Details')),
      body: FutureBuilder<User>(
        future: _fetchUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading user details'));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: 
                  // CircleAvatar(
                  //   radius: 50,
                  //   backgroundImage: NetworkImage(user.image),
                  // ),
                  Container(
                    width: 50, 
                    height: 50,
                    decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(user.image),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.zero,
                  ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Name: ${user.firstName} ${user.lastName}', style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 5),
                Text('Gender: ${user.gender}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 5),
                Text('Phone: ${user.phone}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 5),
                Text('DOB: ${user.birthDate}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 5),
                Text('Address: ${user.address.address},${user.address.city},${user.address.country}', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
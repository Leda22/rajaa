import 'package:flutter/material.dart';
import 'package:test01/admin/addstudentform.dart';
import 'package:test01/admin/addprofform.dart';
import 'package:test01/admin/student_data.dart';
import 'package:test01/admin/teacher_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test01/screens/login.dart';

class Admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text('Add Student'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStudent()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text('Add Teacher'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTeacher()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Students Data'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentsData(
                            module: '',
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Teachers Data'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeachersData()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  _buildDashboard(context, constraints),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, BoxConstraints constraints) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth < 600 ? 2 : 4;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        _buildDashboardItem(
          Icon(Icons.person_add, size: 48.0),
          'Add Student',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStudent()),
            );
          },
        ),
        _buildDashboardItem(
          Icon(Icons.person_add, size: 48.0),
          'Add Teacher',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTeacher()),
            );
          },
        ),
        _buildDashboardItem(
          Icon(Icons.person, size: 48.0),
          'Students Data',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentsData(
                        module: '',
                      )),
            );
          },
        ),
        _buildDashboardItem(
          Icon(Icons.person, size: 48.0),
          'Teachers Data',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TeachersData()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDashboardItem(Icon icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

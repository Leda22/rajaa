import 'package:flutter/material.dart';
import 'package:test01/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test01/screens/check_in.dart';

class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final Auth _auth = Auth();
 List<dynamic>? modules = [];

  @override
  void initState() {
    super.initState();
    fetchModules();
  }

 Future<void> fetchModules() async {
  try {
    // Get the logged-in teacher's email
    final currentUserEmail = _auth.currentUser?.email;

    // Query Firestore to retrieve the modules for the teacher
    final snapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final teacherData = snapshot.docs.first.data();
      final Map<String, dynamic> modulesMap = teacherData['modules'];
      final List<dynamic> moduleList = modulesMap.values.toList();
      
      setState(() {
        modules = moduleList.expand((module) => module).cast<String>().toList();
      });
    }
  } catch (error) {
    print('Error fetching modules: $error');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: modules!.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              padding: EdgeInsets.all(16.0),
              itemCount: modules!.length,
              itemBuilder: (context, index) {
                final module = modules![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckIn(module: module),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        module,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

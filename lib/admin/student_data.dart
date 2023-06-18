import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test01/admin/editstudent.dart';

class StudentsData extends StatefulWidget {
  const StudentsData({super.key, required String module});
  @override
  _StudentsDataState createState() => _StudentsDataState();
}

class _StudentsDataState extends State<StudentsData> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> studentsData = [];
  List<Map<String, dynamic>> filteredStudentsData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStudentsData();
  }

  Future<void> fetchStudentsData() async {
    try {
      QuerySnapshot studentsSnapshot =
          await _firestore.collection('students').get();

      setState(() {
        studentsData = studentsSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['studentId'] = doc.id;
          return data;
        }).toList();
        filteredStudentsData = List.from(studentsData);
      });
    } catch (error) {
      print('Error retrieving students data: $error');
    }
  }

  void filterStudentsData(String searchQuery) {
    setState(() {
      filteredStudentsData = studentsData.where((student) {
        final firstName = student['firstName'].toString().toLowerCase();
        final lastName = student['lastName'].toString().toLowerCase();
        return firstName.contains(searchQuery.toLowerCase()) ||
            lastName.contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  void _openEditStudentModal(String studentId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: EditStudent(studentId: studentId),
        );
      },
    );
  }

  void deleteStudent(String studentId) async {
    try {
      await _firestore.collection('students').doc(studentId).delete();
      fetchStudentsData(); // Refresh the data after deletion
    } catch (error) {
      print('Error deleting student: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Data'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterStudentsData,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Level')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: filteredStudentsData.map((student) {
                  final studentId = student['studentId'] ?? '';
                  final firstName = student['firstName'] ?? '';
                  final lastName = student['lastName'] ?? '';
                  final level = student['level'] ?? '';

                  return DataRow(cells: [
                    DataCell(Text(firstName)),
                    DataCell(Text(lastName)),
                    DataCell(Text(level)),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _openEditStudentModal(studentId),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteStudent(studentId),
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

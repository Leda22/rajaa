import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test01/admin/editteacher.dart';

class TeachersData extends StatefulWidget {
  @override
  _TeachersDataState createState() => _TeachersDataState();
}

class _TeachersDataState extends State<TeachersData> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> teachersData = [];
  List<Map<String, dynamic>> filteredTeachersData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTeachersData();
  }

  Future<void> fetchTeachersData() async {
    try {
      QuerySnapshot teachersSnapshot =
          await _firestore.collection('teachers').get();

      setState(() {
        teachersData = teachersSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['teacherId'] = doc.id;
          return data;
        }).toList();
        filteredTeachersData = List.from(teachersData);
      });
    } catch (error) {
      print('Error retrieving teachers data: $error');
    }
  }

  void filterTeachersData(String searchQuery) {
    setState(() {
      filteredTeachersData = teachersData.where((teacher) {
        final firstName = teacher['firstName'].toString().toLowerCase();
        final lastName = teacher['lastName'].toString().toLowerCase();
        return firstName.contains(searchQuery.toLowerCase()) ||
            lastName.contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  void _openEditTeacherModal(String teacherId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: EditTeacher(teacherId: teacherId),
        );
      },
    );
  }

  void deleteTeacher(String teacherId) async {
    try {
      await _firestore.collection('teachers').doc(teacherId).delete();
      fetchTeachersData(); // Refresh the data after deletion
    } catch (error) {
      print('Error deleting teacher: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers Data'),
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
              onChanged: filterTeachersData,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: filteredTeachersData.map((teacher) {
                  final teacherId = teacher['teacherId'] ?? '';
                  final firstName = teacher['firstName'] ?? '';
                  final lastName = teacher['lastName'] ?? '';
                  final subject = teacher['subject'] ?? '';

                  return DataRow(cells: [
                    DataCell(Text(firstName)),
                    DataCell(Text(lastName)),
                    DataCell(Text(subject)),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _openEditTeacherModal(teacherId),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteTeacher(teacherId),
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

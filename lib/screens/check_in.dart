import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckIn extends StatefulWidget {
  final String module;

  CheckIn({required this.module});

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
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
          data['present'] = false;
          return data;
        }).toList();
        filteredStudentsData = List.from(studentsData);
      });
    } catch (error) {
      print('Error retrieving students data: $error');
    }
  }

  void filterStudentsData(String searchQuery) async {
    setState(() {
      filteredStudentsData = studentsData.where((student) {
        final firstName = student['firstName']?.toString().toLowerCase() ?? '';
        final lastName = student['lastName']?.toString().toLowerCase() ?? '';
        final level = student['level']?.toString().toLowerCase() ?? '';
        final group = student['group']?.toString().toLowerCase() ?? '';
        final verify = student['verification']?.toString().toLowerCase() ?? '';

        return firstName.contains(searchQuery.toLowerCase()) ||
            lastName.contains(searchQuery.toLowerCase()) ||
            level.contains(searchQuery.toLowerCase()) ||
            group.contains(searchQuery.toLowerCase()) ||
            verify.contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  Future<void> saveHistory() async {
    try {
      final DateTime now = DateTime.now();
      final String historyTitle =
          '${widget.module}_${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}';

      final List<Map<String, dynamic>> historyData =
          filteredStudentsData.map((student) {
        final firstName = student['firstName'] ?? '';
        final lastName = student['lastName'] ?? '';
        final level = student['level'] ?? '';
        final group = student['group'] ?? '';
        final verify = student['verification'] ?? '';

        return {
          'firstName': firstName,
          'lastName': lastName,
          'level': level,
          'group': group,
          'verification': verify,
        };
      }).toList();

      await _firestore
          .collection('history')
          .doc(historyTitle)
          .set({'module': widget.module, 'data': historyData});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Check-in history saved successfully!'),
        ),
      );
    } catch (error) {
      print('Error saving check-in history: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save check-in history.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check-In'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveHistory,
          ),
        ],
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
                  DataColumn(label: Text('Group')),
                  DataColumn(label: Text('Verification')),
                ],
                rows: filteredStudentsData.map((student) {
                  final studentId = student['studentId'] ?? '';
                  final firstName = student['firstName'] ?? '';
                  final lastName = student['lastName'] ?? '';
                  final level = student['level'] ?? '';
                  final group = student['group'] ?? '';
                  final verify = student['verification'] ?? '';

                  return DataRow(cells: [
                    DataCell(Text(firstName)),
                    DataCell(Text(lastName)),
                    DataCell(Text(level)),
                    DataCell(Text(group)),
                    DataCell(Text(verify)),
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

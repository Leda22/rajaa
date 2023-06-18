import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({super.key, required String studentId});

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final db = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  List<String> levels = [
    'ING',
    'L1',
    'L2',
    'L3 - SI',
    'L3 - ISIL',
    'M1 - WIC',
    'M1 - RSSI',
    'M1 - ISI',
    'M2 - WIC',
    'M2 - RSSI',
    'M2 - ISI'
  ];
  List<String> groups = ['1', '2'];
  bool dette = false;
  bool ajourne = false;
  bool present = false;
  String? selectedLevel;
  String? selectedGroup;
  String? selectedDette;
  String? selectedAjourne;
  String? selectedSection;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new document in Firestore
      await db.collection('students').doc(firstName + ' ' + lastName).set({
        'firstName': firstName,
        'lastName': lastName,
        'level': selectedLevel,
        'group': selectedGroup,
        'dette': selectedDette == 'No',
        'ajourne': selectedAjourne == 'No',
        'present': present,
        'sections': selectedSection,
      });

      // Reset the form fields
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    firstName = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    lastName = value!.toUpperCase();
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text('Select Level'),
              DropdownButtonFormField<String>(
                value: selectedLevel,
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value;
                    if (selectedLevel != null &&
                        (selectedLevel!.contains('M1') ||
                            selectedLevel!.contains('M2'))) {
                      selectedSection = 'null';
                    }
                  });
                },
                items: levels.map((level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Level',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Select Group'),
              DropdownButtonFormField<String>(
                value: selectedGroup,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                  });
                },
                items: groups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Group',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a group';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Select Dette'),
              DropdownButtonFormField<String>(
                value: selectedDette,
                onChanged: (value) {
                  setState(() {
                    selectedDette = value;
                    if (selectedDette == 'Yes') {
                      selectedAjourne = 'No';
                    }
                  });
                },
                items: ['Yes', 'No'].map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Dette',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select Dette';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Select Ajourne'),
              DropdownButtonFormField<String>(
                value: selectedAjourne,
                onChanged: (value) {
                  setState(() {
                    selectedAjourne = value;
                    if (selectedAjourne == 'Yes') {
                      selectedDette = 'No';
                    }
                  });
                },
                items: ['Yes', 'No'].map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Ajourne',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select Ajourne';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Select Section'),
              DropdownButtonFormField<String>(
                value: selectedSection,
                onChanged: (value) {
                  setState(() {
                    selectedSection = value;
                  });
                },
                items: ['null', '1', '2'].map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Section',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a section';
                  }
                  return null;
                },
                enableFeedback: selectedLevel == null ||
                    (!selectedLevel!.contains('M1') &&
                        !selectedLevel!.contains('M2')),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Edit Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

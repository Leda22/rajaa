import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test01/auth.dart';

class EditTeacher extends StatefulWidget {
  const EditTeacher({super.key, required String teacherId});
  @override
  _EditTeacherState createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {
  final db = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedPrefix = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
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
  List<String> sections = ['null', '1', '2'];
  List<String> modules = ['module1', 'module2', 'module3', 'module4'];
  TextEditingController levelsController = TextEditingController();
  TextEditingController groupsController = TextEditingController();
  TextEditingController sectionsController = TextEditingController();
  TextEditingController modulesController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new document in Firestore for the teacher

      await db
          .collection('teachers')
          .doc('${selectedPrefix + ' '} $lastName')
          .set({
        'lastName': '${selectedPrefix + ' '} $lastName',
        'firstName': firstName, // Add 'Mr.' or 'Mrs.' prefix
        'email': email,
      });
      db
          .collection('teachers')
          .doc('${selectedPrefix + ' '} $lastName')
          .collection('groups')
          .doc()
          .set({
        'groups': groupsController.text
            .split(',')
            .map((group) => group.trim())
            .toSet()
            .toList()
      });
      db
          .collection('teachers')
          .doc('${selectedPrefix + ' '} $lastName')
          .collection('modules')
          .doc()
          .set({
        'modules': modulesController.text
            .split(',')
            .map((module) => module.trim())
            .toSet()
            .toList()
      });

      // Create user authentication using email and password
      // Replace this with your own authentication logic
      Auth().createUserWithEmailAndPassword(email: email, password: password);

      // Reset the form fields
      _formKey.currentState!.reset();
    }
  }

  Widget buildInputFieldWithSuggestions(
    String label,
    List<String> suggestions,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter $label',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onTap: () {
        showSuggestionsDialog(context, label, suggestions, controller);
      },
    );
  }

  Future<void> showSuggestionsDialog(BuildContext context, String label,
      List<String> suggestions, TextEditingController controller) async {
    List<String> selectedValues =
        controller.text.split(',').map((value) => value.trim()).toList();
    final List<String> availableSuggestions = List.from(suggestions);

    final selectedValuesSet = Set.from(selectedValues);
    availableSuggestions.removeWhere(selectedValuesSet.contains);

    final selectedSuggestions = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        List<String> selectedSuggestions = [];
        return AlertDialog(
          title: Text('Select $label'),
          content: SingleChildScrollView(
            child: Column(
              children: availableSuggestions.map((String suggestion) {
                return ListTile(
                  title: Text(suggestion),
                  tileColor: selectedSuggestions.contains(suggestion)
                      ? Colors.grey.withOpacity(0.3)
                      : null,
                  onTap: () {
                    setState(() {
                      if (selectedSuggestions.contains(suggestion)) {
                        selectedSuggestions
                            .remove(selectedSuggestions.contains(suggestion));
                        selectedSuggestions.add(suggestion);
                        Navigator.pop(context, selectedSuggestions);
                      } else {
                        selectedSuggestions.add(suggestion);
                        Navigator.pop(context, selectedSuggestions);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selectedSuggestions != null) {
      selectedValues.addAll(selectedSuggestions);
      controller.text = selectedValues.toSet().join(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Teacher'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Prefix'),
                items: ['Mr.', 'Mrs.']
                    .map((prefix) => DropdownMenuItem(
                          value: prefix,
                          child: Text(prefix),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a prefix';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    selectedPrefix = value!;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    selectedPrefix = value!;
                  });
                },
              ),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    email = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    password = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              buildInputFieldWithSuggestions(
                  'Levels', levels, levelsController),
              SizedBox(height: 16.0),
              buildInputFieldWithSuggestions(
                  'Groups', groups, groupsController),
              SizedBox(height: 16.0),
              buildInputFieldWithSuggestions(
                  'Sections', sections, sectionsController),
              SizedBox(height: 16.0),
              buildInputFieldWithSuggestions(
                  'Modules', modules, modulesController),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Teacher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

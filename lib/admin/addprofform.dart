import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test01/auth.dart';

class AddTeacher extends StatefulWidget {
  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedPrefix;
  String firstName = '';
  String lastName = '';
  String email = '';
  List<String> selectedLevels = [];
  Map<String, List<String>> selectedGroups = {};
  Map<String, List<String>> selectedModules = {};

  List<String> levels = [
    'L2',
    'L3 - SI',
    'L3 - ISIL',
    'M1 - WIC',
    'M1 - RSSI',
    'M1 - ISI',
    'M2 - WIC',
    'M2 - RSSI',
    'M2 - ISI',
  ];

  Map<String, List<String>> levelGroupMap = {
    'L2': ['G1', 'G2'],
    'L3 - SI': ['G1', 'G2'],
    'L3 - ISIL': ['G1', 'G2'],
    'M1 - WIC': ['G1', 'G2'],
    'M1 - RSSI': ['G1', 'G2'],
    'M1 - ISI': ['G1', 'G2'],
    'M2 - WIC': ['G1', 'G2'],
    'M2 - RSSI': ['G1', 'G2'],
    'M2 - ISI': ['G1', 'G2'],
  };

  Map<String, List<String>> levelModuleMap = {
    'L2': ['Module A', 'Module B', 'Module C'],
    'L3 - SI': ['Module D', 'Module E', 'Module F'],
    'L3 - ISIL': ['Module G', 'Module H', 'Module I'],
    'M1 - WIC': ['Module J', 'Module K', 'Module L'],
    'M1 - RSSI': ['Module M', 'Module N', 'Module O'],
    'M1 - ISI': ['Module P', 'Module Q', 'Module R'],
    'M2 - WIC': ['Module S', 'Module T', 'Module U'],
    'M2 - RSSI': ['Module V', 'Module W', 'Module X'],
    'M2 - ISI': ['Module Y', 'Module Z', 'Module AA'],
  };

  TextEditingController levelsController = TextEditingController();
  TextEditingController groupsController = TextEditingController();
  TextEditingController modulesController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save the form data
      print('Prefix: $selectedPrefix');
      print('First Name: $firstName');
      print('Last Name: $lastName');
      print('Email: $email');
      print('Levels: $selectedLevels');
      print('Groups: $selectedGroups');
      print('Modules: $selectedModules');
      Auth().createUserWithEmailAndPassword(email: email, password: lastName);
      try {
        // Save the form data to Firestore
        await FirebaseFirestore.instance.collection('teachers').add({
          'prefix': selectedPrefix,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'levels': selectedLevels.join(', '), // Join levels with commas
          'groups': selectedGroups,
          'modules': selectedModules,
        });
        await FirebaseFirestore.instance.collection('emails').doc().set({
          'email': email,
        });
        Navigator.of(context).pop();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void _addLevelInput() {
    setState(() {
      selectedLevels.add('');
    });
  }

  Widget buildDropdownField(
    String label,
    List<String> items,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue != null && items.contains(selectedValue)
          ? selectedValue
          : null,
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Please Select $label'),
        ),
        ...items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a $label';
        }
        return null;
      },
    );
  }

  Widget buildGroupDropdownField(
    String level,
    List<String> items,
    List<String> selectedValues,
    Function(List<String>) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValues.isNotEmpty ? selectedValues[0] : null,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        List<String> newValues = selectedValues;
        if (newValue != null) {
          newValues = [newValue];
        }
        onChanged(newValues);
      },
      decoration: InputDecoration(labelText: 'Group'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a group';
        }
        return null;
      },
    );
  }

  Widget buildModuleDropdownField(
    String level,
    List<String> items,
    List<String> selectedValues,
    Function(List<String>) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValues.isNotEmpty ? selectedValues[0] : null,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        List<String> newValues = selectedValues;
        if (newValue != null) {
          newValues = [newValue];
        }
        onChanged(newValues);
      },
      decoration: InputDecoration(labelText: 'Module'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a module';
        }
        return null;
      },
    );
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
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  firstName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  lastName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              SizedBox(height: 16.0),
              buildDropdownField(
                'Prefix',
                ['Mr', 'Mrs'],
                selectedPrefix,
                (String? newValue) {
                  setState(() {
                    selectedPrefix = newValue;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Levels',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              for (int i = 0; i < selectedLevels.length; i++) ...[
                Row(
                  children: [
                    Expanded(
                      child: buildDropdownField(
                        'Level',
                        levels,
                        selectedLevels[i],
                        (String? newValue) {
                          setState(() {
                            selectedLevels[i] = newValue!;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          selectedLevels.removeAt(i);
                        });
                      },
                    ),
                  ],
                ),
                if (selectedLevels[i].isNotEmpty) ...[
                  SizedBox(height: 16.0),
                  buildGroupDropdownField(
                    selectedLevels[i],
                    levelGroupMap[selectedLevels[i]]!,
                    selectedGroups[selectedLevels[i]] ?? [],
                    (List<String> newValues) {
                      setState(() {
                        selectedGroups[selectedLevels[i]] = newValues;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  buildModuleDropdownField(
                    selectedLevels[i],
                    levelModuleMap[selectedLevels[i]]!,
                    selectedModules[selectedLevels[i]] ?? [],
                    (List<String> newValues) {
                      setState(() {
                        selectedModules[selectedLevels[i]] = newValues;
                      });
                    },
                  ),
                ],
              ],
              ElevatedButton(
                child: Text('Add New Level'),
                onPressed: _addLevelInput,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Save'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

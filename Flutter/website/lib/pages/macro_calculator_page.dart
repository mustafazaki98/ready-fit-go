import 'package:flutter/material.dart';
import 'package:website/pages/daily_meal_page_2.dart';

void main() {
  runApp(MaterialApp(home: MacroCalculatorPage()));
}

class MacroCalculatorPage extends StatefulWidget {
  @override
  _MacroCalculatorPageState createState() => _MacroCalculatorPageState();
}

class _MacroCalculatorPageState extends State<MacroCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool _macrosCalculated = false;
  String? _macroError;

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final TextEditingController _proteinPercentageController =
      TextEditingController(text: '30');
  final TextEditingController _carbsPercentageController =
      TextEditingController(text: '40');
  final TextEditingController _fatPercentageController =
      TextEditingController(text: '30');

  String _sex = 'Male';
  String _activityLevel =
      'Lightly active (light exercise less than 3 days per week)';
  String _fitnessGoal = 'Lose Weight';
  String _dietaryPreference = 'None';
  int _numberOfMeals = 3;
  int _numberOfDays = 7;

  double _protein = 0.0;
  double _carbs = 0.0;
  double _fats = 0.0;
  double _calories = 0.0;

  void _validateInputs() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    // Validate that macro percentages sum to 100
    double proteinPercentage =
        double.tryParse(_proteinPercentageController.text) ?? 0;
    double carbsPercentage =
        double.tryParse(_carbsPercentageController.text) ?? 0;
    double fatPercentage = double.tryParse(_fatPercentageController.text) ?? 0;

    double totalPercentage =
        proteinPercentage + carbsPercentage + fatPercentage;

    if (totalPercentage != 100) {
      isValid = false;
      _macroError = 'Macro percentages must sum to 100%';
    } else {
      _macroError = null;
    }

    setState(() {
      _isButtonEnabled = isValid;
    });
  }

  void _calculateMacros() {
    if (!_isButtonEnabled) return;

    if (_ageController.text.isEmpty ||
        _sex.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _activityLevel.isEmpty ||
        _fitnessGoal.isEmpty) {
      // Handle the error case where essential parameters are missing
      return;
    }

    double weight = double.parse(_weightController.text);
    double age = double.parse(_ageController.text);
    double height = double.parse(_heightController.text);

    double multiplier;
    switch (_activityLevel) {
      case 'Lightly active (light exercise less than 3 days per week)':
        if (_fitnessGoal == 'Lose Weight') {
          multiplier = 11; // middle of the range 10-12
        } else if (_fitnessGoal == 'Maintain Weight') {
          multiplier = 13; // middle of the range 12-14
        } else if (_fitnessGoal == 'Gain Weight') {
          multiplier = 16; // middle of the range 16-18
        } else if (_fitnessGoal == 'Body Recomposition') {
          multiplier = 12; // slightly less than maintenance
        } else {
          multiplier = 13; // default to maintenance if goal is not specified
        }
        break;
      case 'Moderately active (moderate exercise 3-5 days per week)':
        if (_fitnessGoal == 'Lose Weight') {
          multiplier = 13; // middle of the range 12-14
        } else if (_fitnessGoal == 'Maintain Weight') {
          multiplier = 15; // middle of the range 14-16
        } else if (_fitnessGoal == 'Gain Weight') {
          multiplier = 18; // middle of the range 18-20
        } else if (_fitnessGoal == 'Body Recomposition') {
          multiplier = 14; // slightly less than maintenance
        } else {
          multiplier = 15; // default to maintenance if goal is not specified
        }
        break;
      case 'Very active (intense exercise 6-7 days per week)':
        if (_fitnessGoal == 'Lose Weight') {
          multiplier = 15; // middle of the range 14-16
        } else if (_fitnessGoal == 'Maintain Weight') {
          multiplier = 17; // middle of the range 16-18
        } else if (_fitnessGoal == 'Gain Weight') {
          multiplier = 20; // middle of the range 20-22
        } else if (_fitnessGoal == 'Body Recomposition') {
          multiplier = 16; // slightly less than maintenance
        } else {
          multiplier = 17; // default to maintenance if goal is not specified
        }
        break;
      default:
        multiplier =
            13; // default to maintenance if activity level is not specified
    }

    double dailyCaloricNeeds = weight * multiplier;

    double proteinPercentage = double.parse(_proteinPercentageController.text);
    double carbsPercentage = double.parse(_carbsPercentageController.text);
    double fatPercentage = double.parse(_fatPercentageController.text);

    setState(() {
      _calories = dailyCaloricNeeds;
      _protein = dailyCaloricNeeds * proteinPercentage / 100 / 4;
      _carbs = dailyCaloricNeeds * carbsPercentage / 100 / 4;
      _fats = dailyCaloricNeeds * fatPercentage / 100 / 9;
      _macrosCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/hii.jpeg', // Background image
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment(2.0, -0.46), // Adjust alignment
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Macro Calculator',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Macros are confusing. However, macros are a crucial part of your nutrition.\nThis tool will help you set up the roadmap for your dietary needs.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        onChanged: _validateInputs,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Body Composition',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: DropdownButtonFormField<String>(
                                      style: TextStyle(color: Colors.white),
                                      value: _sex,
                                      decoration: const InputDecoration(
                                        labelText: 'Sex',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      dropdownColor: Colors.grey[800],
                                      items: ['Male', 'Female']
                                          .map((label) => DropdownMenuItem(
                                                child: Text(label),
                                                value: label,
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _sex = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      controller: _ageController,
                                      decoration: const InputDecoration(
                                        labelText: 'Age',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter age';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: TextFormField(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      controller: _heightController,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter Height (inches)',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter height';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      controller: _weightController,
                                      cursorColor: Colors.white,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Weight (lbs)',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // New Dropdowns
                            const Text(
                              'Preferences',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              style: TextStyle(color: Colors.white),
                              value: _dietaryPreference,
                              decoration: const InputDecoration(
                                labelText: 'Dietary Preference',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: ['None', 'Vegetarian', 'Vegan']
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _dietaryPreference = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<int>(
                              style: TextStyle(color: Colors.white),
                              value: _numberOfMeals,
                              decoration: const InputDecoration(
                                labelText: 'Number of Meals per Day',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: List.generate(6, (index) => index + 1)
                                  .map((label) => DropdownMenuItem(
                                        child: Text('$label'),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _numberOfMeals = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<int>(
                              style: TextStyle(color: Colors.white),
                              value: _numberOfDays,
                              decoration: const InputDecoration(
                                labelText: 'Number of Days',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: List.generate(7, (index) => index + 1)
                                  .map((label) => DropdownMenuItem(
                                        child: Text('$label'),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _numberOfDays = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              style: TextStyle(color: Colors.white),
                              value: _activityLevel,
                              decoration: const InputDecoration(
                                labelText: 'What is your activity level',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: [
                                'Sedentary',
                                'Lightly active (light exercise less than 3 days per week)',
                                'Moderately active (moderate exercise 3-5 days per week)',
                                'Very active (intense exercise 6-7 days per week)',
                                'Super active (very intense exercise or physical job)'
                              ]
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _activityLevel = value!;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              style: TextStyle(color: Colors.white),
                              value: _fitnessGoal,
                              decoration: const InputDecoration(
                                labelText: 'What are your fitness goals',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: [
                                'Lose Weight',
                                'Maintain Weight',
                                'Gain Weight',
                                'Body Recomposition',
                              ]
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _fitnessGoal = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Macro Proportions (should add up to 100%)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      controller: _proteinPercentageController,
                                      decoration: const InputDecoration(
                                        labelText: 'Protein (%)',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter protein %';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    controller: _carbsPercentageController,
                                    decoration: const InputDecoration(
                                      labelText: 'Carbs (%)',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                185, 255, 255, 255)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                185, 255, 255, 255)),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter carbs %';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Enter a valid number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      controller: _fatPercentageController,
                                      decoration: const InputDecoration(
                                        labelText: 'Fat (%)',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter fat %';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_macroError != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  _macroError!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Calculate Macros Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: _isButtonEnabled
                                  ? () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        _calculateMacros();
                                      }
                                    }
                                  : null,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  decoration: BoxDecoration(
                                    color: _isButtonEnabled
                                        ? Colors.white
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Calculate Macros',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Generate Button
                          Center(
                            child: GestureDetector(
                              onTap: _isButtonEnabled
                                  ? () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DailyMealPlanPage(
                                              age: int.tryParse(
                                                  _ageController.text),
                                              sex: _sex,
                                              height: double.tryParse(
                                                  _heightController.text),
                                              weight: double.tryParse(
                                                  _weightController.text),
                                              activityLevel: _activityLevel,
                                              fitnessGoal: _fitnessGoal,
                                              dietaryPreference:
                                                  _dietaryPreference,
                                              numberOfMeals: _numberOfMeals,
                                              numberOfDays: _numberOfDays,
                                              proteinPercentage: double.parse(
                                                  _proteinPercentageController
                                                      .text),
                                              carbsPercentage: double.parse(
                                                  _carbsPercentageController
                                                      .text),
                                              fatPercentage: double.parse(
                                                  _fatPercentageController
                                                      .text),
                                              calculateMacros:
                                                  true, // Assuming this flag triggers macro calculation
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.2, // Adjust the width
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  decoration: BoxDecoration(
                                    color: _isButtonEnabled
                                        ? Colors.white
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Generate',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Display Macros
                      if (_macrosCalculated) ...[
                        const Divider(
                            color: Color.fromARGB(130, 255, 255, 255)),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color.fromARGB(185, 255, 255, 255)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Daily Macros',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildMacroCard('Calories', _calories, 'cal'),
                                  _buildMacroCard('Carbs', _carbs, 'g'),
                                  _buildMacroCard('Protein', _protein, 'g'),
                                  _buildMacroCard('Fats', _fats, 'g'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, double value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${value.toStringAsFixed(0)} $unit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mivro/presentation/auth/api/health_profile.dart';
import 'package:mivro/presentation/auth/model/personal_details.dart';
import 'package:mivro/presentation/auth/provider/personal_details_provider.dart';
import 'package:mivro/presentation/home/view/screens/home_page.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;
  const DetailsScreen({super.key, required this.email, required this.password});

  @override
  ConsumerState<DetailsScreen> createState() {
    return _DetailsScreenState();
  }
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  TextEditingController age = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController bmi = TextEditingController();
  List<String> genders = ['Male', 'Female', 'Other'];
  List<String> dietaryPreferences = [
    "None",
    "Gluten-Free",
    "Halal",
    "High Protein",
    "Keto",
    "Kosher",
    "Lactose-Free",
    "Low Carb",
    "Low Fat",
    "Nut-Free",
    "Organic",
    "Paleo",
    "Pescatarian",
    "Vegan",
    "Vegetarian"
  ];

  List<String> medicalConditions = [
    "None",
    "Anemia",
    "Asthma",
    "Celiac Disease",
    "Diabetes",
    "Gastroesophageal Reflux Disease (GERD)",
    "Heart Disease",
    "High Cholesterol",
    "Hypertension (High Blood Pressure)",
    "Irritable Bowel Syndrome (IBS)",
    "Lactose Intolerance",
    "Obesity",
    "Polycystic Ovary Syndrome (PCOS)",
    "Pregnant",
    "Thyroid Disorder"
  ];

  List<String> allergies = [
    "None",
    "Corn",
    "Dairy",
    "Eggs",
    "Fish",
    "Gluten",
    "Lupin",
    "Mustard",
    "Peanuts",
    "Sesame",
    "Shellfish",
    "Soy",
    "Sulfites",
    "Tree Nuts (e.g., almonds, walnuts)",
    "Wheat"
  ];

  var selectedGender = 'Male';
  var selectedDietaryPreference = 'None';
  var selectedMedicalCondition = 'None';
  var selectedAllergy = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Report'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            left: MediaQuery.of(context).size.width * 0.2,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF5C8374),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: MediaQuery.of(context).size.width * 0.2,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(104, 158, 200, 185),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.cake),
                          labelText: 'Age',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        controller: age,
                      ),
                    ),
                    const Gap(25),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.height),
                          labelText: 'Height',
                          suffix: Text('m'),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        controller: height,
                      ),
                    ),
                    const Gap(25),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.monitor_weight_sharp),
                          labelText: 'Weight',
                          suffix: Text('Kg'),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        controller: weight,
                      ),
                    ),
                    const Gap(25),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon:
                            Icon(Icons.man_outlined, color: Color(0xFF001F3F)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      value: selectedGender,
                      items: genders
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    const Gap(25),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Medical Condition',
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.local_hospital,
                              color: Color(0xFF001F3F)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        value: selectedMedicalCondition,
                        items: medicalConditions
                            .map(
                              (mc) => DropdownMenuItem(
                                value: mc,
                                child: Text(
                                  mc,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMedicalCondition = value!;
                          });
                        },
                      ),
                    ),
                    const Gap(25),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Dietary Preferences',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.restaurant_menu,
                            color: Color(0xFF001F3F)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      value: selectedDietaryPreference,
                      items: dietaryPreferences
                          .map(
                            (dietaryPreference) => DropdownMenuItem(
                              value: dietaryPreference,
                              child: Text(dietaryPreference),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDietaryPreference = value!;
                        });
                      },
                    ),
                    const Gap(25),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Allergy',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon:
                            Icon(Icons.warning, color: Color(0xFF001F3F)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      value: selectedAllergy,
                      items: allergies
                          .map(
                            (a) => DropdownMenuItem(
                              value: a,
                              child: Text(a),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAllergy = value!;
                        });
                      },
                    ),
                    const Gap(25),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          var personalDetails = PersonalDetails(
                              age: int.tryParse(age.text)!,
                              gender: selectedGender,
                              height: double.tryParse(height.text)!,
                              weight: double.tryParse(weight.text)!,
                              bmi: 25,
                              allergy: selectedAllergy,
                              dietaryPreference: selectedDietaryPreference,
                              medicalCondition: selectedMedicalCondition);

                          log(personalDetails.toString());

                          var response = await healthProfile(
                              personalDetails, widget.email, widget.password);

                          ref
                              .read(personalDetailsProvider.notifier)
                              .setPersonalDetails(personalDetails);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 120, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: const Color(0xFF31363F)),
                        child: const Text(
                          "Proceed",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

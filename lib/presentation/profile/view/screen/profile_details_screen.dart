import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/presentation/auth/model/personal_details.dart';
import 'package:mivro/presentation/auth/provider/personal_details_provider.dart';

class ProfileDetailsScreen extends ConsumerWidget {
  final Map<String, dynamic> personalDetails;

  const ProfileDetailsScreen({super.key, required this.personalDetails});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Details Summary'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.cake),
                  title: const Text('Age'),
                  subtitle: Text('${personalDetails['age']} years'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Gender'),
                  subtitle: Text(personalDetails['gender']),
                ),
                ListTile(
                  leading: const Icon(Icons.height),
                  title: const Text('Height'),
                  subtitle: Text('${personalDetails['height']} m'),
                ),
                ListTile(
                  leading: const Icon(Icons.monitor_weight),
                  title: const Text('Weight'),
                  subtitle: Text('${personalDetails['weight']} kg'),
                ),
                ListTile(
                  leading: const Icon(Icons.calculate),
                  title: const Text('BMI'),
                  subtitle: Text(personalDetails['body_mass_index'].toString()),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Health Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.medical_services),
                  title: const Text('Medical Condition'),
                  subtitle:
                      Text(personalDetails['medical_conditions'].toString()),
                ),
                ListTile(
                  leading: const Icon(Icons.warning),
                  title: const Text('Allergy'),
                  subtitle: Text(personalDetails['allergies'].toString()),
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: const Text('Dietary Preference'),
                  subtitle:
                      Text(personalDetails['dietaryPreferences'].toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

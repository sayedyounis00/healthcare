import 'package:flutter/material.dart';

class Conditions {
  final String id;
  final String name;
  final IconData icon;
  Conditions({required this.id, required this.name, required this.icon});
}

class MedicalConditionLists {
  static final  List<Conditions> chronicConditions= [
    Conditions(
      id: 'hypertension',
      name: 'Hypertension (High Blood Pressure)',
      icon: Icons.monitor_heart_outlined,
    ),
    Conditions(
      id: 'diabetes',
      name: 'Diabetes Mellitus',
      icon: Icons.water_drop_outlined,
    ),
    Conditions(
      id: 'hepatitis_c',
      name: 'Hepatitis C',
      icon: Icons.biotech_outlined,
    ),
    Conditions(
      id: 'cardiovascular',
      name: 'Cardiovascular Disease',
      icon: Icons.favorite_border,
    ),
    Conditions(
      id: 'obesity',
      name: 'Obesity',
      icon: Icons.fitness_center_outlined,
    ),
    Conditions(id: 'asthma', name: 'Asthma', icon: Icons.air_outlined),
    Conditions(
      id: 'kidney_disease',
      name: 'Chronic Kidney Disease',
      icon: Icons.health_and_safety_outlined,
    ),
    Conditions(
      id: 'arthritis',
      name: 'Arthritis',
      icon: Icons.accessibility_new_outlined,
    ),
    Conditions(
      id: 'thyroid',
      name: 'Thyroid Disorders',
      icon: Icons.psychology_outlined,
    ),
  ];
  static final List<Conditions> commonAllergies = [
  Conditions(
    id: 'dust',
    name: 'Dust Allergy',
    icon: Icons.cloud_outlined,
  ),
  Conditions(
    id: 'pollen',
    name: 'Pollen Allergy',
    icon: Icons.local_florist_outlined,
  ),
  Conditions(
    id: 'food',
    name: 'Food Allergy',
    icon: Icons.restaurant_outlined,
  ),
  Conditions(
    id: 'seafood',
    name: 'Seafood Allergy',
    icon: Icons.set_meal_outlined,
  ),
  Conditions(
    id: 'medication',
    name: 'Drug Allergy',
    icon: Icons.medication_outlined,
  ),
  Conditions(
    id: 'insect',
    name: 'Insect Sting Allergy',
    icon: Icons.bug_report_outlined,
  ),
  Conditions(
    id: 'pet_dander',
    name: 'Pet Dander Allergy',
    icon: Icons.pets_outlined,
  ),
  Conditions(
    id: 'mold',
    name: 'Mold Allergy',
    icon: Icons.grass_outlined,
  ),
  Conditions(
    id: 'latex',
    name: 'Latex Allergy',
    icon: Icons.healing_outlined,
  ),
];

}

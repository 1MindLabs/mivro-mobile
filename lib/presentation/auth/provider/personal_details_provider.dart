import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/presentation/auth/model/personal_details.dart';

class PersonalDetailsNotifier extends StateNotifier<PersonalDetails?> {
  PersonalDetailsNotifier() : super(null);

  void setPersonalDetails(PersonalDetails personalDetails) {
    state = personalDetails;
  }
}

final personalDetailsProvider =
    StateNotifierProvider<PersonalDetailsNotifier, PersonalDetails?>((ref) {
  return PersonalDetailsNotifier();
});

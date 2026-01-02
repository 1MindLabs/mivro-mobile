import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mivro/features/auth/models/personal_details.dart';

class PersonalDetailsNotifier extends Notifier<PersonalDetails?> {
  @override
  PersonalDetails? build() => null;

  void setPersonalDetails(PersonalDetails personalDetails) {
    state = personalDetails;
  }
}

final personalDetailsProvider =
    NotifierProvider<PersonalDetailsNotifier, PersonalDetails?>(
      PersonalDetailsNotifier.new,
    );

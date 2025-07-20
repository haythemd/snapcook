

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:snapcook/services/onboarding_service.dart';

part 'onboarding.g.dart';

@Riverpod(keepAlive: true)
class OnboardingService extends _$OnboardingService {

  StorageService storageService = StorageService();
  @override
  FutureOr<bool> build() async {

    bool isOnboarded  = await storageService.checkOnboardingStatus();


    return isOnboarded; // Return true if the user has completed onboarding, false otherwise.
  }

  Future<bool> toggleOnboardingStatus() async {
    // Toggle the onboarding status
    bool currentStatus = await storageService.checkOnboardingStatus();
    bool newStatus = !currentStatus;

    // Update the status in storage
    await storageService.completeOnboarding();

    state = state.whenData((d)=>newStatus);
    return newStatus;
  }

}
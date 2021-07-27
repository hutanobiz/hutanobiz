import 'package:flutter/material.dart';
import 'package:hutano/routes.dart';

import 'constants/constants.dart';
import 'constants/key_constant.dart';

void antiAgingNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeBreathingIssue, arguments: {
    ArgumentConstant.isAntiAgingKey: true,
    ArgumentConstant.isStomachKey: false,
    ArgumentConstant.isBreathingKey: false,
    ArgumentConstant.isHealthChestKey: false,
    ArgumentConstant.isNutritionKey: false
  });
}

void stomachNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeBreathingIssue, arguments: {
    ArgumentConstant.isAntiAgingKey: false,
    ArgumentConstant.isStomachKey: true,
    ArgumentConstant.isBreathingKey: false,
    ArgumentConstant.isHealthChestKey: false,
    ArgumentConstant.isNutritionKey: false
  });
}

void breathingNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeBreathingIssue, arguments: {
    ArgumentConstant.isAntiAgingKey: false,
    ArgumentConstant.isStomachKey: false,
    ArgumentConstant.isBreathingKey: true,
    ArgumentConstant.isHealthChestKey: false,
    ArgumentConstant.isNutritionKey: false
  });
}

void healthAndChestNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeBreathingIssue, arguments: {
    ArgumentConstant.isAntiAgingKey: false,
    ArgumentConstant.isStomachKey: false,
    ArgumentConstant.isBreathingKey: false,
    ArgumentConstant.isHealthChestKey: true,
    ArgumentConstant.isNutritionKey: false
  });
}

void abnormalNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: true,
    ArgumentConstant.isMaleHealthKey: false,
    ArgumentConstant.isFemaleHealthKey: false,
    ArgumentConstant.isWoundSkinKey: false,
    ArgumentConstant.isDentalCareKey: false,
    ArgumentConstant.isHearingSightKey: false
  });
}

void maleHealthNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: false,
    ArgumentConstant.isMaleHealthKey: true,
    ArgumentConstant.isFemaleHealthKey: false,
    ArgumentConstant.isWoundSkinKey: false,
    ArgumentConstant.isDentalCareKey: false,
    ArgumentConstant.isHearingSightKey: false
  });
}

void femaleHealthNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: false,
    ArgumentConstant.isMaleHealthKey: false,
    ArgumentConstant.isFemaleHealthKey: true,
    ArgumentConstant.isWoundSkinKey: false,
    ArgumentConstant.isDentalCareKey: false,
    ArgumentConstant.isHearingSightKey: false
  });
}

void woundSkinNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: false,
    ArgumentConstant.isMaleHealthKey: false,
    ArgumentConstant.isFemaleHealthKey: false,
    ArgumentConstant.isWoundSkinKey: true,
    ArgumentConstant.isDentalCareKey: false,
    ArgumentConstant.isHearingSightKey: false
  });
}

void dentalCareNavigation(BuildContext context) {
  Navigator.pushNamed(context, Routes.routeAbnormal, arguments: {
    ArgumentConstant.isAbnormalKey: false,
    ArgumentConstant.isMaleHealthKey: false,
    ArgumentConstant.isFemaleHealthKey: false,
    ArgumentConstant.isWoundSkinKey: false,
    ArgumentConstant.isDentalCareKey: true,
    ArgumentConstant.isHearingSightKey: false
  });
}

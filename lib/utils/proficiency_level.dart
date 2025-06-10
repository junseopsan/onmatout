enum ProficiencyLevel {
  beginner,
  intermediate,
  advanced,
  expert;

  static ProficiencyLevel fromInt(int? value) {
    switch (value) {
      case 0:
        return ProficiencyLevel.beginner;
      case 1:
        return ProficiencyLevel.intermediate;
      case 2:
        return ProficiencyLevel.advanced;
      case 3:
        return ProficiencyLevel.expert;
      default:
        return ProficiencyLevel.beginner;
    }
  }

  String get koreanName {
    switch (this) {
      case ProficiencyLevel.beginner:
        return '초급';
      case ProficiencyLevel.intermediate:
        return '중급';
      case ProficiencyLevel.advanced:
        return '고급';
      case ProficiencyLevel.expert:
        return '전문가';
    }
  }
} 
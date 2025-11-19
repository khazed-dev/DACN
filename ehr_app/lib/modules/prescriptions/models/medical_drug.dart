class MedicalDrug {
  final String name;          // Tên thuốc
  final String dosage;        // Hàm lượng, ví dụ: 500mg
  final String instructions;  // Hướng dẫn dùng: "Sáng 1 viên"
  final int duration;         // Số ngày dùng
  final bool morning;         // Uống buổi sáng
  final bool noon;            // Uống buổi trưa
  final bool evening;         // Uống buổi tối

  MedicalDrug({
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.duration,
    required this.morning,
    required this.noon,
    required this.evening,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'instructions': instructions,
      'duration': duration,
      'morning': morning,
      'noon': noon,
      'evening': evening,
    };
  }

  // From Map
  factory MedicalDrug.fromMap(Map<String, dynamic> map) {
    return MedicalDrug(
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      instructions: map['instructions'] ?? '',
      duration: map['duration'] ?? 0,
      morning: map['morning'] ?? false,
      noon: map['noon'] ?? false,
      evening: map['evening'] ?? false,
    );
  }

  // CopyWith
  MedicalDrug copyWith({
    String? name,
    String? dosage,
    String? instructions,
    int? duration,
    bool? morning,
    bool? noon,
    bool? evening,
  }) {
    return MedicalDrug(
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      instructions: instructions ?? this.instructions,
      duration: duration ?? this.duration,
      morning: morning ?? this.morning,
      noon: noon ?? this.noon,
      evening: evening ?? this.evening,
    );
  }
}

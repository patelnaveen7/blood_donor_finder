/// A single blood donor record stored entirely on-device.
class Donor {
  final String id;
  final String name;
  final String bloodGroup;
  final String phone;
  final String city;
  final String? notes;
  final DateTime createdAt;

  Donor({
    required this.id,
    required this.name,
    required this.bloodGroup,
    required this.phone,
    required this.city,
    this.notes,
    required this.createdAt,
  });

  Donor copyWith({
    String? name,
    String? bloodGroup,
    String? phone,
    String? city,
    String? notes,
  }) {
    return Donor(
      id: id,
      name: name ?? this.name,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bloodGroup': bloodGroup,
        'phone': phone,
        'city': city,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Donor.fromJson(Map<String, dynamic> json) => Donor(
        id: json['id'] as String,
        name: json['name'] as String,
        bloodGroup: json['bloodGroup'] as String,
        phone: json['phone'] as String,
        city: json['city'] as String,
        notes: json['notes'] as String?,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

/// Standard blood group options used throughout the app's forms and filters.
const List<String> kBloodGroups = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

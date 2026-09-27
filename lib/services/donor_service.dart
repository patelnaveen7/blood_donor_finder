import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/donor.dart';

/// Handles all persistence for donor records using SharedPreferences.
///
/// No Firebase, no SQL, no network calls — every donor record lives only
/// on this device, serialized as a JSON list under a single string key.
class DonorService {
  static const String _storageKey = 'blood_donor_finder.donors';

  /// Returns every stored donor, newest first.
  Future<List<Donor>> getAllDonors() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      final donors = decoded
          .map((item) => Donor.fromJson(item as Map<String, dynamic>))
          .toList();
      donors.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return donors;
    } catch (_) {
      // Corrupt or unexpected data — fail safe with an empty list rather
      // than crashing the app.
      return [];
    }
  }

  /// Persists a new donor record.
  Future<void> addDonor(Donor donor) async {
    final donors = await getAllDonors();
    donors.add(donor);
    await _saveAll(donors);
  }

  /// Updates an existing donor record by id.
  Future<void> updateDonor(Donor updated) async {
    final donors = await getAllDonors();
    final index = donors.indexWhere((d) => d.id == updated.id);
    if (index != -1) {
      donors[index] = updated;
      await _saveAll(donors);
    }
  }

  /// Deletes a donor record by id.
  Future<void> deleteDonor(String id) async {
    final donors = await getAllDonors();
    donors.removeWhere((d) => d.id == id);
    await _saveAll(donors);
  }

  /// Searches donors by blood group (exact match, optional) and/or a
  /// case-insensitive substring match on city.
  Future<List<Donor>> search({String? bloodGroup, String? city}) async {
    final donors = await getAllDonors();
    return donors.where((donor) {
      final matchesGroup = bloodGroup == null ||
          bloodGroup.isEmpty ||
          donor.bloodGroup == bloodGroup;
      final matchesCity = city == null ||
          city.trim().isEmpty ||
          donor.city.toLowerCase().contains(city.trim().toLowerCase());
      return matchesGroup && matchesCity;
    }).toList();
  }

  Future<void> _saveAll(List<Donor> donors) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(donors.map((d) => d.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }
}

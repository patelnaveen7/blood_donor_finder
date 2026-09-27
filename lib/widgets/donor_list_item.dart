import 'package:flutter/material.dart';

import '../models/donor.dart';

class DonorListItem extends StatelessWidget {
  final Donor donor;
  final VoidCallback onTap;

  const DonorListItem({
    super.key,
    required this.donor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          child: Text(
            donor.bloodGroup,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(donor.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(donor.city),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

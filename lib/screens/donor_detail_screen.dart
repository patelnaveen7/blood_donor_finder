import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/donor.dart';
import '../services/donor_service.dart';

class DonorDetailScreen extends StatefulWidget {
  final Donor donor;

  const DonorDetailScreen({super.key, required this.donor});

  @override
  State<DonorDetailScreen> createState() => _DonorDetailScreenState();
}

class _DonorDetailScreenState extends State<DonorDetailScreen> {
  final DonorService _service = DonorService();
  bool _deleting = false;

  Future<void> _callDonor() async {
    final uri = Uri(scheme: 'tel', path: widget.donor.phone);
    final launched = await launchUrl(uri);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the phone dialer')),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete donor?'),
        content: Text(
          'This will permanently remove ${widget.donor.name} from your device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _deleting = true);
      await _service.deleteDonor(widget.donor.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final donor = widget.donor;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Details'),
        actions: [
          IconButton(
            tooltip: 'Delete donor',
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleting ? null : _confirmDelete,
          ),
        ],
      ),
      body: _deleting
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: scheme.primaryContainer,
                    child: Text(
                      donor.bloodGroup,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    donor.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                _infoTile(Icons.bloodtype_outlined, 'Blood group', donor.bloodGroup),
                _infoTile(Icons.location_on_outlined, 'City / location', donor.city),
                _infoTile(Icons.phone_outlined, 'Phone number', donor.phone),
                if (donor.notes != null && donor.notes!.isNotEmpty)
                  _infoTile(Icons.notes_outlined, 'Notes', donor.notes!),
                _infoTile(
                  Icons.event_outlined,
                  'Registered on',
                  _formatDate(donor.createdAt),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _callDonor,
                  icon: const Icon(Icons.call),
                  label: const Text('Call Donor'),
                ),
              ],
            ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label, style: const TextStyle(fontSize: 12)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

import 'package:flutter/material.dart';

import '../models/donor.dart';
import '../services/donor_service.dart';
import '../widgets/donor_list_item.dart';
import 'donor_detail_screen.dart';
import 'register_donor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DonorService _service = DonorService();
  final TextEditingController _cityController = TextEditingController();

  List<Donor> _donors = [];
  bool _loading = true;
  String? _selectedGroup; // null = any blood group

  @override
  void initState() {
    super.initState();
    _loadDonors();
    _cityController.addListener(_loadDonors);
  }

  @override
  void dispose() {
    _cityController.removeListener(_loadDonors);
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _loadDonors() async {
    setState(() => _loading = true);
    final results = await _service.search(
      bloodGroup: _selectedGroup,
      city: _cityController.text,
    );
    if (!mounted) return;
    setState(() {
      _donors = results;
      _loading = false;
    });
  }

  Future<void> _openRegisterScreen() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const RegisterDonorScreen()),
    );
    if (added == true) {
      _loadDonors();
    }
  }

  Future<void> _openDetailScreen(Donor donor) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => DonorDetailScreen(donor: donor)),
    );
    if (changed == true) {
      _loadDonors();
    }
  }

  void _clearFilters() {
    setState(() => _selectedGroup = null);
    _cityController.clear();
    _loadDonors();
  }

  @override
  Widget build(BuildContext context) {
    final hasFilters = _selectedGroup != null || _cityController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Donor Finder'),
        actions: [
          if (hasFilters)
            IconButton(
              tooltip: 'Clear filters',
              icon: const Icon(Icons.filter_alt_off),
              onPressed: _clearFilters,
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          const Divider(height: 1),
          Expanded(child: _buildDonorList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRegisterScreen,
        icon: const Icon(Icons.person_add),
        label: const Text('Add Donor'),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Column(
        children: [
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'Search by city / location',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _groupChip(null, 'All groups'),
                for (final group in kBloodGroups) _groupChip(group, group),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupChip(String? group, String label) {
    final selected = _selectedGroup == group;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          setState(() => _selectedGroup = group);
          _loadDonors();
        },
      ),
    );
  }

  Widget _buildDonorList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_donors.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bloodtype_outlined,
                  size: 56, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12),
              Text(
                _donors.isEmpty && !_loading
                    ? 'No donors found.\nTap "Add Donor" to register one.'
                    : '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDonors,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 88, top: 4),
        itemCount: _donors.length,
        itemBuilder: (context, index) {
          final donor = _donors[index];
          return DonorListItem(
            donor: donor,
            onTap: () => _openDetailScreen(donor),
          );
        },
      ),
    );
  }
}

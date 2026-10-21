import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/company.dart';
import '../providers/company_provider.dart';
import 'create_company_screen.dart';
import 'create_service_screen.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CompanyProvider>().fetchCompanies();
    });
  }

  Future<void> _refreshCompanies() async {
    await context.read<CompanyProvider>().fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Management'),
        actions: [
          IconButton(
            tooltip: 'Refresh companies',
            onPressed: _refreshCompanies,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(provider),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'create_service',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateServiceScreen()),
              );
            },
            icon: const Icon(Icons.add_business),
            label: const Text('Add Service'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'create_company',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateCompanyScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Company'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(CompanyProvider provider) {
    if (provider.isLoading && provider.companies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.companies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48),
              const SizedBox(height: 12),
              Text(
                'Could not load companies.\n${provider.errorMessage}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _refreshCompanies,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.companies.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshCompanies,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 140),
            Icon(Icons.business_outlined, size: 56),
            SizedBox(height: 16),
            Center(child: Text('No companies found.')),
            SizedBox(height: 8),
            Center(child: Text('Add a company to get started.')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshCompanies,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: provider.companies.length,
        itemBuilder: (context, index) {
          final company = provider.companies[index];

          return CompanyCard(company: company);
        },
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final Company company;

  const CompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(child: Icon(Icons.business)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Registration No: '
                        '${company.registrationNumber}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 28),
            Text(
              'Services (${company.services.length})',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            if (company.services.isEmpty)
              const Text(
                'No services added yet.',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...company.services.map(
                (service) => ServiceTile(service: service),
              ),
          ],
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final Service service;

  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.miscellaneous_services),
      title: Text(service.name),
      subtitle: Text(service.description),
      trailing: Text(
        'RM ${service.price}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

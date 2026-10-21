import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/company.dart';
import '../providers/company_provider.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  int? _selectedCompanyId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CompanyProvider>().fetchCompanies();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCompanyId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a company.')));
      return;
    }

    final price = double.tryParse(_priceController.text.trim());

    if (price == null || !price.isFinite || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid non-negative price.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await context.read<CompanyProvider>().createService(
        companyId: _selectedCompanyId!,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service created successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      final message = error.toString().replaceFirst('Exception: ', '');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyProvider>();
    final companies = provider.companies;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Service')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.miscellaneous_services, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Service Information',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  // Company selector
                  DropdownButtonFormField<int>(
                    initialValue:
                        companies.any(
                          (company) => company.id == _selectedCompanyId,
                        )
                        ? _selectedCompanyId
                        : null,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Company',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(),
                    ),
                    hint: Text(
                      provider.isLoading
                          ? 'Loading companies...'
                          : 'Select a company',
                    ),
                    items: companies.map((Company company) {
                      return DropdownMenuItem<int>(
                        value: company.id,
                        child: Text(
                          '${company.name} '
                          '(${company.registrationNumber})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _selectedCompanyId = value;
                            });
                          },
                    validator: (_) {
                      if (_selectedCompanyId == null ||
                          !companies.any(
                            (company) => company.id == _selectedCompanyId,
                          )) {
                        return 'Please select a company';
                      }
                      return null;
                    },
                  ),

                  if (!provider.isLoading && companies.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        provider.errorMessage ??
                            'No companies found. Create a company first.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Service name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Service Name',
                      hintText: 'e.g. Website Development',
                      prefixIcon: Icon(Icons.build_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Service name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe the service',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    minLines: 3,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Price
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Price (RM)',
                      hintText: 'e.g. 1500.00',
                      prefixIcon: Icon(Icons.payments_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Price is required';
                      }

                      final price = double.tryParse(value.trim());

                      if (price == null || !price.isFinite || price < 0) {
                        return 'Enter a valid non-negative number';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  FilledButton.icon(
                    onPressed: _isSubmitting || companies.isEmpty
                        ? null
                        : _submitForm,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _isSubmitting ? 'Creating...' : 'Create Service',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

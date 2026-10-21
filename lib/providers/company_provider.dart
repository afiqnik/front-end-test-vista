import 'package:flutter/foundation.dart';

import '../models/company.dart';
import '../services/api_service.dart';

class CompanyProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Company> _companies = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCompanies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _companies = await _apiService.getCompanies();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCompany({
    required String name,
    required String registrationNumber,
  }) async {
    await _apiService.createCompany(
      name: name,
      registrationNumber: registrationNumber,
    );

    await fetchCompanies();
  }

  Future<void> createService({
    required int companyId,
    required String name,
    required String description,
    required double price,
  }) async {
    await _apiService.createService(
      companyId: companyId,
      name: name,
      description: description,
      price: price,
    );

    await fetchCompanies();
  }
}

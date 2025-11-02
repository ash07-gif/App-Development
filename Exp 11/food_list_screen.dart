import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// -------- MODEL --------
class Meal {
  final String id;
  final String name;
  final String category;
  final String area;
  final String thumbnail;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.thumbnail,
  });

  factory Meal.fromJson(Map<String, dynamic> j) => Meal(
    id: j['idMeal'] ?? '',
    name: j['strMeal'] ?? '',
    category: j['strCategory'] ?? 'Unknown',
    area: j['strArea'] ?? 'Unknown',
    thumbnail: j['strMealThumb'] ?? '',
  );
}

// -------- API SERVICE --------
class FoodApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/search.php?f=a';

  Future<List<Meal>> fetchMeals() async {
    final response = await http.get(Uri.parse(_baseUrl)).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List? mealsList = data['meals'];
      if (mealsList == null) return [];
      return mealsList.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch meals. Status: ${response.statusCode}');
    }
  }
}

// -------- SCREEN --------
enum ViewState { loading, loaded, empty, error }

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final FoodApiService _api = FoodApiService();
  ViewState _state = ViewState.loading;
  List<Meal> _meals = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() {
      _state = ViewState.loading;
      _error = null;
    });

    try {
      final meals = await _api.fetchMeals();
      if (mounted) {
        setState(() {
          _meals = meals;
          _state = meals.isEmpty ? ViewState.empty : ViewState.loaded;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _state = ViewState.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🍽️ Delicious Meals')),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.empty:
        return const Center(child: Text('No meals found.'));
      case ViewState.error:
        return _buildError();
      case ViewState.loaded:
        return _buildList();
    }
  }

  Widget _buildError() => Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(_error ?? 'Unknown error'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadMeals,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    ),
  );

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: _loadMeals,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _meals.length,
        itemBuilder: (context, index) {
          final meal = _meals[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  meal.thumbnail,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(Icons.bento, size: 28),
                  ),
                ),
              ),
              title: Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${meal.category} • ${meal.area}'),
              onTap: () => _showDetails(meal),
            ),
          );
        },
      ),
    );
  }

  void _showDetails(Meal meal) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(meal.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(meal.thumbnail, width: 150, errorBuilder: (c,e,s) => const SizedBox()),
            const SizedBox(height: 12),
            Text('Category: ${meal.category}\nOrigin: ${meal.area}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/showstoredata.dart';
import 'package:small_stores_test/style.dart';
import 'apiService/api_service.dart';
import 'apiService/store_api.dart';
import 'apiService/class_api.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'models/classmodel.dart';
import 'variables.dart';

class Home extends StatefulWidget {
  final User user;

  Home({Key? key, required this.user}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<StoreModel>> futureStores;
  late Future<List<ClassModel>> futureCategories;

  List<StoreModel> allStores = [];
  List<StoreModel> filteredStores = [];
  List<ClassModel> categories = [];

  int? selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    futureStores = StoreApi(apiService: ApiService(client: http.Client())).getStores();
    futureCategories = ClassApi(apiService: ApiService(client: http.Client())).getClasses();

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      allStores = await futureStores;
      categories = await futureCategories;
      filteredStores = List.from(allStores);
    } catch (e) {
      print('${a_error_loading_data}: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      filteredStores = allStores.where((store) {
        final matchesSearch = store.store_name.toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesCategory =
            selectedCategoryId == null || store.class_id == selectedCategoryId;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  // دالة للحصول على اسم الصنف المترجم
  String _getTranslatedCategoryName(ClassModel category) {
    return translateCategoryName({
      'class_name': category.class_name,
      'class_name_english': category.class_name_english,
    });
  }

  // عدل دالة العنوان الحالي
  String _currentTitle() {
    if (selectedCategoryId == null) return a_all_stores;
    final found = categories.where((c) => c.id == selectedCategoryId).toList();
    return found.isNotEmpty ? _getTranslatedCategoryName(found.first) : a_all_stores;
  }

  // عدل دالة الأيقونة
  IconData _getCategoryIcon(ClassModel category) {
    final translatedName = _getTranslatedCategoryName(category);

    // استخدم الأسماء الإنجليزية للأيقونات (أو العربية)
    if (language_app == "ar") {
      switch (category.class_name) {
        case 'زينة حفلات': return Icons.celebration;
        case 'برمجة': return Icons.code;
        case 'ملبوسات': return Icons.checkroom;
        case 'أحذية': return Icons.directions_walk;
        case 'أعمال يدوية': return Icons.handyman;
        case 'غذائيات': return Icons.fastfood;
        case 'أدوات منزلية': return Icons.kitchen;
        case 'منظفات': return Icons.cleaning_services;
        case 'قرطاسية': return Icons.edit;
        case 'اكسسوارات': return Icons.watch;
        case 'مستحضرات تجميل': return Icons.brush;
        case 'تصميم': return Icons.design_services;
        case 'غير ذلك': return Icons.more_horiz;
        default: return Icons.category;
      }
    } else {
      switch (category.class_name_english?.toLowerCase()) {
        case 'party decorations': return Icons.celebration;
        case 'programming': return Icons.code;
        case 'clothing': return Icons.checkroom;
        case 'shoes': return Icons.directions_walk;
        case 'handicrafts': return Icons.handyman;
        case 'nutrition': return Icons.fastfood;
        case 'household tools': return Icons.kitchen;
        case 'detergents': return Icons.cleaning_services;
        case 'stationery': return Icons.edit;
        case 'accessories': return Icons.watch;
        case 'cosmetics': return Icons.brush;
        case 'design': return Icons.design_services;
        case 'otherwise': return Icons.more_horiz;
        default: return Icons.category;
      }
    }
  }

  String _getImageUrl(String url) {
    if (url.isEmpty) return '';
    if (!url.startsWith('http')) {
      return ApiService.baseUrlImg + url.split('/storage/').last;
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 4 : (screenWidth > 800 ? 3 : 2);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // حقل البحث
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: a_store_name_s,
                  suffixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) => _applyFilters(),
              ),
              SizedBox(height: 16),

              // أزرار الفئات
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // زر عرض الكل
                    _buildCategoryButton(
                      icon: Icons.all_inclusive,
                      isSelected: selectedCategoryId == null,
                      onTap: () {
                        setState(() {
                          selectedCategoryId = null;
                          _applyFilters();
                        });
                      },
                    ),
                    for (var category in categories)
                      _buildCategoryButton(
                        category: category,
                        isSelected: selectedCategoryId == category.id,
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category.id;
                            _applyFilters();
                          });
                        },
                      ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // العنوان الرئيسي
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _currentTitle(),
                    style: style_text_titel,
                  ),
                ),
              ),

              SizedBox(height: 16),

              // شبكة المتاجر
              Expanded(
                child: _isLoading
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(a_loading_data),
                    ],
                  ),
                )
                    : allStores.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store_mall_directory, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(a_no_stores_available),
                    ],
                  ),
                )
                    : filteredStores.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(my_stores_not_found),
                    ],
                  ),
                )
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: filteredStores.length,
                  itemBuilder: (context, index) {
                    final store = filteredStores[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowStoreData(
                                store: store, user: widget.user),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    _getImageUrl(store.store_photo),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store.store_name,
                                      style: style_text_normal_w.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            store.store_place,
                                            style: style_text_normal_w.copyWith(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء أزرار الفئات
  Widget _buildCategoryButton({
    ClassModel? category,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : color_main,
            border: Border.all(
              color: color_main,
              width: isSelected ? 2 : 0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: icon != null
              ? Icon(
            icon,
            color: isSelected ? color_main : Colors.white,
          )
              : Icon(
            _getCategoryIcon(category!),
            color: isSelected ? color_main : Colors.white,
          ),
        ),
      ),
    );
  }
}
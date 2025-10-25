import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/showproductcommentdata.dart';

import 'apiService/api_service.dart';
import 'apiService/favorit_api.dart';
import 'apiService/product_api.dart';
import 'apiService/store_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/favoritemodel.dart';
import 'models/productmodel.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class Favorite extends StatefulWidget {
  final User user;

  Favorite({Key? key, required this.user}) : super(key: key);

  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _favoriteProducts = [];
  List<Map<String, dynamic>> _filteredFavorites = [];
  bool _isLoading = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      final favoritApi = FavoritApi(apiService: ApiService(client: http.Client()));
      final productApi = ProductApi(apiService: ApiService(client: http.Client()));
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));

      final user_id = widget.user.id;
      final favorites = await favoritApi.getFavorits(user_id);

      final List<Map<String, dynamic>> products = [];
      for (var fav in favorites) {
        final product = await productApi.getProduct(fav.product_id);
        final store = await storeApi.getStore(product.store_id); // جلب معلومات المتجر

        products.add({
          'product': product,
          'favorite': fav,
          'store': store, // إضافة المتجر هنا
        });
      }

      setState(() {
        _favoriteProducts = products;
        _filteredFavorites = List.from(products);
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ في جلب المفضلات: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilter(String query) {
    setState(() {
      _filteredFavorites = _favoriteProducts.where((item) {
        final product = item['product'] as ProductModel;
        return product.product_name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // دالة إصلاح روابط الصور
  String _getImageUrl(String url) {
    if (url.isEmpty) return '${ApiService.baseUrlImg}default_product.png';

    // إذا كان الرابط يحتوي على baseUrlImg مكرر
    if (url.contains('${ApiService.baseUrlImg}${ApiService.baseUrlImg}')) {
      return url.replaceAll('${ApiService.baseUrlImg}${ApiService.baseUrlImg}', ApiService.baseUrlImg);
    }

    // إذا كان الرابط يحتوي على storage مكرر
    if (url.contains('storage/storage/')) {
      return url.replaceAll('storage/storage/', 'storage/');
    }

    // إذا كان الرابط يبدأ بـ /storage
    if (url.startsWith('/storage/')) {
      return '${ApiService.baseUrlImg}${url.substring(1)}';
    }

    // إذا كان الرابط يبدأ بـ storage/ بدون /
    if (url.startsWith('storage/')) {
      return '${ApiService.baseUrlImg}$url';
    }

    // إذا كان الرابط كاملًا
    if (url.startsWith('http')) {
      return url;
    }

    // إذا لم يكن أي من الحالات السابقة
    return '${ApiService.baseUrlImg}$url';
  }

  // دالة لتحديد عدد الأعمدة بناءً على حجم الشاشة
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth > 600 ? 24.0 : 16.0),
              child: Column(
                children: [
                  // حقل البحث
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: a_product_name_s,
                        suffixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: constraints.maxWidth > 600 ? 16.0 : 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      onChanged: _applyFilter,
                    ),
                  ),

                  SizedBox(height: constraints.maxWidth > 600 ? 24.0 : 16.0),

                  // العنوان الرئيسي
                  Padding(
                    padding: EdgeInsets.all(constraints.maxWidth > 600 ? 16.0 : 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        a_favort_s,
                        style: style_text_titel.copyWith(
                          fontSize: constraints.maxWidth > 600 ? 24.0 : 20.0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: constraints.maxWidth > 600 ? 24.0 : 16.0),

                  // شبكة المنتجات المفضلة
                  Expanded(
                    child: _isLoading
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(color_main),
                            strokeWidth: 4.0,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '$a_loading_data...',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                        : _filteredFavorites.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            _searchController.text.isEmpty
                                ? '$a_no_favorites_message'
                                : '$a_no_favorites_message',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          if (_searchController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _applyFilter('');
                                },
                                child: Text(
                                  'إعادة تعيين البحث',
                                  style: TextStyle(color: color_main),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                        : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(context),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final item = _filteredFavorites[index];
                        final product = item['product'] as ProductModel;
                        final favorite = item['favorite'] as Favorit;
                        final store = item['store'] as StoreModel;

                        // استخدام دالة إصلاح الصور
                        final String productImage = _getImageUrl(product.product_photo_1);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowProductCommentData(
                                  product: product,
                                  user: widget.user,
                                  store: store,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                // صورة المنتج مع معالجة الأخطاء
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(productImage),
                                      fit: BoxFit.cover,
                                      /*errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.grey[300],
                                          ),
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey[500],
                                          ),
                                        );
                                      },*/
                                    ),
                                  ),
                                ),

                                // طبقة تدرج لوني
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),

                                // معلومات المنتج
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // اسم المنتج
                                      Text(
                                        product.product_name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                     /* // اسم المتجر
                                      Text(
                                        store.store_name,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
*/
                                      // سعر المنتج
                                      Text(
                                        '${product.product_price} \$',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                               /* // أيقونة المفضلة
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
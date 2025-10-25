import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../apiService/api_service.dart';
import '../apiService/favorit_api.dart';
import 'apiService/product_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/favoritemodel.dart';
import 'models/productmodel.dart';
import 'models/usermodel.dart';
import 'product.dart';
import 'style.dart';
import 'variables.dart';

class ShowProFav extends StatefulWidget {
  final int product_id;
  final User user;

  ShowProFav({required this.product_id, required this.user});

  @override
  _ShowProFav createState() => _ShowProFav();
}

class _ShowProFav extends State<ShowProFav> {
  ProductModel? _product;
  Favorit? _existingFavorite;
  bool _isLoading = true;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProductAndFavorite();
    _loadLikesCount();
  }

  // دالة واحدة تجلب كل شيء: المنتج + حالة المفضلة + عدد المعجبين
  Future<void> _loadProductAndFavorite() async {
    try {
      final favoritApi = FavoritApi(apiService: ApiService(client: http.Client()));
      final productApi = ProductApi(apiService: ApiService(client: http.Client()));

      // جلب المنتج
      final product = await productApi.getProduct(widget.product_id);

      // جلب كل مفضلات المستخدم
      List<Favorit> favorites = [];
      try {
        favorites = await favoritApi.getFavoritsAll(widget.user.id);
      } catch (e) {
        print(' Warning: Could not load favorites: $e');
        favorites = [];
      }

      //  البحث عن المنتج في المفضلات
      Favorit? existingFavorite;
      for (var fav in favorites) {
        if (fav.product_id == widget.product_id) {
          existingFavorite = fav;
          break;
        }
      }

      setState(() {
        _product = product;
        _existingFavorite = existingFavorite;
        _isLoading = false;
      });

      print(' ${a_product_loaded}: ${product.product_name}');
      print(' ${a_favorites_loaded}: ${favorites.length}');
      print(' ${a_favorite_state}: $_existingFavorite');
      if (_existingFavorite != null) {
        print(' Favorite state: ${_existingFavorite!.state}');
      }

    } catch (e) {
      print(' Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLikesCount() async {
    try {
      final favoritApi = FavoritApi(apiService: ApiService(client: http.Client()));
      final count = await favoritApi.getProductLikesCount(widget.product_id);
      setState(() {
        _likesCount = count;
      });
    } catch (e) {
      print('Error loading likes count: $e');
    }
  }

  Future<void> _updateLikesCount() async {
    try {
      final favoritApi = FavoritApi(apiService: ApiService(client: http.Client()));
      final count = await favoritApi.getProductLikesCount(widget.product_id);
      setState(() {
        _likesCount = count;
      });
    } catch (e) {
      print('Error updating likes count: $e');
    }
  }



  // الدالة الرئيسية للتعامل مع المفضلة
  Future<void> _handleFavorite() async {
    try {
      final favoritApi = FavoritApi(apiService: ApiService(client: http.Client()));

      if (_existingFavorite != null) {
        // العنصر موجود - نغير حالته
        final newState = _existingFavorite!.state == 1 ? 0 : 1;

        print(' Updating existing favorite ${_existingFavorite!.id} to state: $newState');

        await favoritApi.updateFavorit(_existingFavorite!.id, Favorit(
          id: _existingFavorite!.id,
          user_id: widget.user.id,
          product_id: widget.product_id,
          state: newState,
        ));

        setState(() {
          _existingFavorite = Favorit(
            id: _existingFavorite!.id,
            user_id: widget.user.id,
            product_id: widget.product_id,
            state: newState,
          );
        });
      } else {
        // العنصر غير موجود: نحاول الإضافة
        print(' Adding new favorite');
        try {
          final newFavorite = await favoritApi.addFavorit(
            user_id: widget.user.id,
            product_id: widget.product_id,
          );
          setState(() {
            _existingFavorite = newFavorite;
          });
        } catch (e) {
          // إذا كان الخطأ 409 (المنتج مضاف مسبقاً)، نعيد تحميل المفضلات
          if (e.toString().contains('409') || e.toString().contains('مضاف مسبقاً')) {
            print(' Product already exists, reloading favorites...');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(a_product_added_already)),
            );
            await _loadProductAndFavorite(); // إعادة تحميل المفضلات
          } else {
            rethrow;
          }
        }
      }

      // تحديث عدد المعجبين بعد أي عملية
      await _updateLikesCount();

    } catch (e) {
      print(' Error in _handleFavorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$a_error_occurred: ${e.toString()}')),
      );
    }
  }

  // تحديد لون الزر حسب الحالة
  Color _getButtonColor() {
    if (_existingFavorite == null) return color_main; // جديد - لون أساسي
    return _existingFavorite!.state == 1 ? Colors.white : color_main;
  }

  // تحديد لون الأيقونة حسب الحالة
  Color _getIconColor() {
    if (_existingFavorite == null) return Colors.white; // جديد - أيقونة بيضاء
    return _existingFavorite!.state == 1 ? color_main : Colors.white;
  }

  // تحديد نص الزر حسب الحالة
  String _getActionText() {
    if (_existingFavorite == null) return a_add_to_favorite;
    return _existingFavorite!.state == 1 ? a_remove_from_favorite : a_readd_to_favorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: Stack(
        children: [
          if (_product != null)
            ProductBody(
              product_id: widget.product_id,
              onProductLoaded: (product) {},
              likesCount: _likesCount, user: widget.user,
            ),
          if (_isLoading)
            Center(child: CircularProgressIndicator()), // مع نص تحميل إذا بدك
        ],
      ),
      floatingActionButton: _isLoading
          ? SizedBox()
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر الإجراء الرئيسي
          FloatingActionButton(
            onPressed: _handleFavorite,
            backgroundColor: _getButtonColor(),
            child: Icon(Icons.favorite, color: _getIconColor(), size: 28),
          ),
          /* SizedBox(height: 8),
          // نص توضيحي
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              _getActionText(),
              style: TextStyle(
                color: color_main,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:small_stores_test/editproduct.dart';
import 'package:small_stores_test/showstoredata.dart';
import 'apiService/api_service.dart';
import 'apiService/favorit_api.dart';
import 'apiService/product_api.dart';
import 'apiService/store_api.dart';
import 'apiService/type_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/productmodel.dart';
import 'models/usermodel.dart';
import 'store.dart';
import 'style.dart';
import 'variables.dart';

class Product extends StatefulWidget {
  final int product_id;
  final int class_id;
  final User user;

  const Product({
    Key? key,
    required this.product_id,
    required this.user,
    required this.class_id,
  }) : super(key: key);

  @override
  _Product createState() => _Product();
}

class _Product extends State<Product> {
  ProductModel? _product;
  bool showOptions = false;

  // دالة لعرض تأكيد الحذف بخطوتين
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    // الخطوة الأولى: تأكيد الحذف
    bool firstConfirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('$a_confirm_delete_l',style: style_text_titel,),
        content: Text('$delete_product_q_l'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('$a_cancel',style: style_text_button_normal_2(color_Secondary),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('$a_yes', style: style_text_button_normal_red),
          ),
        ],
      ),
    );

    if (firstConfirm == true) {
      // الخطوة الثانية: التأكيد النهائي
      bool finalConfirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('$a_confirm_end_l',style: style_text_titel,),
          content: Text('$delete_product_end_l'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('$a_cancel',style: style_text_button_normal_2(color_Secondary),),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('$a_confirm', style: style_text_button_normal_red),
            ),
          ],
        ),
      );

      if (finalConfirm == true) {
        _deleteProduct();
      }
    }
  }

  // دالة حذف المنتج
  Future<void> _deleteProduct() async {
    try {
      final productApi = ProductApi(apiService: ApiService(client: http.Client()));
      await productApi.deleteProduct(_product!.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$delete_product_m')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error_delete_product_m: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: SingleChildScrollView(
        child: Center(
          child: ProductBody(
            product_id: widget.product_id,
            onProductLoaded: (product) {
              setState(() {
                _product = product;
              });
            },
            canEditAvailability: true,
            user: widget.user,
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_product != null && showOptions) ...[
            FloatingActionButton(
              //heroTag: "editBtn",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProduct(
                      product: _product!,
                      user: widget.user,
                      class_id: widget.class_id,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.edit, color: color_main),
            ),
            SizedBox(height: 10),

            FloatingActionButton(
              //heroTag: "deleteBtn",
              onPressed: () {
                setState(() {
                  showOptions = false;
                });
                _showDeleteConfirmation(context);
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.delete, color: Colors.red),
            ),
            SizedBox(height: 10),
          ],

          FloatingActionButton(
            //heroTag: "moreBtn",
            onPressed: () {
              setState(() {
                showOptions = !showOptions;
              });
            },
            backgroundColor: color_main,
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ProductBody extends StatefulWidget {
  final int product_id;
  final Function(ProductModel)? onProductLoaded;
  final bool canEditAvailability;
  final int likesCount;
  final Function? onFavoriteChanged;
  final User user;

  ProductBody({
    required this.product_id,
    this.onProductLoaded,
    this.canEditAvailability = false,
    this.likesCount = 0,
    this.onFavoriteChanged,
    required this.user,
  });

  @override
  _ProductBody createState() => _ProductBody();
}

class _ProductBody extends State<ProductBody> {

  late ProductModel _product;
  late String _typeName = '';
  late String _storeName = '';
  late String _storePhoto = '';
  bool _isLoading = true;
  int _productAvailable = 0;
  int _likesCount = 0;

  final ProductApi _productApi = ProductApi(apiService: ApiService(client: http.Client()));

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  String _getImageUrl(String url) {
    if (url.isEmpty) return '';

    if (url.contains('storage/')) {
      if (url.startsWith('http')) {
        return url;
      } else {
        String cleanUrl = url.startsWith('/') ? url.substring(1) : url;
        return '${ApiService.baseUrl}/storage/$cleanUrl';
      }
    }

    return url;
  }

  void shareProduct(int productId, String productName) {

    // 2. دمج رابط صفحة الهبوط مع ID المنتج
    final String shareLink = "${ApiService.ip_server}/product-share?id=${widget.product_id}";

    final String message =
        'شاهد هذا المنتج المميز: $productName\n'
        'لمشاهدة التفاصيل وحفظه في المفضلة، حمل تطبيقنا الآن!\n'
        '$shareLink'; // هذا هو الرابط الذي سيتم مشاركته

    Share.share(message); // استخدام حزمة share_plus
  }

  Future<void> fetchProduct() async {
    try {
      final productApi = ProductApi(apiService: ApiService(client: http.Client()));
      final typeApi = TypeApi(apiService: ApiService(client: http.Client()));
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
      final favoritApi = FavoritApi(apiService: ApiService(client: http.Client())); // ✅ أضف هذا

      final fetchedProduct = await productApi.getProduct(widget.product_id);
      final fetchedType = await typeApi.getType(fetchedProduct.type_id);
      final fetchedStore = await storeApi.getStore(fetchedProduct.store_id);
      final likesCount = await favoritApi.getProductLikesCount(fetchedProduct.id); // ✅ جلب عدد المفضلات

      if (widget.onProductLoaded != null) {
        widget.onProductLoaded!(fetchedProduct);
      }

      setState(() {
        _product = fetchedProduct;
        _typeName = fetchedType.type_name;
        _storeName = fetchedStore.store_name;
        _storePhoto = fetchedStore.store_photo;
        _productAvailable = _product.product_available;
        _likesCount = likesCount; // تحديث عدد المفضلات
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ أثناء جلب المنتج أو المتجر أو النوع او عدد معجبين: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }



  Future<void> _updateAvailability(bool newValue) async {
    try {
      setState(() {
        _product.product_available = newValue ? 1 : 0;
      });

      await _productApi.updateProduct(
        _product.id,
        product_available: newValue ? 1 : 0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newValue ? '$product_activated_m' : '$product_activated_no_m'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _product.product_available = newValue ? 0 : 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error_update_data_m'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator());

    final String shareUrl_data_product = "${ApiService.ip_server}/product-share?id=${widget.product_id}";

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Stack(
              children: [
                // 1. صورة المنتج (الطبقة السفلية)
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(
                        _getImageUrl(_product.product_photo_1),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 2. زر المشاركة (الطبقة العلوية)
                Positioned(
                  top: 10, // بعد عن الحافة العلوية
                  // يفضل وضعها على الحافة المعاكسة للغة (اليمين للإنجليزية، اليسار للعربية)
                  // هنا سنضعها على اليمين (نهاية الـ Stack)
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      shareProduct(
                        _product.id,
                        _product.product_name,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      // خلفية شبه شفافة
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4), // أسود شفاف بنسبة 40%
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // اسم المنتج والسعر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _product.product_name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${_product.product_price} \$',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color_main,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // معلومات المتجر
            GestureDetector(
              onTap: () async {
                try {
                  final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
                  final store = await storeApi.getStore(_product.store_id);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowStoreData(
                        store: store,
                        user: widget.user,
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$error_store_loading_data_m')),
                  );
                }
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: _storePhoto.isNotEmpty
                        ? NetworkImage(_getImageUrl(_storePhoto))
                        : AssetImage("assets/default_store.png") as ImageProvider,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _storeName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // عدد المعجبين
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 24),
                SizedBox(width: 10),
                Text(
                  '$a_likes_count: $_likesCount',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ],
            ),

            SizedBox(height: 16),

            // نوع المنتج
            Row(
              children: [
                Icon(Icons.category, color: color_main, size: 24),
                SizedBox(width: 10),
                Text(
                  '$a_product_type_s: $_typeName',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 20),

            // وصف المنتج
            Text(
              '$a_product_note_s:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              _product.product_description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),

            // حالة التوفر
            Row(
              children: [
                Icon(
                  _product.product_available == 1 ? Icons.check_circle : Icons.cancel,
                  color: _product.product_available == 1 ? Colors.green : Colors.red,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  '$availability_status:',
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
                SizedBox(width: 8),
                Text(
                  _product.product_available == 1 ? "$a_available" : "$a_not_available",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _product.product_available == 1 ? Colors.green : Colors.red,
                  ),
                ),
                if (widget.canEditAvailability) ...[
                  SizedBox(width: 16),
                  Switch(
                    value: _product.product_available == 1,
                    onChanged: _updateAvailability,
                    activeColor: color_main,
                  ),
                ],
              ],
            ),
            SizedBox(height: 32), // زيادة المسافة قبل الـ QR

            // QR في المنتصف
            Center(
              child: Column(
                children: [            QrImageView(
              data: shareUrl_data_product,
              version: QrVersions.auto,
              size: 160.0,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              'QR Code للمنتج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
          ],
        ),
      ),
    );
  }
}

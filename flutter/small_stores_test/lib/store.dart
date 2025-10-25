import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:small_stores_test/apiService/api.dart';
import 'package:share_plus/share_plus.dart';

import 'package:small_stores_test/appbar.dart';
import 'package:small_stores_test/editstore.dart';
import 'addannouncement.dart';
import 'apiService/api_service.dart';
import 'apiService/class_api.dart';
import 'apiService/store_api.dart';
import 'drawer.dart';
import 'models/classmodel.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'variables.dart';
import 'style.dart';

class Store extends StatefulWidget {
  final int store_id;
  final User user;

  const Store({Key? key, required this.store_id, required this.user})
      : super(key: key);

  @override
  _Store createState() => _Store();
}

class _Store extends State<Store> {
  StoreModel? _store;
  bool showOptions = false;

  // تأكيد الحذف بخطوتين
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    bool firstConfirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(a_confirm_delete_l, style: style_text_titel),
        content: Text(a_delete_store_question ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(a_cancel,
                style: style_text_button_normal_2(color_Secondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(a_yes, style: style_text_button_normal_red),
          ),
        ],
      ),
    );

    if (firstConfirm == true) {
      bool finalConfirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(a_confirm_end_l, style: style_text_titel),
          content: Text(
              a_delete_store_final_warning ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(a_cancel,
                  style: style_text_button_normal_2(color_Secondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(a_confirm_delete_l, style: style_text_button_normal_red),
            ),
          ],
        ),
      );

      if (finalConfirm == true) {
        _deleteStore();
      }
    }
  }

  // حذف المتجر
  Future<void> _deleteStore() async {
    try {
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
      await storeApi.deleteStore(_store!.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(a_store_deleted_success )),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$a_store_delete_failed : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreBody(
        store_id: widget.store_id,
        onStoreLoaded: (store) {
          setState(() {
            _store = store;
          });
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_store != null && showOptions) ...[
            // زر التعديل
            FloatingActionButton(
              //heroTag: "editStoreBtn",
              onPressed: () {
                setState(() => showOptions = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EditStore(store: _store!, user: widget.user),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.edit, color: color_main),
            ),
            SizedBox(height: 10),

            // زر الإعلان
            FloatingActionButton(
              //heroTag: "addAnnouncementBtn",
              onPressed: () {
                setState(() => showOptions = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddAnnouncement(
                      user: widget.user,
                      store_id: widget.store_id,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.campaign, color: color_main),
            ),
            SizedBox(height: 10),

            // زر الحذف
            FloatingActionButton(
              //heroTag: "deleteStoreBtn",
              onPressed: () {
                setState(() => showOptions = false);
                _showDeleteConfirmation(context);
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.delete, color: Colors.red),
            ),
            SizedBox(height: 10),
          ],

          // زر المزيد
          FloatingActionButton(
            //heroTag: "moreOptionsBtn",
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

class StoreBody extends StatefulWidget {
  final int store_id;
  final Function(StoreModel) onStoreLoaded;

  StoreBody({required this.store_id, required this.onStoreLoaded});

  @override
  _StoreBody createState() => _StoreBody();
}

class _StoreBody extends State<StoreBody> {
  StoreModel? _store;
  List<ClassModel> _classes = [];
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchStore();
  }

  void shareStore(String storeName) {
    final String shareLink =
        "${ApiService.ip_server}/store-share?id=${widget.store_id}";
    final String message =
        'شاهد هذا المتجر المميز: $storeName\n'
        'لمشاهدة التفاصيل وحفظه في المفضلة، حمل تطبيقنا الآن!\n'
        '$shareLink';
    Share.share(message);
  }

  Future<void> fetchStore() async {
    try {
      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
      final stores = await storeApi.getStores();

      final classApi = ClassApi(apiService: ApiService(client: http.Client()));
      final classList = await classApi.getClasses();

      final selectedStore =
      stores.firstWhere((s) => s.id == widget.store_id);

      setState(() {
        _store = selectedStore;
        _classes = classList;
        _isLoading = false;
      });

      widget.onStoreLoaded(_store!);
      print("📸 store_photo = '${_store!.store_photo}'");

    } catch (e) {
      print('خطأ في جلب بيانات المتجر: $e');
    }
  }

  String _getImageUrl(String url) {
    if (url.isEmpty) return '';
    if (!url.startsWith('http')) {
      // إذا الرابط نسبي، نضيف baseUrlImg
      return ApiService.baseUrlImg + url.split('/storage/').last;
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final String shareUrl_data_store = '${ApiService.ip_server}/store-share?id=${widget.store_id}';

    String className = _classes.firstWhere(
          (c) => c.id == _store!.class_id,
    ).class_name;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      _getImageUrl(_store!.store_photo),
                      height: 160,
                      width: 160,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 160,
                          width: 160,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.store, size: 80, color: Colors.grey);
                      },
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 24,
                    child: GestureDetector(
                      onTap: () {
                        shareStore(_store!.store_name);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.store,color: color_main, size: 24),
            SizedBox(width: 10),
            Text(
             // '${a_store_name_s}:'
                  ' ${_store!.store_name}',
              style: style_text_normal,
            ),
          ]
        ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.place,color: color_main ,size: 24),
                SizedBox(width: 10),
                Text(
                  '${a_store_plane_s}:',
                  style: style_text_normal,
                ),
              ],
            ),
            Text(
              '    ${_store!.store_place}',
              style: style_text_normal,
            ),
            SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.phone,color: color_main ,size: 24),
            SizedBox(width: 10),
            Text(
              '${a_store_phone_s}: ${_store!.store_phone}',
              style: style_text_normal,
            ),]),
            SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.type_specimen,color: color_main ,size: 24),
            SizedBox(width: 10),
            Text(
              '${a_store_class_s}: $className',
              style: style_text_normal,
            ),]),
            SizedBox(height: 16),
            Text(
              '${a_store_note_s}:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              //'${a_store_note_s}:'
                  ' ${_store!.store_description}',
              style: style_text_normal,
            ),
            SizedBox(height: 32), // زيادة المسافة قبل الـ QR

            // QR في المنتصف
            Center(
              child: Column(
                children: [
                  QrImageView(
                    data: shareUrl_data_store,
                    version: QrVersions.auto,
                    size: 160.0,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'QR Code للمتجر',
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

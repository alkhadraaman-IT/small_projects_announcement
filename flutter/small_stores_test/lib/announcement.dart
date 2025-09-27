import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/variables.dart';
import 'apiService/api_service.dart';
import 'apiService/announcement_api.dart';
import 'apiService/store_api.dart';
import 'models/announcementmodel.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'showstoredata.dart';
import 'style.dart';

class AnnouncementScreen extends StatefulWidget {
  final User user;

  const AnnouncementScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AnnouncementScreen createState() => _AnnouncementScreen();
}

class _AnnouncementScreen extends State<AnnouncementScreen> {
  List<Announcement> _announcements = [];
  Map<int, StoreModel> _storesCache = {};
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  List<Announcement> _filteredAnnouncements = [];

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();

    _searchController.addListener(() {
      _applySearch();
    });
  }

  Future<void> _fetchAnnouncements() async {
    try {
      final api = AnnouncementApi(apiService: ApiService(client: http.Client()));
      final fetched = await api.getAnnouncements();

      final storeApi = StoreApi(apiService: ApiService(client: http.Client()));
      for (var announcement in fetched) {
        if (!_storesCache.containsKey(announcement.store_id)) {
          final store = await storeApi.getStore(announcement.store_id);
          _storesCache[announcement.store_id] = store;
        }
      }

      setState(() {
        _announcements = fetched.reversed.toList();
        _filteredAnnouncements = List.from(_announcements);
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ في جلب الإعلانات: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applySearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAnnouncements = _announcements.where((ann) {
        final store = _storesCache[ann.store_id];
        final storeName = store?.store_name.toLowerCase() ?? '';
        final description = ann.announcement_description.toLowerCase();
        return storeName.contains(query) || description.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200 ? 2 : 1;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حقل البحث
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'ابحث عن إعلان أو متجر',
                suffixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),

            SizedBox(height: 16),

            Text(
              a_ann_d,
              style: style_text_titel,
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16),

            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredAnnouncements.isEmpty
                  ? Center(child: Text('لا توجد إعلانات حالياً'))
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.8,
                ),
                itemCount: _filteredAnnouncements.length,
                itemBuilder: (context, index) {
                  final item = _filteredAnnouncements[index];
                  final store = _storesCache[item.store_id];

                  // إصلاح رابط صورة الإعلان
                  String fixedImageUrl = item.announcement_photo;
                  if (fixedImageUrl.contains('http://127.0.0.1:8000/storage/http://127.0.0.1:8000/storage/')) {
                    fixedImageUrl = fixedImageUrl.replaceAll(
                      'http://127.0.0.1:8000/storage/http://127.0.0.1:8000/storage/',
                      ApiService.baseUrlImg,
                    );
                  } else if (fixedImageUrl.contains('http://127.0.0.1:8000/storage/')) {
                    fixedImageUrl = fixedImageUrl.replaceFirst(
                      'http://127.0.0.1:8000/storage/',
                      ApiService.baseUrlImg,
                    );
                  }

                  // إصلاح رابط صورة المتجر
                  ImageProvider storeImage;
                  if (store != null && store.store_photo.isNotEmpty) {
                    storeImage = NetworkImage(
                      store.store_photo.replaceFirst(
                        'http://127.0.0.1:8000/storage/',
                        ApiService.baseUrlImg,
                      ),
                    );
                  } else {
                    storeImage = AssetImage('assets/images/logo.png');
                  }

                  return GestureDetector(
                    onTap: () {
                      if (store != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShowStoreData(
                              store: store,
                              user: widget.user,
                            ),
                          ),
                        );
                      }
                    },
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(fixedImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.9),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: storeImage,
                                      radius: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        store?.store_name ?? 'متجر ${item.store_id}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item.announcement_description,
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item.announcement_date,
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                  textAlign: TextAlign.right,
                                ),
                              ],
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
    );
  }
}

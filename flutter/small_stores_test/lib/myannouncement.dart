import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:small_stores_test/showmystoredata.dart';
import 'package:small_stores_test/variables.dart';
import 'apiService/api_service.dart';
import 'apiService/announcement_api.dart';
import 'apiService/store_api.dart';
import 'editannouncement.dart';
import 'models/announcementmodel.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'style.dart';

class MyAnnouncement extends StatefulWidget {
  final User user;

  const MyAnnouncement({Key? key, required this.user}) : super(key: key);

  @override
  _MyAnnouncementState createState() => _MyAnnouncementState();
}

class _MyAnnouncementState extends State<MyAnnouncement> {
  List<Announcement> _announcements = [];
  List<Announcement> _filteredAnnouncements = [];
  Map<int, StoreModel> _storesCache = {};
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  DateTime? _startDate; // بداية النطاق
  DateTime? _endDate; // نهاية النطاق

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
    _searchController.addListener(_applySearch);
  }

  void _applySearch() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredAnnouncements = _announcements.where((ann) {
        final store = _storesCache[ann.store_id];
        final storeName = store?.store_name.toLowerCase() ?? '';
        final description = ann.announcement_description.toLowerCase();

        bool matchesSearch = storeName.contains(query) || description.contains(query);

        bool matchesDate = true;
        if (_startDate != null && _endDate != null) {
          try {
            final annDate = DateTime.parse(ann.announcement_date);
            // التأكد من أن التاريخ ضمن النطاق (بما في ذلك التاريخين البداية والنهاية)
            matchesDate = (annDate.isAtSameMomentAs(_startDate!) || annDate.isAfter(_startDate!)) &&
                (annDate.isAtSameMomentAs(_endDate!) || annDate.isBefore(_endDate!));
          } catch (e) {
            print('خطأ في تحويل التاريخ: $e');
            matchesDate = false;
          }
        }

        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _applySearch();
    });
  }

  Future<void> _fetchAnnouncements() async {
    try {
      final api = AnnouncementApi(apiService: ApiService(client: http.Client()));
      final fetched = await api.getMyAnnouncements(widget.user.id);

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
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAnnouncement(int index, int id) async {
    try {
      final api = AnnouncementApi(apiService: ApiService(client: http.Client()));
      await api.deleteAnnouncement(id);
      setState(() {
        _announcements.removeAt(index);
        _filteredAnnouncements = List.from(_announcements);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف الإعلان بنجاح')),
      );
    } catch (e) {
      print('خطأ في حذف الإعلان: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل حذف الإعلان: $e')),
      );
    }
  }

  Future<void> _showDeleteConfirmation(Announcement item, int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف', style: style_text_titel),
        content: Text('هل تريد حذف هذا الإعلان؟', style: style_text_normal),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء', style: style_text_button_normal(color_main)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('تأكيد الحذف', style: style_text_button_normal_red),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteAnnouncement(index, item.id);
    }
  }

  // دالة لاختيار نطاق التاريخ مع الحفاظ على الشكل البسيط
  Future<void> _pickDateRange() async {
    // أولاً: اختيار تاريخ البداية
    DateTime? start = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: color_main,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (start == null) return;

    // عرض رسالة تأكيد لتاريخ البداية
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'تم تحديد تاريخ البداية: ${start.year}/${start.month}/${start.day}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // انتظار قليل لرؤية الرسالة
    await Future.delayed(Duration(milliseconds: 500));

    // ثانياً: اختيار تاريخ النهاية - نستخدم تاريخ البداية كتاريخ ابتدائي
    DateTime? end = await showDatePicker(
      context: context,
      initialDate: start, // هنا التغيير: نستخدم تاريخ البداية بدلاً من _endDate
      firstDate: start,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: color_main,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (end != null) {
      // عرض رسالة تأكيد لتاريخ النهاية
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تم تحديد تاريخ النهاية: ${end.year}/${end.month}/${end.day}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // عرض رسالة تأكيد نهائية للنطاق الكامل
      await Future.delayed(Duration(milliseconds: 500));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.date_range, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تم تحديد النطاق الزمني بنجاح!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: color_main,
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        _startDate = start;
        _endDate = end;
        _applySearch();
      });
    }
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
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
                ),
                SizedBox(width: 8),
                // زر التقويم مع أيقونة النطاق الزمني
                Container(
                  decoration: BoxDecoration(
                    color: color_main,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.white, size: 24),
                    tooltip: _startDate == null
                        ? "اختر نطاق زمني"
                        : "مسح الفلترة",
                    onPressed: () {
                      if (_startDate == null) {
                        _pickDateRange(); // يفتح اختيار النطاق
                      } else {
                        _clearDateFilter(); // يمسح الفلترة
                      }
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Text(
              'إعلاناتي',
              style: style_text_titel,
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16),
            // عرض النطاق أسفل كلمة إعلاناتي - بالشكل البسيط
            if (_startDate != null && _endDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color_main.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color_main),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.date_range, color: color_main, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'النطاق الزمني المحدد:',
                              style: style_text_normal.copyWith(
                                color: color_main,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.play_arrow, color: color_main, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '${_startDate!.year}/${_startDate!.month}/${_startDate!.day}',
                                  style: style_text_normal.copyWith(fontSize: 12, color: color_main),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.stop, color: color_main, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '${_endDate!.year}/${_endDate!.month}/${_endDate!.day}',
                                  style: style_text_normal.copyWith(fontSize: 12, color: color_main),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _clearDateFilter,
                        child: Icon(Icons.close, color: color_main, size: 20),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredAnnouncements.isEmpty
                  ? Center(child: Text('لا توجد إعلانات حالياً'))
                  : GridView.builder(
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
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
                  if (fixedImageUrl.contains(
                      'http://127.0.0.1:8000/storage/http://127.0.0.1:8000/storage/')) {
                    fixedImageUrl = fixedImageUrl.replaceAll(
                        'http://127.0.0.1:8000/storage/http://127.0.0.1:8000/storage/',
                        ApiService.baseUrlImg);
                  } else if (fixedImageUrl.contains(
                      'http://127.0.0.1:8000/storage/')) {
                    fixedImageUrl = fixedImageUrl.replaceFirst(
                        'http://127.0.0.1:8000/storage/',
                        ApiService.baseUrlImg);
                  }

                  // صورة المتجر
                  ImageProvider storeImage;
                  if (store != null && store.store_photo.isNotEmpty) {
                    storeImage = NetworkImage(
                      store.store_photo.replaceFirst(
                          'http://127.0.0.1:8000/storage/',
                          ApiService.baseUrlImg),
                    );
                  } else {
                    storeImage =
                        AssetImage('assets/images/logo.png');
                  }

                  return Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // صورة الإعلان
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

                        // تدرج أسفل الإعلان
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

                        // أيقونة الخيارات أعلى يسار
                        Positioned(
                          top: 8,
                          left: 8,
                          child: PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert,
                                color: color_Secondary),
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditAnnouncement(
                                        announcement: item,
                                        user: widget.user),
                                  ),
                                );
                              } else if (value == 'delete') {
                                _showDeleteConfirmation(item, index);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('تعديل',
                                    style: style_text_normal),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('حذف',
                                    style:
                                    style_text_button_normal_red),
                              ),
                            ],
                          ),
                        ),

                        // معلومات أسفل الإعلان
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (store != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ShowMyStoreData(
                                              store: store,
                                              user: widget.user,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Tooltip(
                                      message: 'عرض المتجر',
                                      child: CircleAvatar(
                                        backgroundImage: storeImage,
                                        radius: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      store?.store_name ??
                                          'متجر ${item.store_id}',
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
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14),
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                item.announcement_date,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
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
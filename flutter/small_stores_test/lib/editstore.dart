import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'apiService/api_service.dart';
import 'apiService/class_api.dart';
import 'apiService/store_api.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'models/storemodel.dart';
import 'models/classmodel.dart';
import 'models/usermodel.dart';
import 'style.dart';
import 'variables.dart';

class EditStore extends StatefulWidget {
  final StoreModel store;
  final User user;

  EditStore({Key? key, required this.store, required this.user})
      : super(key: key);

  @override
  _EditStore createState() => _EditStore();
}

class _EditStore extends State<EditStore> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storePlanController = TextEditingController();
  final TextEditingController _storePhoneController = TextEditingController();
  final TextEditingController _storeNoteController = TextEditingController();
  final TextEditingController _storeImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _selectedClassStore;

  List<ClassModel> _classList = [];
  bool _isLoadingClasses = true;

  final ImagePicker _picker = ImagePicker();
  Uint8List? _webImage; // 👈 خاص بالويب

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        _webImage = await pickedFile.readAsBytes();
        setState(() {
          _storeImageController.text = pickedFile.name;
        });
      } else {
        setState(() {
          _storeImageController.text = pickedFile.path;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _storeNameController.text = widget.store.store_name;
    _storePlanController.text = widget.store.store_place;
// إزالة +963 من الرقم قبل وضعه في الحقل
    _storePhoneController.text = widget.store.store_phone.startsWith('+963 ')
        ? widget.store.store_phone.substring(4)
        : widget.store.store_phone;

    _storeNoteController.text = widget.store.store_description;
    _storeImageController.text = widget.store.store_photo;

    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    try {
      final classApi = ClassApi(apiService: ApiService(client: http.Client()));
      final classes = await classApi.getClasses();
      setState(() {
        _classList = classes;
        _isLoadingClasses = false;

        final defaultClass = _classList.firstWhere(
              (classModel) => classModel.id == widget.store.class_id,
        );
        _selectedClassStore = defaultClass.class_name;
      });
    } catch (e) {
      print("خطأ أثناء جلب الأصناف: $e");
      setState(() {
        _isLoadingClasses = false;
      });
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storePlanController.dispose();
    _storePhoneController.dispose();
    _storeNoteController.dispose();
    _storeImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  image_logo_b,
                  SizedBox(height: 16),
                  Text(a_edit_store_s, style: style_text_titel),
                  SizedBox(height: 16),

                  // 🏬 اسم المتجر
                  TextFormField(
                    controller: _storeNameController,
                    decoration: InputDecoration(
                      labelText: a_store_name_s,
                      prefixIcon: Icon(Icons.storefront_rounded),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                    value == null || value.isEmpty ? a_store_name_m : null,
                  ),
                  SizedBox(height: 16),

                  // 📂 الصنف
                  DropdownButtonFormField<String>(
                    value: _selectedClassStore,
                    decoration: InputDecoration(
                      labelText: a_class_store_s,
                      prefixIcon: Icon(Icons.type_specimen),
                    ),
                    items: _isLoadingClasses
                        ? [
                      DropdownMenuItem(
                          value: null, child: Text('جاري التحميل...'))
                    ]
                        : _classList.map((classModel) {
                      return DropdownMenuItem<String>(
                        value: classModel.class_name,
                        child: Text(classModel.class_name),
                      );
                    }).toList(),
                    onChanged: null, // ممنوع التغيير
                  ),
                  SizedBox(height: 16),

                  // 📝 ملاحظات
                  TextFormField(
                    controller: _storeNoteController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: a_store_note_s,
                      prefixIcon: Icon(Icons.sticky_note_2_rounded),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? a_email_m : null,
                  ),
                  SizedBox(height: 8),

                  // ☎ الهاتف

                  TextFormField(
                    controller: _storePhoneController,
                    decoration: InputDecoration(
                      labelText: a_phone_l,
                      prefixIcon: Icon(Icons.phone),
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '+963',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) =>
                    value == null || value.isEmpty ? a_phone_m : null,
                    onChanged: (value) {
                      if (value.startsWith('0')) {
                        _storePhoneController.text = value.substring(1);
                        _storePhoneController.selection =
                            TextSelection.fromPosition(
                              TextPosition(
                                  offset: _storePhoneController.text.length),
                            );
                      }
                    },
                  ),
                  SizedBox(height: 16),

                  // 📍 المكان
                  TextFormField(
                    controller: _storePlanController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: a_store_plane_s,
                      prefixIcon: Icon(Icons.place),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? a_plan_store_m : null,
                  ),
                  SizedBox(height: 16),

                  // 🖼 صورة
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _storeImageController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: a_store_class_s,
                            prefixIcon: Icon(Icons.image),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? a_store_logo_m
                              : null,
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        style: styleButton(color_main),
                        onPressed: _pickImage,
                        child: Text(a_edit_b),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // زر التعديل
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      style: styleButton(color_main),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final selectedClass = _classList.firstWhere(
                                  (classModel) => classModel.class_name == _selectedClassStore,
                            );
                            final int classId = selectedClass.id;

                            final api = StoreApi(apiService: ApiService(client: http.Client()));

                            await api.updateStore(
                              id: widget.store.id,
                              store_name: _storeNameController.text,
                              store_phone: '+963 ${_storePhoneController.text}',
                              store_place: _storePlanController.text,
                              class_id: classId,
                              store_description: _storeNoteController.text,
                              store_state: 1,
                              store_photo: !kIsWeb ? File(_storeImageController.text) : null,
                              storePhotoBytes: kIsWeb ? _webImage : null,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم تعديل المتجر بنجاح ✅')),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            String errorMessage = "حدث خطأ أثناء التعديل ❌";

                            // معالجة الأخطاء بشكل صحيح
                            if (e is http.Response) {
                              try {
                                final body = jsonDecode(e.body);
                                if (body['errors'] != null) {
                                  errorMessage = body['errors'].values.first[0];
                                } else if (body['message'] != null) {
                                  errorMessage = body['message'];
                                }
                              } catch (_) {
                                errorMessage = "خطأ في معالجة الاستجابة من الخادم";
                              }
                            } else if (e is Exception) {
                              errorMessage = e.toString();
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          }
                        }
                      },
                      child: Text(a_edit_b),
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

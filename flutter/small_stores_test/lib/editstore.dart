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

  List<ClassModel> _classList = [];
  ClassModel? _selectedClass;
  bool _isLoadingClasses = true;
  bool _isSubmitting = false;

  // دالة للحصول على الاسم المترجم للفئة
  String _getTranslatedClassName(ClassModel classItem) {
    return language_app == "ar"
        ? classItem.class_name
        : (classItem.class_name_english ?? classItem.class_name);
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _webImage;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      if (bytes.length > 4 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(a_image_too_large))
        );
        return;
      }

      if (kIsWeb) {
        setState(() {
          _webImage = bytes;
          _storeImageController.text = pickedFile.name;
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
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
        _selectedClass = _classList.firstWhere(
                (classModel) => classModel.id == widget.store.class_id,

        );
        _isLoadingClasses = false;
      });
    } catch (e) {
      print("${a_error_fetching_categories}: $e");
      setState(() {
        _isLoadingClasses = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(a_error_fetching_categories)),
      );
    }
  }

  Future<void> _updateStore() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedClass == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(a_please_select_store_type))
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        final api = StoreApi(apiService: ApiService(client: http.Client()));

        await api.updateStore(
          id: widget.store.id,
          store_name: _storeNameController.text,
          store_phone: '+963 ${_storePhoneController.text}',
          store_place: _storePlanController.text,
          class_id: _selectedClass!.id,
          store_description: _storeNoteController.text,
          store_state: 1,
          store_photo: !kIsWeb ? _selectedImage : null,
          storePhotoBytes: kIsWeb ? _webImage : null,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(a_store_updated_success)),
        );

        // العودة للصفحة السابقة بعد التحديث الناجح
        Navigator.pop(context);

      } catch (e) {
        String errorMessage = a_store_update_failed;

        if (e is http.Response) {
          try {
            final body = jsonDecode(e.body);
            if (body['errors'] != null) {
              errorMessage = body['errors'].values.first[0];
            } else if (body['message'] != null) {
              errorMessage = body['message'];
            }
          } catch (_) {
            errorMessage = a_server_response_error;
          }
        } else if (e is Exception) {
          errorMessage = e.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
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
                  SizedBox(height: 24),

                  // اسم المتجر
                  TextFormField(
                    controller: _storeNameController,
                    decoration: InputDecoration(
                      labelText: a_store_name_s,
                      prefixIcon: Icon(Icons.storefront_rounded),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                    value == null || value.isEmpty ? a_store_name_m : null,
                  ),
                  SizedBox(height: 16),

                  // فئة المتجر - القائمة المنسدلة
                  AbsorbPointer(
                    absorbing: true, // يمنع التفاعل
                    child: DropdownButtonFormField<ClassModel>(
                      value: _selectedClass,
                      decoration: InputDecoration(
                        labelText: a_class_store_s,
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      items: _classList.map((classModel) {
                        return DropdownMenuItem<ClassModel>(
                          value: classModel,
                          child: Text(_getTranslatedClassName(classModel), style: style_text_normal),
                        );
                      }).toList(),
                      onChanged: null, // يعطل التغيير
                      validator: (value) => value == null ? a_store_class_m : null,
                      isExpanded: true,
                    ),
                  ),

                  SizedBox(height: 16),

                  // وصف المتجر
                  TextFormField(
                    controller: _storeNoteController,
                    maxLength: 255,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: a_store_note_s,
                      prefixIcon: Icon(Icons.sticky_note_2_rounded),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? a_please_enter_store_overview : null,
                  ),
                  SizedBox(height: 16),

                  // هاتف المتجر
                  TextFormField(
                    controller: _storePhoneController,
                    decoration: InputDecoration(
                      labelText: a_store_phone_s,
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
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) =>
                    value == null || value.isEmpty ? a_please_enter_store_phone : null,
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

                  // موقع المتجر
                  TextFormField(
                    controller: _storePlanController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      labelText: a_store_plane_s,
                      prefixIcon: Icon(Icons.place),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? a_please_enter_store_location : null,
                  ),
                  SizedBox(height: 16),

                  // صورة المتجر
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a_store_logo_s,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _storeImageController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: a_no_image_selected,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            style: styleButton(color_main),
                            onPressed: _pickImage,
                            child: Text(a_select_image_button),
                          ),
                        ],
                      ),

                      // معاينة الصورة
                      SizedBox(height: 16),
                      if (_webImage != null || _selectedImage != null)
                        Column(
                          children: [
                            Text(
                              language_app == "ar" ? "الصورة الجديدة:" : "New Image:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: color_main, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: kIsWeb
                                  ? Image.memory(_webImage!, fit: BoxFit.cover)
                                  : Image.file(_selectedImage!, fit: BoxFit.cover),
                            ),
                          ],
                        )
                      else if (widget.store.store_photo.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              language_app == "ar" ? "الصورة الحالية:" : "Current Image:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                widget.store.store_photo,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.store, size: 40, color: Colors.grey);
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // زر التعديل
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                      style: styleButton(color_main),
                      onPressed: _isSubmitting ? null : _updateStore,
                      child: _isSubmitting
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Text(a_edit_b),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
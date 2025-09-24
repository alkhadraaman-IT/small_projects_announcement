import 'package:flutter/material.dart';

import 'package:small_stores_test/editproduct.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'store.dart';

import 'style.dart';
import 'variables.dart';

class Product extends StatefulWidget {
  @override
  _Product createState() => _Product();
}

class _Product extends State<Product> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: ProductBody(), // ✅ إصلاح: إضافة child:
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProduct()),
          );
        },
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: color_main,
      ),
    );
  }
}


class ProductBody extends StatefulWidget {
  @override
  _ProductBody createState() => _ProductBody();
}

class _ProductBody extends State<ProductBody> {
  final TextEditingController _productStaiteController = TextEditingController();

  bool _productAvailable = false;

  void dispose() {
    _productStaiteController.dispose();
    super.dispose();
  }

  String name = 'ااا';
  String plane = 'ببب بب';
  String note = 'تتت ت تت تتتتتت';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // لمحاذاة النصوص يمينًا
        children: [
          Image.asset('assets/ggg.png'),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( 'اسم المنتج' , style: style_text_normal),
              Text('20\$' , style: style_text_normal),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Image.asset('assets/images/img.png', height: 32, width: 32,), // ✅ مسار صحيح
              SizedBox(width: 8),
              Text(a_store_name_s , style: style_text_normal),
            ],
          ),
          SizedBox(height: 16),
          Text('عدد المحبين للمنتج' + ': ' + '55', style: style_text_normal),
          Text(a_product_type_s + ': ' + note, style: style_text_normal),
          SizedBox(height: 16),
          Text(a_product_stati_s + ': ' + note, style: style_text_normal),
          SizedBox(height: 16),
          Text(a_product_note_s + ': ' + note, style: style_text_normal),
          SizedBox(height: 16),
          CheckboxListTile(
            title: Text(a_product_stati_s),
            value: _productAvailable,
            onChanged: (newValue) {
              setState(() {
                _productAvailable = newValue ?? false;
                _productStaiteController.text = _productAvailable ? 'متوفر' : 'غير متوفر';
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),

          SizedBox(height: 16),

        ],
      ),
    );
  }
}

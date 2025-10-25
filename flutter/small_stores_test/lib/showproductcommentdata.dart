import 'package:flutter/material.dart';
import 'package:small_stores_test/appbar.dart';
import 'package:small_stores_test/comments.dart';
import 'package:small_stores_test/models/productmodel.dart';
import 'package:small_stores_test/productall.dart';
import 'package:small_stores_test/showproduct.dart';
import 'drawer.dart';
import 'models/storemodel.dart';
import 'models/usermodel.dart';
import 'product.dart';
import 'showproductall.dart';
import 'showstore.dart';
import 'store.dart';
import 'variables.dart';
import 'style.dart';
import 'appbar.dart';

class ShowProductCommentData extends StatefulWidget {
  final StoreModel store;
  final User user;
  final ProductModel product;

  const ShowProductCommentData({Key? key, required this.store, required this.user, required this.product}) : super(key: key);

  @override
  _ShowProductCommentData createState() => _ShowProductCommentData();
}

class _ShowProductCommentData extends State<ShowProductCommentData> {
  final bool showBackButton=true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child:Scaffold(
          appBar: AppBar(
            leading: showBackButton
                ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
                : null,

            title: Text(app_name,style: style_name_app_o(color_main),),
            centerTitle: true,
            actions: [
              Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // فتح drawer باستخدام context الصحيح
                    },
                  )
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: prodect_t,),
                Tab(text: comment_t,),
              ],
            ),
          ),
          drawer: CustomDrawer(user: widget.user,),
          body: TabBarView(
            children: [
              ShowProduct(user: widget.user, product_id: widget.product.id,),
              CommentsPage(product_id: widget.product.id, user_id: widget.user.id,),
            ],
          ),
        )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:small_stores_test/appbar.dart';
import 'package:small_stores_test/comments.dart';
import 'package:small_stores_test/models/productmodel.dart';
import 'package:small_stores_test/productall.dart';
import 'package:small_stores_test/requests.dart';
import 'package:small_stores_test/showfilerequests.dart';
import 'package:small_stores_test/showproduct.dart';
import 'package:small_stores_test/statistics.dart';
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

class UserData extends StatefulWidget {
  final User user;

  const UserData({Key? key,  required this.user}) : super(key: key);

  @override
  _UserData createState() => _UserData();
}

class _UserData extends State<UserData> {
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
                Tab(text: a_user_type_default,),
                Tab(text: "الممنوعين",),
              ],
            ),
          ),
          drawer: CustomDrawer(user: widget.user,),
          body: TabBarView(
            children: [
              Statistics(),
              Requests(),
            ],
          ),
        )
    );
  }
}
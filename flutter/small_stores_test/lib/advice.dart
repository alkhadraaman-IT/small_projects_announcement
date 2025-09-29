import 'package:flutter/material.dart';
import 'package:small_stores_test/models/usermodel.dart';
import 'package:small_stores_test/style.dart';
import 'package:small_stores_test/variables.dart';
import 'dart:math';

import 'appbar.dart';
import 'drawer.dart';

class Advice extends StatefulWidget {
  final User user;

  const Advice({super.key, required this.user});

  @override
  _Advice createState() => _Advice();
}

class _Advice extends State<Advice> {
  List<Map<String, String>> advice = [
    {"text": "قدم خدمة تلقى مالا", "author": "روبرت كيوساكي"},
    {"text": "حل مشكلة تلقى أموال", "author": "روبرت كيوساكي"},
    {"text": "العملاء لا يشترون منتجاً يشترون المشاعر والنتائج", "author": "محمد الركني"},
    {"text": "الرغبة هي نقطة البداية لجميع الانجازات", "author": "نابليون هيل"},
    {"text": "كن استباقيا لا تنتظر العملاء بل ابحث عنهم", "author": "ستيفن كوفي"},
    {"text": "ركز على الحلول بدل المشاكل", "author": ""},
    {"text": "ابنِ علاقات قوية مع عملائك", "author": "جيفري جيتومر"},
    {"text": "احط نفسك بأشخاص ناجحين وتعلم منهم", "author": "نابليون هيل"},
    {"text": "حول الفشل إلى فرص", "author": "توماس إديسون"},
    {"text": "استخدم كلمات سحرية في إعلاناتك (حصري، محدود، اغتنم الفرصة...)", "author": "دان كينيدي"},
    {"text": "صمم عرض لا يرفض", "author": "جاي أبراهام"},
    {"text": "حدد الشريحة التي تستهدفها", "author": "فيليب كوتلر"},
    {"text": "أشكر العملاء", "author": "توني شيه"},
    {"text": "لا تعمل من أجل المال بل اجعل المال يعمل من أجلك", "author": "روبرت كيوساكي"},
    {"text": "كن متفائلاً وانقل حماستك لعملائك", "author": "زيج زيغلار"},
    {"text": "خصص نصف ساعة يومياً لتطوير خطتك التسويقية وتعلم التسويق", "author": "براين تريسي"},
    {"text": "كل عميل سعيد يمكن أن يجلب لك ١٠ عملاء جدد", "author": "ستيف جوبز"},
    {"text": "كن بقرة أرجوانية وتفرد عن غيرك", "author": "سيث جودين"},
    {"text": "استثمار في التسويق هو استثمار في مشروعك", "author": "فيليب كوتلر"},
    {"text": "الجودة أفضل وسيلة للدعاية", "author": "هنري فورد"},
    {"text": "كرر يومياً عبارات النجاح وتلاعب بعقلك وعقل من حولك", "author": "نابليون هيل"},
    {"text": "حافظ على ولاء العملاء لك", "author": "كين بلانشارد"},
    {"text": "استخدم الترويج الذكي (قدم هدية بسيطة مع منتجك)", "author": "جاي كونراد ليفينسون"},
    {"text": "كن مستمعاً جيداً لزبائنك", "author": "ديل كارنيجي"},
    {"text": "لا تيأس فالفشل طريق النجاح", "author": "مايكل جوردن"},
    {"text": "الزبون الدائم يساوي ذهباً", "author": "بيتر دراكر"},
    {"text": "أرسل رسائل لزبائنك في المناسبات", "author": "هارفي ماكاي"},
    {"text": "اتخذ بالأسباب وتوكل على الله", "author": ""},
    {"text": "ذكرهم في نفسك ارسل رسائل لعملاء قديمين", "author": ""},
    {"text": "التسويق ليس حدثا بل عملية مستمرة", "author": "فيليب كوتلر"},
    {"text": "أعظم إعلان هو العميل الراضي", "author": "بيل جيتس"},
    {"text": "المستقبل ينتمي لأولئك الذين يرون الاحتمالات قبل أن تتحول لفرص", "author": "نابليون هيل"},
  ];

  Map<String, String> currentTip = {};
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _getRandomTip();
  }

  void _getRandomTip() {
    setState(() {
      currentTip = advice[_random.nextInt(advice.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    // أبعاد الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      //backgroundColor: Colors.grey, // 👉 لون الخلفية كامل الشاشة
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
              side: BorderSide(      // ✅ إضافة الإطار للكارد
                color: color_main,  // لون الإطار
                width: 2,            // سمك الإطار
              ),
            ),
            elevation: 6,
            color: Colors.white,
            child: Container(
              width: screenWidth * 0.85,   // 👉 85% من عرض الشاشة
              height: screenHeight * 0.5,  // 👉 50% من ارتفاع الشاشة
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    image_logo_b,
                    const SizedBox(height: 16),
                    Text(
                      currentTip["text"] ?? "",
                      style: style_text_big_2(color_main),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    if (currentTip["author"]?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          "- ${currentTip["author"]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: color_main,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),


  /*ElevatedButton(
                onPressed: _getRandomTip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: color_main,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'نصيحة جديدة',
                  style: TextStyle(fontSize: 18),
                ),
              ),*/

    );
  }
}
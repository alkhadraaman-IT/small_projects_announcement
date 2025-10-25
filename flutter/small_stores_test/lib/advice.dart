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
  List<Map<String, String>> advice_a = [
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

  List<Map<String, String>> advice_e = [
    {"text": "Provide a service and you will earn money", "author": "Robert Kiyosaki"},
    {"text": "Solve a problem and you will get paid", "author": "Robert Kiyosaki"},
    {"text": "Customers don't buy a product, they buy feelings and results", "author": "Mohammed Al-Rukni"},
    {"text": "Desire is the starting point of all achievements", "author": "Napoleon Hill"},
    {"text": "Be proactive, don't wait for customers, go and find them", "author": "Stephen Covey"},
    {"text": "Focus on solutions instead of problems", "author": ""},
    {"text": "Build strong relationships with your customers", "author": "Jeffrey Gitomer"},
    {"text": "Surround yourself with successful people and learn from them", "author": "Napoleon Hill"},
    {"text": "Turn failure into opportunities", "author": "Thomas Edison"},
    {"text": "Use magic words in your ads (Exclusive, Limited, Don't miss out...)", "author": "Dan Kennedy"},
    {"text": "Create an irresistible offer", "author": "Jay Abraham"},
    {"text": "Identify the segment you want to target", "author": "Philip Kotler"},
    {"text": "Thank your customers", "author": "Tony Hsieh"},
    {"text": "Don't work for money, make money work for you", "author": "Robert Kiyosaki"},
    {"text": "Be optimistic and transfer your enthusiasm to your customers", "author": "Zig Ziglar"},
    {"text": "Dedicate half an hour daily to develop your marketing plan and learn marketing", "author": "Brian Tracy"},
    {"text": "Every happy customer can bring you 10 new ones", "author": "Steve Jobs"},
    {"text": "Be a Purple Cow and stand out from the rest", "author": "Seth Godin"},
    {"text": "Investing in marketing is investing in your business", "author": "Philip Kotler"},
    {"text": "Quality is the best form of advertising", "author": "Henry Ford"},
    {"text": "Repeat success affirmations daily and influence your mind and others' minds", "author": "Napoleon Hill"},
    {"text": "Maintain your customers' loyalty", "author": "Ken Blanchard"},
    {"text": "Use smart promotions (add a simple gift with your product)", "author": "Jay Conrad Levinson"},
    {"text": "Be a good listener to your customers", "author": "Dale Carnegie"},
    {"text": "Don't give up, failure is the path to success", "author": "Michael Jordan"},
    {"text": "A loyal customer is worth gold", "author": "Peter Drucker"},
    {"text": "Send messages to your customers on special occasions", "author": "Harvey Mackay"},
    {"text": "Take the means and rely on God", "author": ""},
    {"text": "Remind yourself to reach out to old customers", "author": ""},
    {"text": "Marketing is not an event, it is a continuous process", "author": "Philip Kotler"},
    {"text": "The greatest advertisement is a satisfied customer", "author": "Bill Gates"},
    {"text": "The future belongs to those who see the possibilities before they become opportunities", "author": "Napoleon Hill"},
  ];

  Map<String, String> currentTip = {};
  final Random _random = Random();

  // دالة ترجع القائمة المناسبة حسب اللغة
  List<Map<String, String>> get _currentAdviceList {
    return language_app == "ar" ? advice_a : advice_e;
  }

  @override
  void initState() {
    super.initState();
    _getRandomTip();
  }

  void _getRandomTip() {
    setState(() {
      currentTip = _currentAdviceList[_random.nextInt(_currentAdviceList.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    // أبعاد الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(user: widget.user),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: color_main,
                width: 2,
              ),
            ),
            elevation: 6,
            color: Colors.white,
            child: Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.5,
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
                      textDirection: language_app == "ar" ? TextDirection.rtl : TextDirection.ltr,
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
                          textDirection: language_app == "ar" ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
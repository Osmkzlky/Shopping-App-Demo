// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:shopping_app_demo/controllers/advertisementsPageController.dart';
import 'package:shopping_app_demo/helpers/size.dart';
import 'package:shopping_app_demo/models/Story.dart';
import 'package:shopping_app_demo/theme/colors.dart';
import 'package:shopping_app_demo/views/productListPage.dart';

class AdvertisementsPage extends StatefulWidget {
  final List<Story> stories;
  final int index;
  AdvertisementsPage({
    Key? key,
    required this.stories,
    required this.index,
  }) : super(key: key);

  @override
  State<AdvertisementsPage> createState() => _AdvertisementsPageState();
}

class _AdvertisementsPageState extends State<AdvertisementsPage> {
  final advertisementsPageController = Get.put(AdvertisementsPageController());
  @override
  void initState() {
    // widget.index kullandığımız yer
    advertisementsPageController.changeInitialPage(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    advertisementsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onVerticalDragUpdate: (details) {
        advertisementsPageController.timerStop();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductListPage(
                    product_ids: widget
                        .stories[
                            advertisementsPageController.currentIndex.value]
                        .product_ids,
                    title: widget
                        .stories[
                            advertisementsPageController.currentIndex.value]
                        .story_name))).then((value) =>
            advertisementsPageController.timerStart(widget.stories.length));
      },
      // Parmağımızı ekrandan dokunduğunda ve kaldırdığında yapılan işlemler
      onTapDown: (_) => advertisementsPageController.timerStop(),
      onTapUp: (_) =>
          advertisementsPageController.timerStart(widget.stories.length),
      child: PageView.builder(
        controller: advertisementsPageController.pageController,
        itemCount: widget.stories.length,
        itemBuilder: (context, index) {
          advertisementsPageController.timerReset(widget.stories.length);
          advertisementsPageController.updateCurrentIndex(index);
          return Stack(
            children: [
              Image.network(
                widget.stories[index].story_image,
                fit: BoxFit.cover,
                height: double.infinity,
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildTimer(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 2.w),
                        child: IconButton(
                            alignment: Alignment.center,
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 22.sp,
                            )),
                      ),
                    ),
                    const Spacer(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 20.h,
                          child: LottieBuilder.asset(
                              "assets/animations/upAnimation.json"),
                        )),
                    const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Yukarı Kaydırınız!",
                          style: TextStyle(shadows: [
                            BoxShadow(color: Colors.black, blurRadius: 0.5)
                          ], color: blue, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ));
  }

  GetBuilder<AdvertisementsPageController> _buildTimer() {
    return GetBuilder<AdvertisementsPageController>(builder: (controller) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        width: double.infinity,
        height: 1.h,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(1, 1))
            ],
            borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth * controller.animation.value,
                decoration: BoxDecoration(
                    color: blue, borderRadius: BorderRadius.circular(12)),
              );
            }),
          ],
        ),
      );
    });
  }
}

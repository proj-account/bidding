import 'package:bidding/components/_components.dart';
import 'package:bidding/main/admin/controllers/admin_side_menu_controller.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminSideMenu extends StatelessWidget {
  AdminSideMenu({Key? key}) : super(key: key);
  final scrollController = ScrollController(initialScrollOffset: 0);

  //Add here the permament controllers of admin user
  final AdminSideMenuController menucontroller =
      Get.put(AdminSideMenuController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width >= 600 ? double.infinity : Get.width * .65,
      height: double.infinity,
      color: indigoColor,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                runSpacing: 8,
                children: [
                  Obx(
                    () => CircleImage(
                      imageUrl: menucontroller.userProfile(),
                      initial: menucontroller.initials,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menucontroller.userName,
                          style: robotoMedium.copyWith(
                            color: whiteColor,
                            fontSize: kIsWeb ? 13 : 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: maroonColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 3,
                          ),
                          child: Text(
                            'Admin',
                            style: robotoMedium.copyWith(
                              color: whiteColor,
                              fontSize: kIsWeb ? 11 : 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 45,
              width: 45,
            ),
            ...adminSideMenuItem
                .map((item) => SideMenuCard(
                      menu: item,
                      menuController: menucontroller,
                    ))
                .toList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
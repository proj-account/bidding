import 'package:bidding/components/_components.dart';
import 'package:bidding/main/bidder/controllers/bidder_side_menu_controller.dart';
import 'package:bidding/main/bidder/controllers/ongoing_auction_controller.dart';
import 'package:bidding/main/bidder/screens/_bidder_screens.dart';
import 'package:bidding/models/item_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BidderHome extends StatelessWidget {
  const BidderHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: BidderSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Dashboard',
            body: _Content(),
            scrollable: false,
          ),
          BidderSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);
  final OngoingAuctionController itemListController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
      child: Column(children: [
        kIsWeb && Get.width >= 600
            ? Container(
                color: maroonColor,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Dashboard',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: whiteColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
        Expanded(
          child: ListView(
              padding: const EdgeInsets.all(15),
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    Container(
                      color: pinkColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  kIsWeb
                                      ? 'Start bidding to your \nfavorite items now!'
                                      : 'Start bidding to your favorite items now!',
                                  style: robotoBold.copyWith(
                                      color: whiteColor,
                                      fontSize: kIsWeb ? 45 : 41),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Start your Bid and Win your favorite item.',
                            style: robotoMedium.copyWith(
                                color: whiteColor, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              BidderSideMenuController menu = Get.find();
                              menu.changeActiveItem('Ongoing Auctions');
                              Get.to(() => const OngoingAuctionScreen());
                            },
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: whiteColor)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'View Ongoing Auctions',
                                    style: robotoMedium.copyWith(
                                        color: whiteColor, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(child: Obx(() => auctionsItems())),
                  ],
                ),
              ]),
        ),
      ]),
    );
  }

  Widget auctionsItems() {
    if (itemListController.isDoneLoading.value &&
        itemListController.itemList.isNotEmpty) {
      return ListView(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(kIsWeb ? 15 : 12),
          shrinkWrap: true,
          children: [
            Text(
              'Most Recent Auctions',
              style: robotoMedium.copyWith(color: blackColor, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            ResponsiveItemGrid(
              item: itemListController.itemList,
              firstRowOnly: true,
            ),
          ]);
    } else if (itemListController.isDoneLoading.value &&
        itemListController.itemList.isEmpty) {
      return const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: InfoDisplay(message: 'No ongoing auctions at the moment'));
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: maroonColor,
        ),
      ),
    );
  }
}

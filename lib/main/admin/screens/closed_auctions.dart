import 'package:bidding/components/_components.dart';
import 'package:bidding/components/data_table_format.dart';
import 'package:bidding/components/table_header_tile.dart';
import 'package:bidding/components/table_header_tile_mobile.dart';
import 'package:bidding/components/table_row_tile.dart';
import 'package:bidding/components/table_row_tile_mobile.dart';
import 'package:bidding/main/admin/controllers/closed_auction_controller.dart';
import 'package:bidding/main/admin/screens/open_closed_view.dart';
import 'package:bidding/main/admin/side_menu.dart';
import 'package:bidding/models/item_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ClosedAuctionScreen extends StatelessWidget {
  const ClosedAuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AdminSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Closed Auctions',
            body: _Content(),
          ),
          AdminSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);
  final ClosedAuctionController _closedAuction = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
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
                        'Closed Auctions',
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
          Flexible(child: Obx(() => showTableReport(context)))
        ],
      ),
    );
  }

  Widget searchBar() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Form(
            key: _closedAuction.formKey,
            child: InputField(
              hideLabelTyping: true,
              labelText: 'Search here...',
              onChanged: (value) {
                return;
              },
              onSaved: (value) => _closedAuction.titleKeyword.text = value!,
              controller: _closedAuction.titleKeyword,
              maxLines: 1,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          height: 45,
          child: kIsWeb && Get.width >= 600
              ? CustomButton(
                  onTap: () {
                    _closedAuction.filterItems();
                  },
                  text: 'Search',
                  buttonColor: maroonColor,
                  fontSize: 16,
                )
              : ElevatedButton(
                  onPressed: () {
                    _closedAuction.filterItems();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: maroonColor, //maroonColor
                  ),
                  child: const Icon(
                    Icons.search,
                    color: whiteColor,
                  ),
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          height: 45,
          child: kIsWeb && Get.width >= 600
              ? CustomButton(
                  onTap: () {
                    _closedAuction.refreshItem();
                  },
                  text: 'Refresh',
                  buttonColor: maroonColor,
                  fontSize: 16,
                )
              : ElevatedButton(
                  onPressed: () {
                    _closedAuction.refreshItem();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: maroonColor, //maroonColor
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: whiteColor,
                  ),
                ),
        ),
      ],
    );
  }

  Widget showTableReport(BuildContext context) {
    if (_closedAuction.isDoneLoading.value &&
        _closedAuction.closedItems.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 25, horizontal: kIsWeb ? 25 : 3),
        child: Column(
          children: [
            searchBar(),
            const SizedBox(
              height: 24,
            ),
            Flexible(
              child: Container(
                height: Get.height,
                color: whiteColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: kIsWeb && context.width >= 900
                          ? header()
                          : headerMobile(),
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemCount: _closedAuction.filtered.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (kIsWeb && context.width >= 900) {
                            return row(_closedAuction.filtered[index], context);
                          }
                          return rowMobile(
                              _closedAuction.filtered[index], context);
                        },
                      ),
                    ),
                    Visibility(
                      visible: _closedAuction.emptySearchResult,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 10),
                        child: NoDisplaySearchResult(
                          content: 'No item found with ',
                          title: '"${_closedAuction.searchKey}"',
                          message: ' in title',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_closedAuction.isDoneLoading.value &&
        _closedAuction.closedItems.isEmpty) {
      return const Center(
          child: InfoDisplay(message: 'No ongoing auction at the moment'));
    }
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget headerMobile() {
    return const TableHeaderTileMobile(
      headerText: [
        'Item',
        'Asking Price',
        'Highest Bid',
      ],
    );
  }

  Widget header() {
    return const TableHeaderTile(
      headerText: [
        'Item',
        'Date Closed',
        'Posted By',
        'Asking Price',
        'Status',
        'Highest Bid',
        'Action',
      ],
    );
  }

  Widget rowMobile(Item item, BuildContext context) {
    return TableRowTileMobile(
      rowData: [
        ImageView(
          imageUrl: item.images[0],
        ),
        InkWell(
          onTap: () => Get.to(() => OpenClosedItemView(item: item)),
          child: Text(
            item.title,
            style: robotoMedium.copyWith(
              color: Colors.blue,
            ),
          ),
        ),
        Text('₱ ${Format.amount(item.askingPrice)}'),
        FutureBuilder(
          future: item.getBids(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (item.bids.isEmpty) {
                return const Text(
                  '---',
                );
              }
              return Text('₱ ${Format.amount(item.bids[0].amount)}');
            }
            return const Text('     ');
          },
        ),
      ],
    );
  }

  Widget row(Item item, BuildContext context) {
    return TableRowTile(
      rowData: [
        ImageView(
          imageUrl: item.images[0],
        ),
        Text(item.title),
        Text(Format.dateShort(item.endDate)),
        FutureBuilder(
          future: item.getSellerInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(item.sellerInfo!.fullName);
            }
            return const Text('     ');
          },
        ),
        Text('₱ ${Format.amount(item.askingPrice)}'),
        item.winningBid == ''
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: const Color.fromARGB(241, 241, 243, 255)),
                child: Text(
                  'To Select',
                  style: robotoRegular.copyWith(color: blackColor),
                  textAlign: TextAlign.center,
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2), color: greenColor),
                child: Text(
                  'Winner Selected',
                  style: robotoRegular.copyWith(color: whiteColor),
                  textAlign: TextAlign.center,
                ),
              ),
        FutureBuilder(
          future: item.getBids(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (item.bids.isEmpty) {
                return const Text(
                  '---',
                );
              }
              return Text('₱ ${Format.amount(item.bids[0].amount)}');
            }
            return const Text('     ');
          },
        ),
        InkWell(
          onTap: () => Get.to(() => OpenClosedItemView(item: item)),
          child: Text(
            'View',
            style: robotoMedium.copyWith(
              color: maroonColor,
            ),
          ),
        )
      ],
    );
  }
}

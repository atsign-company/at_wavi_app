import 'dart:math';
import 'dart:typed_data';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_contacts_flutter/widgets/custom_circle_avatar.dart';
import 'package:at_wavi_app/common_components/contact_initial.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/common_functions.dart';
import 'package:flutter/material.dart';

class DesktopSwitchAccountPage extends StatefulWidget {
  final List<String> atSignList;
  final VoidCallback? onSuccess;
  final bool isCheckDeleteAccount;

  const DesktopSwitchAccountPage({
    Key? key,
    required this.atSignList,
    this.onSuccess,
    this.isCheckDeleteAccount = false,
  }) : super(key: key);

  @override
  _DesktopSwitchAccountPageState createState() =>
      _DesktopSwitchAccountPageState();
}

class _DesktopSwitchAccountPageState extends State<DesktopSwitchAccountPage> {
  BackendService backendService = BackendService();
  bool isLoading = false;
  var atClientPrefernce;

  @override
  Widget build(BuildContext context) {
    backendService
        .getAtClientPreference()
        .then((value) => atClientPrefernce = value);
    Random r = Random();
    return Stack(
      children: [
        Positioned(
          child: BottomSheet(
            onClosing: () {},
            backgroundColor: Colors.transparent,
            builder: (context) => ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Container(
                height: 100,
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.atSignList.length,
                      itemBuilder: (context, index) {
                        Uint8List? image = CommonFunctions()
                            .getCachedContactImage(widget.atSignList[index]);
                        return GestureDetector(
                          onTap: isLoading
                              ? () {}
                              : () async {
                                  if (!widget.isCheckDeleteAccount) {
                                    setState(() {});
                                    await backendService.onboard(
                                      widget.atSignList[index],
                                      onSuccess: widget.onSuccess,
                                    );
                                  } else {
                                    await backendService.resetDevice(
                                        [widget.atSignList[index]]);
                                    await backendService.onboardNextAtsign(
                                      isCheckDesktop: true,
                                    );
                                  }
                                },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10, top: 20),
                            child: Column(
                              children: [
                                Container(
                                  height: 40.toFont,
                                  width: 40.toFont,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, r.nextInt(255),
                                        r.nextInt(255), r.nextInt(255)),
                                    borderRadius:
                                        BorderRadius.circular(50.toWidth),
                                  ),
                                  child: Center(
                                    child: image != null
                                        ? CustomCircleAvatar(
                                            byteImage: image,
                                            nonAsset: true,
                                          )
                                        : ContactInitial(
                                            initials: widget.atSignList[index]),
                                  ),
                                ),
                                Text(widget.atSignList[index],
                                    style: TextStyle(
                                        fontSize: 15.toFont,
                                        color: Theme.of(context).primaryColor))
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Visibility(
                      visible: !widget.isCheckDeleteAccount,
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                            Navigator.pop(context);
                          });
                          setState(() {});
                          await backendService.onboard(
                            '',
                            isSwitchAccount: true,
                          );

                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 40,
                          width: 40,
                          child: Icon(Icons.add_circle_outline_outlined,
                              color: Colors.orange, size: 25.toFont),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

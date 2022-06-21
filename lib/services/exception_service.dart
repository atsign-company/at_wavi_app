import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_constants.dart';
import 'package:flutter/material.dart';

class ExceptionService {
  ExceptionService._();
  static final ExceptionService _instance = ExceptionService._();
  static ExceptionService get instance => _instance;
  OverlayEntry? exceptionOverlayEntry;

  showGenericExceptionOverlay(String errorMessage, {Function? onRetry}) async {
    _showExceptionOverlay(errorMessage, onRetry: onRetry);
  }

  showGetExceptionOverlay(Object e, {Function? onRetry}) async {
    var _error = getExceptions(e);
    _showExceptionOverlay(_error, onRetry: onRetry);
  }

  showPutExceptionOverlay(Object e, {Function? onRetry}) async {
    var _error = putExceptions(e);
    _showExceptionOverlay(_error, onRetry: onRetry);
  }

  showNotifyExceptionOverlay(Object e, {Function? onRetry}) async {
    var _error = notifyExceptions(e);
    _showExceptionOverlay(_error, onRetry: onRetry);
  }

  /// exceptions for get method
  String getExceptions(Object e) {
    switch (e.runtimeType) {
      case AtKeyException:
        return 'AtKeyException: Something went wrong';
      case AtDecryptionException:
        return 'AtDecryptionException: Decryption failed';
      case AtPrivateKeyNotFoundException:
        return 'AtPrivateKeyNotFoundException: Decryption failed';
      case AtPublicKeyChangeException:
        return 'AtPublicKeyChangeException: Decryption failed';
      case SharedKeyNotFoundException:
        return 'SharedKeyNotFoundException: Decryption failed';
      case SelfKeyNotFoundException:
        return 'SelfKeyNotFoundException: Decryption failed';
      case AtClientException:
        return 'AtClientException: Cloud secondary is invalid or not reachable';

      default:
        return 'Something went wrong !!!';
    }
  }

  /// exceptions for put method
  String putExceptions(Object e) {
    switch (e.runtimeType) {
      default:
        return 'Something went wrong !!!';
    }
  }

  /// exceptions for notify method
  String notifyExceptions(Object e) {
    switch (e.runtimeType) {
      case AtKeyException:
        return 'AtKeyException: Something went wrong';
      case InvalidAtSignException:
        return 'InvalidAtSignException: Invalid atsign';
      case AtClientException:
        return 'AtClientException: Encryption failed or cloud secondary not reachable';
      default:
        return 'Something went wrong !!!';
    }
  }

  //// UI part
  _showExceptionOverlay(String error, {Function? onRetry}) async {
    hideOverlay();

    exceptionOverlayEntry = _buildexceptionOverlayEntry(
      error,
      onRetry: onRetry,
    );
    NavService.navKey.currentState?.overlay?.insert(exceptionOverlayEntry!);

    await Future.delayed(Duration(seconds: 5));
    hideOverlay();
  }

  hideOverlay() {
    exceptionOverlayEntry?.remove();
    exceptionOverlayEntry = null;
  }

  OverlayEntry _buildexceptionOverlayEntry(String error, {Function? onRetry}) {
    Color bgColor = ColorConstants.red;

    return OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        width: size.width,
        height: 80,
        bottom: 0,
        child: Material(
          child: Container(
            alignment: Alignment.center,
            color: bgColor,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 3, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '$error',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.toFont,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  onRetry != null
                      ? TextButton(
                          onPressed: () {
                            hideOverlay();
                            onRetry();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                            ),
                            child: Text(
                              Strings.buttonRetry,
                              style: TextStyle(
                                color: ColorConstants.FONT_PRIMARY,
                                fontSize: 15.toFont,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

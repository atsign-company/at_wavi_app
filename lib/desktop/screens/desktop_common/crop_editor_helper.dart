import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';

import 'package:http_client_helper/http_client_helper.dart';
import 'package:image/image.dart';

Future<Uint8List?> cropImageDataWithDartLibrary(
    {required ExtendedImageEditorState state}) async {
  print('dart library start cropping');

  ///crop rect base on raw image
  final Rect? cropRect = state.getCropRect();

  print('getCropRect : $cropRect');

  // in web, we can't get rawImageData due to .
  // using following code to get imageCodec without download it.
  // final Uri resolved = Uri.base.resolve(key.url);
  // // This API only exists in the web engine implementation and is not
  // // contained in the analyzer summary for Flutter.
  // return ui.webOnlyInstantiateImageCodecFromUrl(
  //     resolved); //

  final Uint8List data = kIsWeb &&
          state.widget.extendedImageState.imageWidget.image
              is ExtendedNetworkImageProvider
      ? await _loadNetwork(state.widget.extendedImageState.imageWidget.image
          as ExtendedNetworkImageProvider)

      ///toByteData is not work on web
      ///https://github.com/flutter/flutter/issues/44908
      // (await state.image.toByteData(format: ui.ImageByteFormat.png))
      //     .buffer
      //     .asUint8List()
      : state.rawImageData;

  final EditActionDetails editAction = state.editAction!;

  final DateTime time1 = DateTime.now();

  //Decode source to Animation. It can holds multi frame.
  Image? src;
  //LoadBalancer lb;
  if (kIsWeb) {
    src = decodeImage(data);
  } else {
    src = await compute(decodeImage, data);
  }
  if (src != null) {
    //handle every frame.
    src.frames = src.frames.map((Image image) {
      final DateTime time2 = DateTime.now();
      //clear orientation
      image = bakeOrientation(image);

      if (editAction.needCrop) {
        image = copyCrop(
          image,
          x: cropRect!.left.toInt(),
          y: cropRect.top.toInt(),
          width: cropRect.width.toInt(),
          height: cropRect.height.toInt(),
        );
      }

      if (editAction.needFlip) {
        late FlipDirection mode;
        if (editAction.flipY && editAction.flipX) {
          mode = FlipDirection.both;
        } else if (editAction.flipY) {
          mode = FlipDirection.horizontal;
        } else if (editAction.flipX) {
          mode = FlipDirection.vertical;
        }
        image = flip(image, direction: mode);
      }

      if (editAction.hasRotateAngle) {
        image = copyRotate(image, angle: editAction.rotateAngle);
      }
      final DateTime time3 = DateTime.now();
      print('${time3.difference(time2)} : crop/flip/rotate');
      return image;
    }).toList();
  }

  /// you can encode your image
  ///
  /// it costs much time and blocks ui.
  //var fileData = encodeJpg(src);

  /// it will not block ui with using isolate.
  //var fileData = await compute(encodeJpg, src);
  //var fileData = await isolateEncodeImage(src);
  List<int>? fileData;
  print('start encode');
  final DateTime time4 = DateTime.now();
  if (src != null) {
    final bool onlyOneFrame = src.numFrames == 1;
    //If there's only one frame, encode it to jpg.
    if (kIsWeb) {
      fileData = onlyOneFrame ? encodeJpg(src) : encodeGif(src);
    } else {
      //fileData = await lb.run<List<int>, Image>(encodeJpg, src);
      fileData = onlyOneFrame
          ? await compute(encodeJpg, src)
          : await compute(encodeGif, src);
    }
  }
  final DateTime time5 = DateTime.now();
  print('${time5.difference(time4)} : encode');
  print('${time5.difference(time1)} : total time');
  return Uint8List.fromList(fileData!);
}

Future<dynamic> isolateDecodeImage(List<int> data) async {
  final ReceivePort response = ReceivePort();
  await Isolate.spawn(_isolateDecodeImage, response.sendPort);
  final dynamic sendPort = await response.first;
  final ReceivePort answer = ReceivePort();
  // ignore: always_specify_types
  sendPort.send([answer.sendPort, data]);
  return answer.first;
}

Future<dynamic> isolateEncodeImage(Image src) async {
  final ReceivePort response = ReceivePort();
  await Isolate.spawn(_isolateEncodeImage, response.sendPort);
  final dynamic sendPort = await response.first;
  final ReceivePort answer = ReceivePort();
  // ignore: always_specify_types
  sendPort.send([answer.sendPort, src]);
  return answer.first;
}

void _isolateDecodeImage(SendPort port) {
  final ReceivePort rPort = ReceivePort();
  port.send(rPort.sendPort);
  rPort.listen((dynamic message) {
    final SendPort send = message[0] as SendPort;
    final List<int> data = message[1] as List<int>;
    send.send(decodeImage(Uint8List.fromList(data)));
  });
}

void _isolateEncodeImage(SendPort port) {
  final ReceivePort rPort = ReceivePort();
  port.send(rPort.sendPort);
  rPort.listen((dynamic message) {
    final SendPort send = message[0] as SendPort;
    final Image src = message[1] as Image;
    send.send(encodeJpg(src));
  });
}

/// it may be failed, due to Cross-domain
Future<Uint8List> _loadNetwork(ExtendedNetworkImageProvider key) async {
  try {
    final Response? response = await HttpClientHelper.get(Uri.parse(key.url),
        headers: key.headers,
        timeLimit: key.timeLimit,
        timeRetry: key.timeRetry,
        retries: key.retries,
        cancelToken: key.cancelToken);
    return response!.bodyBytes;
  } on OperationCanceledError catch (_) {
    print('User cancel request ${key.url}.');
    return Future<Uint8List>.error(
        StateError('User cancel request ${key.url}.'));
  } catch (e) {
    return Future<Uint8List>.error(StateError('failed load ${key.url}. \n $e'));
  }
}

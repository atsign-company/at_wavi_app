import 'dart:io';
import 'dart:typed_data';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class StorjService {
  StorjService._();
  static final StorjService _instance = StorjService._();
  factory StorjService() => _instance;

  Directory? appDocumentsDir;

  var nonceUrl = MixedConstants.NONCE_URL;
  var imageApiKey = MixedConstants.IMAGE_API_KEY;
  late String atSignPrivateKey;
  late String currentAtsign;

  Future<void> init() async {
    appDocumentsDir = await getApplicationDocumentsDirectory();

    // Get current atSign
    var atsign =
        AtClientManager.getInstance().atClient.getCurrentAtSign() ?? "";

    // Remove the @ symbol from the atSign
    if (atsign.contains("@")) {
      currentAtsign = atsign.split("@").last;
    }

    // Gets the private key for the current atSign
    var atChopsKey =
        AtClientManager.getInstance().atClient.atChops?.atChopsKeys;
    atSignPrivateKey =
        atChopsKey?.atEncryptionKeyPair?.atPrivateKey.privateKey ?? "";
  }

  Future<String> getInitialUrl(String name) async {
    String fileName = '$name.png';
    var nonce = await getnonce();
    var signedNonce = await signNonce(nonce);
    String url =
        "https://tokengateway-15s2e94o.uc.gateway.dev/gettoken?key=$imageApiKey&atsign=$currentAtsign&nonce=$nonce&signednonce=$signedNonce&filename=$fileName";
    return url;
  }

  Future<String> getnonce() async {
    String url = nonceUrl + imageApiKey;
    var res = await http.get(Uri.parse(url));
    return res.body;
  }

  Future<String> signNonce(String nonce) async {
    var privateKey = """-----BEGIN PRIVATE KEY-----
    $atSignPrivateKey
-----END PRIVATE KEY-----""";

    var signature = await RSA.signPSS(
      nonce,
      Hash.SHA256,
      SaltLength.EQUALS_HASH,
      privateKey,
    );

    var signatureB64url =
        signature.replaceAll("+", "-").replaceAll("/", "_").replaceAll("=", "");
    return signatureB64url;
  }

  // runs a cleanup operation on appdirectory
  // removes the the images that are not referenced in any persona
  void fileCleanup(
      BuzzkeyType buzzkeyType, String personaId, List<String> imageKeys) {
    var directory = getDirectoryPath();

    try {
      if (directory.existsSync()) {
        var fileList = directory.listSync();

        for (var file in fileList) {
          var isFilePresent = false;
          for (var imageKey in imageKeys) {
            String fileName = imageKey.split(".").last;
            if (file.path.contains(fileName)) {
              isFilePresent = true;
              break;
            }
          }
          if (isFilePresent == false) {
            file.deleteSync(recursive: true);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  /// file upload/download feature is removed till storj prod api is available.
  Future<String?> uploadFile(File image, String fileName) async {
    // String fileName = key.split(".").last;

    // var imageBytes = image.readAsBytesSync();
    var postPresignedUrl = await getInitialUrl(fileName);

    if (postPresignedUrl == null) {
      return null;
    }

    try {
      // post image bytes
      var res = await http.post(Uri.parse(postPresignedUrl), headers: {
        "Content-Length": "0",
      });

      var putUri = Uri.parse(res.body);
      final streamedRequest = http.StreamedRequest('PUT', putUri);

      var imageLength = await image.length();
      streamedRequest.contentLength = imageLength;

      image.openRead().listen((chunk) {
        streamedRequest.sink.add(chunk);
      }, onDone: () {
        streamedRequest.sink.close();
      });

      http.StreamedResponse response = await streamedRequest.send();

      if (response.statusCode == 200) {
        var getPresignedUrl = await getInitialUrl(fileName);
        var shareableLink = await http.get(Uri.parse(getPresignedUrl));
        if (shareableLink.statusCode == 200) {
          saveImageToFile(fileName, image.readAsBytesSync());
        }
        return shareableLink.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Gets the image directory path based on the persona id and buzzkeyType
  Directory getDirectoryPath() {
    final path =
        "${appDocumentsDir!.path}${Platform.pathSeparator}wavi_image_cache";
    return Directory(path);
  }

  fetchAtkeyDate(String name) async {
    var res = await AtClientManager.getInstance().atClient.getAtKeys(
          regex: name,
        );
    var metaData = await AtClientManager.getInstance().atClient.getMeta(res[0]);
    return metaData?.updatedAt?.toLocal() ?? DateTime.now();
  }

  // Checks if the image already exists in the the directory
  Future<bool> checkIfFileExists(String name) async {
    try {
      var directory = getDirectoryPath();
      String fileName = '$name.png';
      File file = File('${directory.path}${Platform.pathSeparator}$fileName');

      // If the cached received file is older the the latest file then return false
      var stats = file.statSync();
      DateTime atKeyDate = await fetchAtkeyDate(name);
      if (stats.modified.isBefore(atKeyDate)) {
        return false;
      }

      return file.existsSync();
    } catch (e) {
      return false;
    }
  }

  // Gets the image from the directory
  File? getImageFromFile(String name) {
    var directory = getDirectoryPath();
    String fileName = '$name.png';
    File file = File('${directory.path}${Platform.pathSeparator}$fileName');
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  // Saves the image to the directory
  File saveImageToFile(String name, Uint8List imageBytes) {
    String fileName = '$name.png';
    var directory = getDirectoryPath();
    // Create the directory if it doesn't exist
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    File file = File('${directory.path}${Platform.pathSeparator}$fileName');
    file.writeAsBytesSync(imageBytes, flush: true);

    return file;
  }

  // Deletes the image from the directory
  void deleteImageFromFile(String name) {
    var directory = getDirectoryPath();
    // Create the directory if it doesn't exist
    if (!directory.existsSync()) {
      return;
    }
    String fileName = '$name.png';
    File file = File('${directory.path}${Platform.pathSeparator}$fileName');
    file.deleteSync(recursive: true);
  }

  Future<File?> getFile(String key, String url) async {
    String fileName = key;

    if (await checkIfFileExists(fileName)) {
      var res = getImageFromFile(fileName);
      if (res != null) {
        return res;
      }
    }

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "image/png"},
      );

      if (response.statusCode == 200) {
        var res = saveImageToFile(fileName, response.bodyBytes);
        return res;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteFile(String name) async {
    String fileName = '$name.png';
    var postPresignedUrl = await getInitialUrl(fileName);

    if (postPresignedUrl == null) {
      return false;
    }

    try {
      // post image bytes
      var res = await http.post(Uri.parse(postPresignedUrl), headers: {
        "Content-Length": "0",
      });

      var response = await http.put(
        Uri.parse(res.body),
        body: null,
        headers: {"Content-Length": "0", "Content-Type": "image/png"},
      );
      if (response.statusCode == 200) {
        deleteImageFromFile(fileName);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

enum BuzzkeyType { sent, received }

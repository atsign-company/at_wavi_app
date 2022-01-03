import 'package:at_wavi_app/desktop/utils/utils.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/cupertino.dart';

class DesktopAddLocationModel extends ChangeNotifier {
  final UserPreview userPreview;

  CustomContentType _fieldType = CustomContentType.Text;

  CustomContentType get fieldType => _fieldType;

  OsmLocationModel? _osmLocationModel;

  OsmLocationModel? get osmLocationModel => _osmLocationModel;

  BasicData? _data;

  BasicData? get data => _data;
  late bool _isPrivate;
  String _locationString = '';

  var locationTextController = TextEditingController();
  var tagTextController = TextEditingController();

  DesktopAddLocationModel({required this.userPreview}) {
    _data = userPreview.user()!.location;
    _isPrivate = userPreview.user()!.location.isPrivate;

    // _osmLocationModel = OsmLocationModel(
    //   "Ha Noi",
    //   10,
    //   14,
    //   latitude: 21.028511,
    //   longitude: 105.804817,
    //   diameter: 10,
    // );
  }

  void changeField(CustomContentType fieldType) {
    _fieldType = fieldType;
    notifyListeners();
  }

  void changeLocation(OsmLocationModel osmLocationModel) {
    _osmLocationModel = osmLocationModel;
    notifyListeners();
  }

  Future saveData(BuildContext context) async {
    if (osmLocationModel != null) {
      var basicData = BasicData(
        accountName: tagTextController.text,
        value: OsmLocationModel(
          tagTextController.text,
          osmLocationModel!.radius,
          osmLocationModel!.zoom,
          latitude: osmLocationModel!.latitude,
          longitude: osmLocationModel!.longitude,
          diameter: osmLocationModel!.diameter,
        ).toJson(),
      );

      List<BasicData>? customFields =
          userPreview.user()!.customFields[AtCategory.LOCATION.name];
      customFields!.add(basicData);

      userPreview.user()?.customFields[AtCategory.LOCATION.name] = customFields;

      FieldOrderService()
          .addNewField(AtCategory.LOCATION, basicData.accountName!);

      Navigator.of(context).pop('saved');
    } else {
      Navigator.of(context).pop();
    }
  }
}

import 'package:at_wavi_app/desktop/widgets/desktop_empty_widget.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/images.dart';
import 'package:flutter/material.dart';

class DesktopEmptyCategoryWidget extends StatelessWidget {
  final AtCategory atCategory;
  final bool showAddButton;
  final VoidCallback onAddDetailsPressed;

  const DesktopEmptyCategoryWidget({Key? key, 
    required this.atCategory,
    required this.showAddButton,
    required this.onAddDetailsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DesktopEmptyWidget(
      image: Image.asset(
        atCategory.imageData,
        width: 180,
        height: 180,
      ),
      title: atCategory.title,
      description: atCategory.description,
      buttonTitle: atCategory.titleButton,
      onButtonPressed: onAddDetailsPressed,
      showAddButton: showAddButton,
    );
  }
}

extension AtCategoryExt on AtCategory {
  String get imageData {
    switch (this) {
      case AtCategory.IMAGE:
        return Images.introMedia;
      case AtCategory.DETAILS:
        return Images.introBasicDetail;
      case AtCategory.ADDITIONAL_DETAILS:
        return Images.introAdditionalDetail;
      case AtCategory.LOCATION:
        return Images.introLocation;
      case AtCategory.SOCIAL:
        return Images.introSocialChannel;
      case AtCategory.GAMER:
        return Images.introGameChannel;
      default:
        return Images.introBasicDetail;
    }
  }

  String get titleButton {
    switch (this) {
      case AtCategory.IMAGE:
        return 'Add details';
      case AtCategory.DETAILS:
        return 'Add Contact Details';
      case AtCategory.ADDITIONAL_DETAILS:
        return 'Add About Info';
      case AtCategory.LOCATION:
        return 'Add your Location details';
      case AtCategory.SOCIAL:
        return 'Add Social';
      case AtCategory.GAMER:
        return 'Add Gaming';
      default:
        return '';
    }
  }

  String get title {
    switch (this) {
      case AtCategory.IMAGE:
        return 'Add your Media details';
      case AtCategory.DETAILS:
        return 'Start with your contact details';
      case AtCategory.ADDITIONAL_DETAILS:
        return 'Add your about info';
      case AtCategory.LOCATION:
        return 'Add your Location details';
      case AtCategory.SOCIAL:
        return 'Add your Social';
      case AtCategory.GAMER:
        return 'Add your gaming info';
      default:
        return '';
    }
  }

  String get titlePage {
    switch (this) {
      case AtCategory.IMAGE:
        return 'Let’s add to your atWavi';
      case AtCategory.DETAILS:
        return 'Let’s create your atWavi';
      case AtCategory.ADDITIONAL_DETAILS:
        return 'Let’s add to your atWavi';
      case AtCategory.LOCATION:
        return 'Add your Location details';
      case AtCategory.SOCIAL:
        return 'Let’s add to your atWavi';
      case AtCategory.GAMER:
        return 'Let’s add to your atWavi';
      default:
        return '';
    }
  }

  String get description {
    switch (this) {
      case AtCategory.IMAGE:
        return 'Add media details to start\nsharing your profile with others.';
      case AtCategory.DETAILS:
        return 'Remember, this information will be public, unless you select “Hide.”';
      case AtCategory.ADDITIONAL_DETAILS:
        return 'Add more about you to your atWavi.';
      case AtCategory.LOCATION:
        return 'Add location details to start sharing your profile with others.';
      case AtCategory.SOCIAL:
        return 'Display your social links on your atWavi.';
      case AtCategory.GAMER:
        return 'Display your gaming links on your atWavi.';
      default:
        return '';
    }
  }
}

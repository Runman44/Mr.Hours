import 'dart:io';

import 'package:eventtracker/bloc/settings_bloc.dart';
import 'package:eventtracker/ui/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    void _selectImage(File savedImage) {
      BlocProvider.of<SettingsBloc>(context).add(ChangeLogo(savedImage));
    }

    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ImageInput(
              logo: state.settings.logo,
              onSelectImage: _selectImage,
            ),
          ),
          Divider(),
          SwitchListTile(
            title: Text("dark_mode".tr()),
            value: state.settings.darkMode,
            onChanged: (newValue) {
              BlocProvider.of<SettingsBloc>(context).add(ToggleDarkMode(newValue));
            },
          ),
          ListTile(
            title: Text("feedback".tr()),
            onTap: () {
              var uriFeedback = Uri(
                  scheme: 'mailto',
                  path: 'askmranderson@gmail.com',
                  queryParameters: {
                    'subject': 'feedback_subject_mail'.tr()
                  }).toString();
              launch(uriFeedback);
            },
          ),
          ListTile(
            title: Text("review".tr()),
              onTap: () {
                final InAppReview inAppReview = InAppReview.instance;
                inAppReview.isAvailable().then((bool isAvailable) {
                  inAppReview.requestReview();
                });
              },
          ),
        ],
      );
    });
  }
}

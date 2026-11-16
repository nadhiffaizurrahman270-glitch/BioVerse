import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// Tombol resmi Google Identity Services untuk Flutter Web.
/// (google_sign_in v7 tidak mendukung authenticate() di web.)
Widget buildGoogleWebButton() {
  return web.renderButton(
    configuration: web.GSIButtonConfiguration(
      type: web.GSIButtonType.standard,
      theme: web.GSIButtonTheme.outline,
      size: web.GSIButtonSize.large,
      text: web.GSIButtonText.continueWith,
      shape: web.GSIButtonShape.rectangular,
      minimumWidth: 360,
    ),
  );
}

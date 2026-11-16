import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as gsi_web;

/// Flutter Web: tombol resmi Google Identity Services.
/// Hasil login diterima lewat GoogleSignIn.instance.authenticationEvents
/// (lihat AuthService.googleAuthEvents), bukan lewat onPressed.
Widget buildGoogleWebButton() {
  return gsi_web.renderButton(
    configuration: gsi_web.GSIButtonConfiguration(
      type: gsi_web.GSIButtonType.standard,
      theme: gsi_web.GSIButtonTheme.outline,
      size: gsi_web.GSIButtonSize.large,
      text: gsi_web.GSIButtonText.continueWith,
      shape: gsi_web.GSIButtonShape.rectangular,
      minimumWidth: 320,
    ),
  );
}

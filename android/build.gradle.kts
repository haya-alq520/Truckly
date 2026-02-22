name: truckly
description: Truckly Flutter App
publish_to: "none"

version: 1.0.0+1

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.6

  # Supabase
  supabase_flutter: ^2.5.6

  # Navigation
  go_router: ^14.8.1

  # UI Fonts
  google_fonts: ^6.3.3

  # ✅ Open Google Maps / external links
  url_launcher: ^6.3.0

  # ✅ Pick images for reviews/owner forms
  image_picker: ^1.1.2

  # ✅ Generate IDs for storage paths, etc.
  uuid: ^4.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^3.0.2

flutter:
  uses-material-design: true
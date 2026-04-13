
import 'dart:io';

final goldVersions = {
  'packages/firebase_in_app_messaging/firebase_in_app_messaging/pubspec.yaml': '0.9.1',
  'packages/firebase_in_app_messaging/firebase_in_app_messaging_platform_interface/pubspec.yaml': '0.2.5+19',
  'packages/_flutterfire_internals/pubspec.yaml': '1.3.68',
  'packages/firebase_crashlytics/firebase_crashlytics/pubspec.yaml': '5.1.0',
  'packages/firebase_crashlytics/firebase_crashlytics_platform_interface/pubspec.yaml': '3.8.19',
  'packages/firebase_auth/firebase_auth/pubspec.yaml': '6.3.0',
  'packages/firebase_auth/firebase_auth_web/pubspec.yaml': '6.1.4',
  'packages/firebase_auth/firebase_auth_platform_interface/pubspec.yaml': '8.1.8',
  'packages/firebase_remote_config/firebase_remote_config/pubspec.yaml': '6.3.0',
  'packages/firebase_remote_config/firebase_remote_config_web/pubspec.yaml': '1.10.5',
  'packages/firebase_remote_config/firebase_remote_config_platform_interface/pubspec.yaml': '2.1.1',
  'packages/firebase_database/firebase_database_web/pubspec.yaml': '0.2.7+5',
  'packages/firebase_database/firebase_database/pubspec.yaml': '12.2.0',
  'packages/firebase_database/firebase_database_platform_interface/pubspec.yaml': '0.3.1',
  'packages/cloud_firestore/cloud_firestore_web/pubspec.yaml': '5.2.0',
  'packages/cloud_firestore/cloud_firestore/pubspec.yaml': '6.2.0',
  'packages/cloud_firestore/cloud_firestore_platform_interface/pubspec.yaml': '7.1.0',
  'packages/firebase_app_installations/firebase_app_installations_web/pubspec.yaml': '0.1.7+4',
  'packages/firebase_app_installations/firebase_app_installations/example/pubspec.yaml': '1.0.0+1',
  'packages/firebase_app_installations/firebase_app_installations/pubspec.yaml': '0.4.1',
  'packages/firebase_app_installations/firebase_app_installations_platform_interface/pubspec.yaml': '0.1.4+67',
  'packages/firebase_messaging/firebase_messaging_web/pubspec.yaml': '4.1.4',
  'packages/firebase_messaging/firebase_messaging/pubspec.yaml': '16.1.3',
  'packages/firebase_messaging/firebase_messaging_platform_interface/pubspec.yaml': '4.7.8',
  'packages/firebase_data_connect/firebase_data_connect/example/pubspec.yaml': '1.0.0+1',
  'packages/firebase_data_connect/firebase_data_connect/pubspec.yaml': '0.2.4',
  'packages/firebase_core/firebase_core_web/pubspec.yaml': '3.5.1',
  'packages/firebase_core/firebase_core/pubspec.yaml': '4.6.0',
  'packages/firebase_core/firebase_core_platform_interface/pubspec.yaml': '6.0.3',
  'packages/firebase_analytics/firebase_analytics_platform_interface/pubspec.yaml': '5.1.0',
  'packages/firebase_analytics/firebase_analytics/pubspec.yaml': '12.2.0',
  'packages/firebase_analytics/firebase_analytics_web/pubspec.yaml': '0.6.1+4',
  'packages/firebase_ml_model_downloader/firebase_ml_model_downloader/pubspec.yaml': '0.4.1',
  'packages/firebase_ml_model_downloader/firebase_ml_model_downloader_platform_interface/pubspec.yaml': '0.1.5+19',
  'packages/firebase_app_check/firebase_app_check_platform_interface/pubspec.yaml': '0.2.2',
  'packages/firebase_app_check/firebase_app_check/example/pubspec.yaml': '1.0.0+1',
  'packages/firebase_app_check/firebase_app_check/pubspec.yaml': '0.4.2',
  'packages/firebase_app_check/firebase_app_check_web/pubspec.yaml': '0.2.3',
  'packages/firebase_ai/firebase_ai/example/pubspec.yaml': '1.0.0+1',
  'packages/firebase_ai/firebase_ai/pubspec.yaml': '3.10.0',
  'packages/cloud_functions/cloud_functions_web/pubspec.yaml': '5.1.4',
  'packages/cloud_functions/cloud_functions/pubspec.yaml': '6.1.0',
  'packages/cloud_functions/cloud_functions_platform_interface/pubspec.yaml': '5.8.11',
  'packages/firebase_storage/firebase_storage_web/pubspec.yaml': '3.11.4',
  'packages/firebase_storage/firebase_storage_platform_interface/pubspec.yaml': '5.2.19',
  'packages/firebase_storage/firebase_storage/pubspec.yaml': '13.2.0',
  'packages/firebase_performance/firebase_performance_platform_interface/pubspec.yaml': '0.1.6+6',
  'packages/firebase_performance/firebase_performance_web/pubspec.yaml': '0.1.8+4',
  'packages/firebase_performance/firebase_performance/example/pubspec.yaml': '0.0.1',
  'packages/firebase_performance/firebase_performance/pubspec.yaml': '0.11.2',
  'tests/pubspec.yaml': '1.0.0+1',
};

void main() {
  for (var entry in goldVersions.entries) {
    final file = File(entry.key);
    if (!file.existsSync()) {
      print('Warning: ${entry.key} not found.');
      continue;
    }
    var content = file.readAsStringSync();
    
    // Restore version
    content = content.replaceFirst(RegExp(r'^version: .*', multiLine: true), 'version: ${entry.value}');
    
    // Loosen internal firebase constraints to 'any' to unblock solving
    final firebasePackages = [
      'firebase_core',
      'firebase_core_platform_interface',
      'firebase_core_web',
      'firebase_auth',
      'firebase_auth_platform_interface',
      'firebase_auth_web',
      'cloud_firestore',
      'cloud_firestore_platform_interface',
      'cloud_firestore_web',
      'firebase_database',
      'firebase_database_platform_interface',
      'firebase_database_web',
      'firebase_storage',
      'firebase_storage_platform_interface',
      'firebase_storage_web',
      'firebase_messaging',
      'firebase_messaging_platform_interface',
      'firebase_messaging_web',
      'firebase_analytics',
      'firebase_analytics_platform_interface',
      'firebase_analytics_web',
      'firebase_app_check',
      'firebase_app_check_platform_interface',
      'firebase_app_check_web',
      'firebase_app_installations',
      'firebase_app_installations_platform_interface',
      'firebase_app_installations_web',
      'firebase_performance',
      'firebase_performance_platform_interface',
      'firebase_performance_web',
      'firebase_remote_config',
      'firebase_remote_config_platform_interface',
      'firebase_remote_config_web',
      'firebase_ml_model_downloader',
      'firebase_ml_model_downloader_platform_interface',
      'firebase_data_connect',
      'firebase_ai',
      '_flutterfire_internals',
    ];

    for (var pkg in firebasePackages) {
      // Replace constraints like "firebase_core: ^4.6.0" with "firebase_core: any"
      // But only if it's not a path dependency
      content = content.replaceAllMapped(
        RegExp('^  $pkg: (?!{path:).*', multiLine: true),
        (match) => '  $pkg: any',
      );
    }

    file.writeAsStringSync(content);
    print('Updated ${entry.key}');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/model/visit.dart';
import 'package:trailya/utils/date_util.dart';

Future<void> showAboutDialog(
  BuildContext context,
  PackageInfo packageInfo,
) async {
  final versionInfo =
      'Version: v${packageInfo.version}(${packageInfo.buildNumber})';
  final developerInfo = 'developer@trailya.app';

  return showAlertDialog(
    context,
    title: packageInfo.appName,
    content: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(versionInfo),
            SizedBox(height: 8.0),
            Text(
              developerInfo,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    ),
    defaultActionText: 'OK',
  );
}

Future<bool?> showSiteDialog({
  required BuildContext context,
  required Site site,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              site.title,
              textAlign: TextAlign.center,
            ),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    '${site.address}, ${site.suburb}, ${site.state}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Exposure Time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    '${formatDate(site.start)} to ${formatDate(site.end)}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Site Added',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    formatDate(site.addedTime),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Location (lat,long)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    '${site.lat!.toStringAsFixed(3)}, ${site.lng!.toStringAsFixed(3)}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(child: Text('OK')),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

Future<bool?> showVisitDialog({
  required BuildContext context,
  required Visit visit,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Column(
              children: [
                Text(
                  'You were here',
                  textAlign: TextAlign.center,
                ),
                if (visit.exposed)
                  Text(
                    '(possible exposure)',
                    style: TextStyle(color: Colors.red.shade300),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    'Visit Time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    '${formatDate(visit.start)} to ${formatDate(visit.end)}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Location (lat,long)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    '${visit.loc.latitude!.toStringAsFixed(5)}, ${visit.loc.longitude!.toStringAsFixed(5)}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(child: Text('OK')),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

Future showAlertDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  String? cancelActionText,
  required String defaultActionText,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelActionText),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(defaultActionText),
          ),
        ],
      ),
    );

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: Text(_message(exception)),
      defaultActionText: 'OK',
    );

String _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message!;
  }
  return exception.toString();
}

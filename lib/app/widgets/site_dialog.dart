import 'package:flutter/material.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/utils/date_util.dart';

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
                    '${formatDate(site.exposureStartTime)} to ${formatDate(site.exposureEndTime)}',
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

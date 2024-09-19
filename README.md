# Flutter Deferred Deep Linking Example

* Flutter Example App - folder flutter_ddl_example/
* Strapi API
* Frontend App
* nginx configs - folder nginx/
* json files for universal links checking - folder assetlinks/


## Assetlinks files

Flutter has built-in Deep Linking support, based on the platform-specific implementation.

### Example of file assetlinks.json (Android):

Host an assetlinks.json file in using a web server with a domain that you own. 
The path should be https://<your-domain>/.well-known/assetlinks.json
This file tells the mobile browser which Android application to open instead of the browser. To create the file, get the package name of the Flutter app you created and the sha256 fingerprint of the signing key you will be using to build the APK.

File for this project: https://mobile-apps-examples.23devs.com/.well-known/assetlinks.json

Insert your own package name and fingerprint.

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.u23devs.flutter_ddl_example",
    "sha256_cert_fingerprints":
    ["E3:7F:FD:3B:7D:92:99:9D:3E:8F:54:E2:55:AD:9A:F4:A1:01:5A:55:E2:E8:33:B4:06:B1:71:54:39:21:74:57"]
  }
}]
```

How to get the sha256 fingerprint:

1) If app is already in your Google Play console, navigate to Release> Setup > App Integrity> App Signing tab. Copy SHA 256 signing certificate fingerprint.

2) If app is not in the store yet, generate signing key (for release build):

```sh
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

This will generate file upload-keystore.jks, which can be moved to your flutter project in android folder (it should be ignore by git!).
To get sha 256 cert fingerprint from this file execute this command from directory where it's located:

```sh
keytool -list -v -keystore upload-keystore.jks
```

Copy SHA 256 signing certificate fingerprint data from terminal.

Documentation:
https://docs.flutter.dev/cookbook/navigation/set-up-app-links
https://developer.android.com/training/app-links/verify-android-applinks 


### Example of file apple-app-site-association (iOS):

For Universal links in iOS app you need to host an apple-app-site-association file in your dedicated web domain. This file tells the mobile browser which iOS application to open instead of the browser. To create the file, find the appID of the Flutter app you created.

Apple formats the appID as <team id>.<bundle id>.

Locate the bundle ID in the Xcode project.
Locate the team ID in the developer account.

For example: Given a team ID of S8QB4VV633 and a bundle ID of com.example.deeplinkCookbook, You would enter an appID entry of S8QB4VV633.com.example.deeplinkCookbook.

This file uses the JSON format. Don't include the .json file extension when you save this file. 

File example (for this project):

```json
{
  "applinks":{
    "apps":[],
    "details":[
      {
        "appIDs":[
          "QGW6TP9GF7.com.23devs.flutter_ddl_example"
        ],
        "components":[
          {
            "/":"/details/*",
            "comment":"Matches any URL with a path that starts with /details/."
          }
        ]
      }
    ]
  }
}
```

Host the file at a URL that resembles the following structure:
https://<your-domain>/.well-known/apple-app-site-association

Verify that your browser can access this file. It should have application/json format.

Documentation:
https://docs.flutter.dev/cookbook/navigation/set-up-universal-links
https://developer.apple.com/documentation/xcode/supporting-associated-domains

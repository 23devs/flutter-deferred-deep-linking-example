# Flutter Deferred Deep Linking Example

* Flutter Example App - folder flutter_ddl_example/
* Strapi API - folder strapi_app/
* frontend App - folder fingerprint_scanner_web_app
* nginx configs - folder nginx/
* json files for universal links checking - folder assetlinks/

## Video examples

The user scans QR code which contains a link to a specific details, e.g. https://mobile-apps-examples.23devs.com/details/4

If the app is not installed yet, it opens the page to install app (in example it's just a simple web page with "Download" button, but it could also be google play or App store url), after the app is installed and opened, it shows specific screen for the Detail 4.


https://github.com/user-attachments/assets/22f19620-ab33-44e4-82dd-e19938960048


If the app is installed on the device, it opens specific screen for the needed Detail in the app.


https://github.com/user-attachments/assets/be6fa51b-bc90-4663-bd9d-5bbd2d032fc4



## Flutter Example App

The example app consists of 3 screens:

* home screen (path '/') - has a button to navigate to details screen.

Before accessing this screen the Go Router checks if the app was launched for the first time, if it was, checks if the user was needed to be navigated with link. If not, navigates to home screen. If it was launched for first time and it gets the data that user tried to open a specific link, it opens this link. If it does get error, it just opens Home Screen.

* details screen (path '/details') - it shows a list of available details from 1 to 5. By clicking on the item you can access its detail screen.
* detail screen (path '/details/:id') - this is the screen showing the data for specific item from the list which has a certain id. So it could be /details/1 or /details/4, etc. It just shows item name with its id.

The idea is that when someone opens a link like https://mobile-apps-examples.23devs.com/details/3 from browser or by scanning qr code with this link, the app opens and the user is navigated directly to /details/3 screen. 

If the user hasn't the app installed yet, they are navigated to https://mobile-apps-examples.23devs.com/details/3 in their browser and they are redirected to the needed store to download the app. When they open the installed app, they are proceeded to /details/3 screen.

For routing we have added the package go_router (https://pub.dev/packages/go_router), which handles deep linking.

Router config: flutter_ddl_example/lib/router.dart
Screens: flutter_ddl_example/lib/screens

### Adjust manifest in Android App

To enable handling app links, add the following to your manifest located in <your-flutter-project-dir>/android/app/src/main/AndroidManifest.xml and into the <activity> tag with android:name=".MainActivity" :

```xml
<meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" />
    <data android:host="mobile-apps-examples.23devs.com" /> 
    <data android:pathPattern="/details/.*" />
</intent-filter>
```

You could specify here the scheme, host, and specific paths or path patterns for deep links.

Documentation with more examples here:
* https://docs.flutter.dev/cookbook/navigation/set-up-app-links
* https://developer.android.com/training/app-links/verify-android-applinks 

### Adjust files in iOS App

To enable handling universal links, add this to <dict> tag in <your-flutter-project-dir>/ios/Runner/Info.plist

```xml
<key>FlutterDeepLinkingEnabled</key>
<true/>
```

And then enable associated domains capability for the app in xCode Settings

1. Click the top-level Runner.
2. In the Editor, click the Runner target.
3. Click Signing & Capabilities.
4. To add a new domain, click + Capability under Signing & Capabilities.
5. Click Associated Domains.
6. In the Associated Domains section, click +.
7. Enter applinks:<webdomain>. Replace <webdomain> with your own domain name.

Or for personal accounts (they don't support capability from xcode):

1. Open the ios/Runner/Runner.entitlements XML file in your preferred IDE.
2. Add an associated domain inside the <dict> tag. Insert your domain instead of mobile-apps-examples.23devs.com.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>com.apple.developer.associated-domains</key>
  <array>
    <string>applinks:mobile-apps-examples.23devs.com</string>
  </array>
</dict>
</plist>
```

3. Save the ios/Runner/Runner.entitlements file.

Documentation:
* https://docs.flutter.dev/cookbook/navigation/set-up-universal-links
* https://developer.apple.com/documentation/xcode/supporting-associated-domains

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

This will generate file upload-keystore.jks, which can be moved to your flutter project in android folder (it should be ignored by git!).
To get sha 256 cert fingerprint from this file execute this command from directory where it's located:

```sh
keytool -list -v -keystore upload-keystore.jks
```

Copy SHA 256 signing certificate fingerprint data from terminal.

Documentation:
* https://docs.flutter.dev/cookbook/navigation/set-up-app-links
* https://developer.android.com/training/app-links/verify-android-applinks 


### Example of file apple-app-site-association (iOS):

For Universal links in iOS app you need to host an apple-app-site-association file in your dedicated web domain. This file tells the mobile browser which iOS application to open instead of the browser. To create the file, find the appID of the Flutter app you created.

Apple formats the appID as <team id>.<bundle id>.

Locate the bundle ID in the Xcode project.
Locate the team ID in the developer account.

For example: Given a team ID of S8QB4VV633 and a bundle ID of com.example.myApp, You would enter an appID entry of S8QB4VV633.com.example.myApp.

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
* https://docs.flutter.dev/cookbook/navigation/set-up-universal-links
* https://developer.apple.com/documentation/xcode/supporting-associated-domains

## Nginx config for app-link assosiation files

Example. Insert other location blocks, your files location (we recommend a separate folder, but without dot in name), and your domain name instead of mobile-apps-examples.23devs.com.

```conf
server {
    listen 80;
    server_name mobile-apps-examples.23devs.com;
    charset utf-8;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    location = /.well-known/assetlinks.json {
        root /var/www/html/assetlinks;
        try_files /assetlinks.json =404;
    }

    location = /.well-known/apple-app-site-association {
        root /var/www/html/assetlinks;
        default_type application/json;
        try_files /apple-app-site-association =404;
    }
}
```

## Frontend App

This is simple example HTML file + js script file, that collects data from the browser (screen width, os and its version using Platform.js), sends this data to the server and then redirects user to the needed store, or shows some sort of error / content for desktop users.

Currently, some Android Tablets may be identified as Linux system, so they won't be redirected to the store or get same fingerprint in app.

## Strapi App

The example app uses 5.0.0 version of Strapi (Typescript).
It has Url Access Data entity for handling app linking when app is not installed.
There are 2 custom actions (Check, Set) that also need to be available for end users

* Admin Panel settings -> Users & Permissions plugin -> Roles
* Choose Public role
* Find Url-access-data 
* Enable access for routes: check, set
* Save

Also See env.example for setting environment variables.

### Set

method: POST 
url: https://api-mobile-apps-examples.23devs.com/api/url-data-access/set
body:

```json
{
    "screenWidth": 360,
    "os": "android",
    "version": "10",
    "url": "https://mobile-apps-examples.23devs.com/details/4"
}
```

Example success response (returns the app page in the respective store):

```json
{
    "redirectUrl": "https://play.google.com/store/apps/details?id=ru.e2e4gu.books_flutter_application"
}
```

Example Error Response 
(if the platform is not Android or iOS)

```json
{
    "data": null,
    "error": {
        "name": "ApplicationError",
        "message": "Invalid platform",
        "details": {},
        "status": 400
    }
}
```

This endpoint is used by the frontend app to send fingerprint data and get store redirection url.

The server also gets ip of the sender and forms an object with properties screenWidth, os, version, ip, then hashes this object (via jsonwebtoken lib) and stores it in database among with the url that user tried to access ("/details/4") and timestamp.

Example of stored data:

```
{
  hash: "exzmxmxjdssieiwkww.sksjsjsweiwksksks.wkskjsjsjsjjs",
  url: "/details/4",
  createdAt: "2024-09-27T10:50:08.047Z"
}
```

For objects with identical values of all properties the hash will stay the same.

### Check

method: POST 
url: https://api-mobile-apps-examples.23devs.com/api/url-data-access/check
body:

```json
{
    "screenWidth": 360,
    "os": "android",
    "version": "10",
}
```

Example success response 
(returns the route part for needed app screen):

```json
{
    "redirectUrl": "/details/4"
}
```

Example Error Response 
(if unable to get redirection url):

```json
{
    "data": null,
    "error": {
        "name": "ApplicationError",
        "message": "Unable to get url",
        "details": {},
        "status": 400
    }
}
```

This endpoint is used by the flutter app to send its fingerprint data and get store redirection url.

The server also gets ip of the sender and forms an object with properties screenWidth, os, version, ip, then hashes this object (via jsonwebtoken lib). It tries to find in database all entries with same hash and that were created within recent hour. If it does not found any, returns an error. If it does, it only returns the latest entry's url.

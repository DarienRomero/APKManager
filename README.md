<h2 align="center">APK Manager</h2>

APK Manager is an application that allows you to control client access to the versions of your applications in a similar way to TestFlight on iOS. (Only available for Android)

## Features 🌟

- 🔐 Authentication with email and password
- 💡 Full access control per user and group of apps
- 🔔 Push notifications segmented by channels

## Setup

***Flutter version: 3.7.11***

#### Firebase configuration

Create a Firebase project and enable the authentication and firestore modules. Additionally, enable rules to allow reading and writing as needed.

Modify the package name and use it to create the Android application.

For image urls you can use Firestore Storage or the storage service of your choice.

For new version push notification consider that channel name is the same as firestore app document uuid.

To create a user you must first create the user on Firebase authenticated. The given uuid must be the same for the document uuid of the 'user' collection.

#### Firestore collections

##### 'app' collection

| key                    | type   | description                              |
| ---------------------- | ------ | ---------------------------------------- |
| `id`                   | string | Same as document uuid                    | 
| `last_version_link`    | string | Link to the last version of the app      |
| `last_version_number`  | number | VersionCode of android config            |
| `last_version_string`  | string | VersionName of android config            |
| `logo`                 | string | Public image url to the logo of the app  |
| `name`                 | string | Name of the app                          |

##### 'user' collection

| key           | type             | description                                                  |
| ------------- | ---------------- | -----------------------------------------------------------  |
| `id`          | string           | Same as document uuid                                        | 
| `email`       | string           | Email of the user                                            |
| `username`    | string           | Username of the user                                         |
| `enabled`     | boolean          | Flag to control user access to the app                       |
| `app_enabled` | Array of strings | Array with the uuid of app documents those the user can see  |


### 📜 License

```
Copyright 2023 Darien Romero

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
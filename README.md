### flutter2023 PROJECT TEAM
    yohann.desravines@epitech.eu (team leader)
    yoann.mallat@epitech.eu
    manoa.rabekoto@epitech.eu


### FIGMA LINK
MOBILE  :  https://www.figma.com/file/vdZDMJDeosLpEKLUCDz0F6/instagram_flutter?node-id=0%3A1&t=aGqp2czopo3dHIFP-1
WEB     : https://www.figma.com/file/DS6QECaoHnBuHbEKI6nfCi/instagram_flutter_web?node-id=0%3A1&t=83aizl7HBNNHdGz5-1


### PROJECT OVERVIEW
    Our project is an instagram like application that you can run through the browser and on your android phone. You can upload, like, and comment pictures. You can check your profile and your friend's profile as well. Follow and unfollow.



### PROJECT BUILD LINK
https://codemagic.io/app/64295455804910771816891d/build/64295468ce02ff227623a68e



### GETTING STARTED
    1- Clone the repository to your local machine.
    2- Go to flutter2023/instagram_flutter/
    3- Install the dependencies by running flutter pub get.
    4- On android, connect your mobile device on your computer and run flutter run.
    5- On the web, run flutter run --web-renderer html.


### DEPENDENCIES
  async: ^2.10.0
  blackfoot_flutter_lint: ^1.1.0
  cloud_firestore: ^4.4.5
  cupertino_icons: ^1.0.2
  firebase_auth: ^4.3.0
  firebase_core: ^2.8.0
  firebase_storage: ^11.0.16
  flutter:
    sdk: flutter
  flutter_staggered_grid_view: ^0.6.2
  flutter_svg: ^2.0.4
  image_picker: ^0.8.7+1
  intl:
  provider: ^6.0.5
  uuid: ^3.0.7


### DIRECTORIES STRUCTURE
    models
    providers
    resources
    responsive
    screens
    utils
    widgets


### FILES STRUCTURE
    firebase_options.dart
    main.dart

    models
        post.dart
        user.dart

    providers
        user_provider.dart

    resources
        auth_methods.dart
        firestore_methods.dart
        storage_methods.dart

    responsive
        mobile_screen_layout.dart
        responsive_layout_screen.dart
        web_screen_layout.dart

    screens
        add_post_screen.dart
        comments_screen.dart
        feed_screen.dart
        login_screen.dart
        profile_screen.dart
        search_screen.dart
        signup_screen.dart

    utils
        colors.dart
        global_variable.dart
        utils.dart

    widgets
        comment_card.dart
        follow_button.dart
        like_animation.dart
        post_card.dart
        text_field_input.dart

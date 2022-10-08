# appciona

A new Flutter project.

## Getting Started

Todos los paquetes que se necesitan para el proyecto ya están incluidos en el archivo "puspect.yaml". Para descargar estos paquetes hay que ubicarse en la carpeta del proyecto (a nivel raíz, donde estan las carpetas: android, ios, web, lib, test, build, etc), y ejecutar el comando "flutter pub get".

Para ejecutar la aplicación, es necesario tener conectado un dispositivo android, o un emulador android en el
equipo. Una vez hecho esto, ejecutamos el comando "flutter run".

Este proyecto en específico requiere de la versión de SDK de flutter 2.16.1 mínimo.

Como esta aplicación ya está lanzada a producción es necesario que cuente con los siguientes archivos en la carpeta Android:
    - En "android/" es necesario que esté el archivo "key.properties", el cuál si no se encuentra en esta carpeta debe ser anexado (está incluido en el archivo "keys.zip" anexado).
    - En "android/app/" es necesario que esté el archivo "key-appciona.jks", el cuál si no se encuentra en esta carpeta debe ser anexado (está incluido en el archivo "keys.zip" anexado).
    - En "android/app/" es necesario que esté el archivo "google-services.json" (necesario para firebase), el cuál si no se encuentra en esta carpeta debe ser anexado (está incluido en el archivo "keys.zip" anexado), también puede ser obtenido desde la pág de firebase.

Para iOS es necesario que se encuentren los siguientes archivos en la carpeta iOS:
    -ES NECESARIO INCLUIR ESTE ARCHIVO CON LA AYUDA DE XCODE para evitar problemas, pueden probar anexarlo directamente en caso de que no esté. En "ios/Runner/" es necesario que esté el archivo "GoogleService-Info.plist" (necesario para firebase), el cuál si no se encuentra en esta carpeta debe ser anexado (está incluido en el archivo "keys.zip" anexado), también puede ser obtenido desde la pág de firebase.

Es necesario incluir las huellas SHA-1 de su equipo en firebase para android y en google cloud para la api de google maps, de otro modo, firebase y google cloud podrían no funcionar correctamente.
Para poder obtener el simple apk instalable, se utiliza el comando "flutter build apk".
Para poder obtener el appbundle para playstore, se utiliza el comando "flutter build appbundle", es necesario que se modifique el número de version del proyecto en el archivo "pubspec.yaml", actualmente (16/08/2022 - 17:55 hrs) la ultima versión compilada para playstore es la versión 1.0.1+2, para evitar problemas a la playstore, solo basta con aumentar el número después del carácter "+", también es posible cambiar los demás digitos a la izquierda, pero por cada appbundle subida a playstore, el número de la derecha (número de compilación) es necesario aumentarlo si o si.
Para poder obtener el archivo .ipa para appstore (es necesario tener instalado XCODE), se ejecuta el comando "flutter build ipa", es necesario tener registrada la mac en la que se está ejecutando este comando para que haya los menores problemas posibles.

->Link de documentación oficial para release en android: https://docs.flutter.dev/deployment/iandroid
->Link de documentación oficial para release en ios: https://docs.flutter.dev/deployment/ios
CalculatorSQLiteApp - Kotlin (Android)

Project structure:
- app/src/main/java/com/example/calculatorsqlite/*.kt  -> Kotlin source files
- app/src/main/res/layout/*.xml                     -> Layouts
- app/src/main/AndroidManifest.xml                  -> Manifest
- build.gradle (project), app/build.gradle          -> Gradle files

Notes:
- This is a minimal skeleton demonstration.
- Calculator supports two operands (entered in text fields), choose operator, press '=' to compute.
- Each calculation (expression, result, timestamp) is stored in SQLite.
- Open 'View History' to see past calculations and delete them.

To open in Android Studio:
- Import the project directory 'CalculatorSQLiteApp' as an existing Android Studio project.
- You may need to adjust Android Gradle plugin and Kotlin versions depending on your local setup.

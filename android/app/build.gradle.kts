plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Google Services plugin for Firebase
    id("com.google.gms.google-services") version "4.4.0" apply false
}

android {
    namespace = "com.example.soloforte_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.soloforte_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keystoreFile = project.rootProject.file("key.properties")
            if (keystoreFile.exists()) {
                val properties = java.util.Properties()
                properties.load(keystoreFile.inputStream())
                keyAlias = properties.getProperty("keyAlias")
                keyPassword = properties.getProperty("keyPassword")
                storeFile = file(properties.getProperty("storeFile"))
                storePassword = properties.getProperty("storePassword")
            } else {
                // Fallback to debug keystore for CI/testing without keys
                // In production, this file must exist!
                val debugKeystore = signingConfigs.getByName("debug")
                keyAlias = debugKeystore.keyAlias
                keyPassword = debugKeystore.keyPassword
                storeFile = debugKeystore.storeFile
                storePassword = debugKeystore.storePassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

// Apply Google Services plugin
apply(plugin = "com.google.gms.google-services")

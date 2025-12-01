// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Plugin của Flutter
    id("dev.flutter.flutter-gradle-plugin")
    // Plugin của Google Services (BẮT BUỘC ĐỂ CHẠY FIREBASE)
    id("com.google.gms.google-services")
}

android {
    // Namespace phải trùng với package name của bạn
    namespace = "com.example.du_an_3_buoi5"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        // ID ứng dụng
        applicationId = "com.example.du_an_3_buoi5"
        
        // --- QUAN TRỌNG: Sửa minSdk thành 21 ---
        minSdk = flutter.minSdkVersion 
        // ---------------------------------------
        
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Cấu hình ký số (signing) cho bản release
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Nơi thêm các thư viện native nếu cần (hiện tại để trống ok)
}

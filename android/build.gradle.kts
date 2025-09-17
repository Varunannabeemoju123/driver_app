// Top-level build file where you can add configuration options common to all sub-projects/modules.

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false

    // ✅ Required for Firebase (e.g. Auth, Analytics, etc.)
    id("com.google.gms.google-services") version "4.3.15" apply false

    // ✅ Required for Flutter integration
    id("dev.flutter.flutter-gradle-plugin") apply false
}

// This configures the root project's build output folder
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// This configures each subproject's build output folder
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Ensures the app module is evaluated before others (safe for Firebase plugins)
subprojects {
    project.evaluationDependsOn(":app")
}

// Optional: Clean task (uncomment if needed)
/*
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
*/

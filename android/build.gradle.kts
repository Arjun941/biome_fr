allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    plugins.withId("com.android.library") {
        project.extensions.configure<com.android.build.api.dsl.LibraryExtension>("android") {
            if (namespace == null) {
                namespace = project.group.toString()
            }
        }
    }
    plugins.withId("com.android.application") {
        project.extensions.configure<com.android.build.api.dsl.ApplicationExtension>("android") {
            if (namespace == null) {
                namespace = project.group.toString()
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
group = "it.unibo.alice.tuprolog.argumentation"
version = "1.0-SNAPSHOT"

plugins {
    java
}

subprojects {

    apply(plugin = "java")

    group = rootProject.group
    version = rootProject.version

    repositories {
        mavenCentral()
    }

    configure<JavaPluginConvention> {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

}
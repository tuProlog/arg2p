plugins {
    java
    `java-library`
    application
}

repositories {
    mavenCentral()
}

group = "it.unibo.argumentation.deonlite"
version = "1.0-SNAPSHOT"

dependencies {
    api("it.unibo.alice.tuprolog", "2p-ui", "4.1.+")
    testImplementation("junit", "junit", "4.12")
}

configure<JavaPluginConvention> {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

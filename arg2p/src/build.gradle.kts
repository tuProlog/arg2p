import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar

plugins {
    `java-library`
    application
    eclipse
    id("com.github.johnrengelman.shadow") version "5.2.0"
}

dependencies {
    api("it.unibo.alice.tuprolog", "2p-ui", "4.1.1")
    testImplementation("junit", "junit", "4.12")
}

application {
    mainClassName = "alice.tuprologx.ide.JavaIDEWithArg2P"
}
import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar

plugins {
    `java-library`
    application
    eclipse
    id("com.github.johnrengelman.shadow") version "5.2.0"
    id("org.beryx.runtime") version "1.9.1"
}

dependencies {
    api("it.unibo.alice.tuprolog", "2p-ui", "4.1.1")
    testImplementation("junit", "junit", "4.12")
}

application {
    mainClassName = "alice.tuprologx.ide.JavaIDEWithArg2P"
}

runtime {
    options.set(listOf("--strip-debug", "--compress", "2", "--no-header-files", "--no-man-pages"))
    jpackage {
        if(org.gradle.internal.os.OperatingSystem.current().isLinux()) {
            installerType = "deb"
            installerOptions = listOf("--linux-shortcut")
        }
        if(org.gradle.internal.os.OperatingSystem.current().isMacOsX()) {
            installerType = "dmg"
        }
        if(org.gradle.internal.os.OperatingSystem.current().isWindows()) {
            // This requires WiX to be installed: https://github.com/wixtoolset/wix3/releases
            installerType = "msi"
            installerOptions = listOf(
                    "--win-dir-chooser",
                    "--win-shortcut",
                    "--win-menu"
            )
        }
    }
}
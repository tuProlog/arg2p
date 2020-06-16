plugins {
    id("com.eden.orchidPlugin") version "0.21.0"
}

val orchidVersion = "0.21.0"

dependencies {
    orchidRuntimeOnly("io.github.javaeden.orchid:OrchidEditorial:$orchidVersion")
    orchidRuntimeOnly("io.github.javaeden.orchid:OrchidDocs:$orchidVersion")
//    orchidRuntimeOnly("io.github.javaeden.orchid:OrchidKotlindoc:$orchidVersion")
//    orchidRuntimeOnly("io.github.javaeden.orchid:OrchidPluginDocs:$orchidVersion")
//    orchidRuntimeOnly("io.github.javaeden.orchid:OrchidGitlab:$orchidVersion")
//    orchidRuntimeOnly("io.github.javaeden.orchid:OrchidDiagrams:$orchidVersion")
}

repositories {
    jcenter()
}

fun getPropertyOrWarnForAbsence(key: String): String? {
    val value = property(key)?.toString()
    if (value.isNullOrBlank()) {
        System.err.println("WARNING: $key is not set")
    }
    return value
}

val orchidBaseUrl = getPropertyOrWarnForAbsence("orchidBaseUrl")

orchid {
    theme = "Editorial"
    baseUrl = orchidBaseUrl
    version = rootProject.version.toString()
//    args = listOf("--experimentalSourceDoc")
}
plugins {
    kotlin("jvm") version "1.9.24"
    `maven-publish`
}

group = "dev.snapkit"
version = "1.0.0"

repositories {
    mavenCentral()
    google()
}

dependencies {
    implementation("androidx.core:core-ktx:1.13.1")

    testImplementation(kotlin("test"))
    testImplementation("junit:junit:4.13.2")
}

tasks.test {
    useJUnit()
}

kotlin {
    jvmToolchain(17)
}

publishing {
    publications {
        create<MavenPublication>("maven") {
            from(components["java"])
        }
    }
}

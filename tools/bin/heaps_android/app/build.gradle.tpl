plugins {
    id 'com.android.application'
}

android {
    ndkVersion "21.4.7075529"
    compileSdkVersion 31
    defaultConfig {
        applicationId APPLICATION_ID
        minSdkVersion 19
        targetSdkVersion 31
        versionCode VERSION_CODE.toInteger()
        versionName VERSION_NAME
        externalNativeBuild {
            cmake {
                arguments "-DCMAKE_BUILD_TYPE=BetaTest"
                cppFlags "-frtti -fexceptions"
            }
        }
        ::if (split)::
        ndk {
            abiFilters.clear()
        }
        ::else::
        ndk {
            abiFilters = []
            abiFilters.addAll(ABI_FILTERS.split(',').collect{it as String})
        }
        ::end::
    }
    ::if (split)::
    splits {
        abi {
            enable true
            reset()
            include ::abiInclude::
        }
    }
    ::end::
    signingConfigs {
        release {
            storeFile file(RELEASE_STORE_FILE)
            storePassword RELEASE_STORE_PASSWORD
            keyAlias RELEASE_KEY_ALIAS
            keyPassword RELEASE_KEY_PASSWORD
            v1SigningEnabled true
            v2SigningEnabled true
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
    externalNativeBuild {
        cmake {
            path 'CMakeLists.txt'
        }
    }
    lintOptions {
        abortOnError true
    }

}

tasks.whenTaskAdded { task ->
    if (task.name.startsWith('compile') && task.name.endsWith('JavaWithJavac')) {
        task.dependsOn 'unzip-android-libjpeg-turbo'
        task.dependsOn copyPatchedHL
        task.dependsOn copySDLJava
        task.dependsOn copyPatchedSDLJava
        task.dependsOn buildOpenalNativeTools
    }
}

configurations {
    lib
}

dependencies {
    lib 'libsdl-org:SDL:release-2.0.20@zip'
    lib 'openstf:android-libjpeg-turbo:46be77d8b8287ea3687da6ab245032929363515b@zip'
    lib 'kcat:openal-soft:openal-soft-1.19.1@zip'
    lib 'HaxeFoundation:hashlink:1.12@zip'
}

[
    'SDL': 'sdl2',
    'android-libjpeg-turbo': 'libjpeg-turbo',
    'openal-soft': 'openal-soft',
    'hashlink': 'hashlink'
].each {
    def rep = it.key
    def dest = it.value
    task "unzip-$rep"(type: Copy) {
        def zipPath = project.configurations.lib.find {it.name.startsWith(rep) }
        def zipFile = file(zipPath)
        def outputDir = file("$buildDir/libs/$dest")
        from zipTree(zipFile)
        into outputDir
        includeEmptyDirs = false
        eachFile { FileCopyDetails fcp ->
            def pathsegments = fcp.relativePath.segments[1..-1] as String[]
            fcp.relativePath = new RelativePath(!fcp.file.isDirectory(), pathsegments)
        }
    }
}

task copyPatchedHL(type: Copy, dependsOn: 'unzip-hashlink') {
    from './src/patchedhl'
    into './build/libs/hashlink/src'
}

task copySDLJava(type: Copy, dependsOn: 'unzip-SDL') {
    from 'build/libs/sdl2/android-project/app/src/main/java/org/libsdl/app'
    exclude 'SDLActivity.java'
    into './src/main/java/org/libsdl/app'
}

task copyPatchedSDLJava(type: Copy) {
    from './src/patchedsdl'
    into './src/main/java/org/libsdl/app'
}

task prepareOpenalNativeTools(type:Exec) {
    workingDir './build/libs/openal-soft/native-tools'
    commandLine 'cmake', '.'
    dependsOn 'unzip-openal-soft'
}

task buildOpenalNativeTools(type:Exec) {
    workingDir './build/libs/openal-soft/native-tools'
    commandLine 'cmake', '--build', '.'
    dependsOn prepareOpenalNativeTools
}
#!/bin/bash
# Revanced Extended build
source src/build/utils.sh

# Download requirements
revanced_dl(){
	dl_gh "revanced-patches revanced-integrations revanced-cli" "inotia00" "latest"
}

1() {
	revanced_dl
	# Patch YouTube:
	get_patches_key "youtube-revanced-extended"
	get_apk "com.google.android.youtube" "youtube" "youtube" "google-inc/youtube/youtube" "Bundle_extract"
	split_editor "youtube" "youtube"
	patch "youtube" "revanced-extended" "inotia"
	# Patch Youtube Arm64-v8a
	get_patches_key "youtube-revanced-extended"
	split_editor "youtube" "youtube-arm64-v8a" "exclude" "split_config.armeabi_v7a split_config.x86 split_config.x86_64"
	patch "youtube-arm64-v8a" "revanced-extended" "inotia"
	# Patch Youtube Armeabi-v7a
	get_patches_key "youtube-revanced-extended"
	split_editor "youtube" "youtube-armeabi-v7a" "exclude" "split_config.arm64_v8a split_config.x86 split_config.x86_64"
	patch "youtube-armeabi-v7a" "revanced-extended" "inotia"
}
2() {
	revanced_dl
	# Patch YouTube Music Extended:
	# Arm64-v8a
	get_patches_key "youtube-music-revanced-extended"
	get_apk "com.google.android.apps.youtube.music" "youtube-music-arm64-v8a" "youtube-music" "google-inc/youtube-music/youtube-music" "arm64-v8a"
	patch "youtube-music-arm64-v8a" "revanced-extended" "inotia"
	# Armeabi-v7a
	get_patches_key "youtube-music-revanced-extended"
	get_apk "com.google.android.apps.youtube.music" "youtube-music-armeabi-v7a" "youtube-music" "google-inc/youtube-music/youtube-music" "armeabi-v7a"
	patch "youtube-music-armeabi-v7a" "revanced-extended" "inotia"
}
case "$1" in
    1)
        1
        ;;
    2)
        2
        ;;
esac

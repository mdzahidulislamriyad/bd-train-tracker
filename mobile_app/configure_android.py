import os

def patch_manifest():
    manifest_path = "android/app/src/main/AndroidManifest.xml"
    if not os.path.exists(manifest_path):
        print(f"Error: {manifest_path} not found")
        return

    with open(manifest_path, "r", encoding="utf-8") as f:
        content = f.read()

    permissions = """
    <!-- Network & Internet -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <!-- GPS & Location Permissions for Crowdsourced Tracking -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />

    <!-- Voice Search Microphone -->
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
"""

    if "<uses-permission" not in content:
        content = content.replace("<application", permissions + "\n    <application")

    content = content.replace(
        'android:label="bd_train_tracker"',
        'android:label="বিডি ট্রেন ট্র্যাকার" android:usesCleartextTraffic="true"'
    )

    with open(manifest_path, "w", encoding="utf-8") as f:
        f.write(content)
    print("Successfully patched AndroidManifest.xml with permissions and Bengali title.")

if __name__ == "__main__":
    patch_manifest()

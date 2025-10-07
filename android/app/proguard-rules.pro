# Flutter default rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.** { *; }

# Fluttertoast
-keep class io.github.ponnamkarthik.toast.fluttertoast.** { *; }

# TensorFlow Lite GPU
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

# Play Store deferred components / SplitCompat
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Parcelable & Serializable models
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object readResolve();
}

# General warnings
-dontwarn kotlinx.coroutines.**
-dontwarn android.webkit.WebView
-dontwarn com.google.common.**

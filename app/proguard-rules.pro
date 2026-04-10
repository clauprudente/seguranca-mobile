# =============================================================================
# proguard-rules.pro
# Regras de ofuscação de código - Segurança Mobile
# =============================================================================

# ── Configurações gerais de ofuscação ────────────────────────────────────────

# Renomeia classes e membros com nomes curtos (a, b, c...)
-obfuscationdictionary obfuscation-dictionary.txt
-classobfuscationdictionary obfuscation-dictionary.txt
-packageobfuscationdictionary obfuscation-dictionary.txt

# Remove logs de debug em produção (evita vazamento de informações)
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Ofusca strings literais no bytecode
-adaptresourcefilenames    **.properties, **.gif, **.jpg
-adaptresourcefilecontents **.properties

# Remove atributos desnecessários que ajudam engenharia reversa
-keepattributes !LocalVariableTable,!LocalVariableTypeTable

# ── Mantém classes essenciais para o funcionamento ───────────────────────────

# Activity principal (precisa ser acessível pelo sistema Android)
-keep class com.seguranca.minhaapp.MainActivity { *; }

# Mantém nomes de componentes Android (referenciados no Manifest)
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# EncryptedSharedPreferences - mantém a API pública de segurança
-keep class androidx.security.crypto.** { *; }
-keep class androidx.security.crypto.EncryptedSharedPreferences { *; }
-keep class androidx.security.crypto.MasterKey { *; }
-keep class androidx.security.crypto.MasterKey$Builder { *; }

# Google Tink (usada internamente pelo EncryptedSharedPreferences)
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# CardView e Material Components (usados no layout)
-keep class androidx.cardview.widget.** { *; }
-dontwarn com.google.android.material.**

# Kotlin coroutines e reflexão
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# ── Segurança adicional ───────────────────────────────────────────────────────

# Remove classes de depuração Kotlin
-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    static void checkParameterIsNotNull(java.lang.Object, java.lang.String);
    static void checkNotNullParameter(java.lang.Object, java.lang.String);
    static void checkExpressionValueIsNotNull(java.lang.Object, java.lang.String);
    static void checkNotNullExpressionValue(java.lang.Object, java.lang.String);
    static void checkReturnedValueIsNotNull(java.lang.Object, java.lang.String);
    static void checkFieldIsNotNull(java.lang.Object, java.lang.String);
    static void throwUninitializedPropertyAccessException(java.lang.String);
}

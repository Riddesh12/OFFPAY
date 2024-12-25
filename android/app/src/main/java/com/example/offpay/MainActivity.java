package com.example.offpay;

import android.content.Intent;
import android.net.Uri;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.offpay/ussd";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("sendUssdCode")) {
                        String ussdCode = call.argument("code");
                        if (ussdCode != null) {
                            try {
                                String encodedHash = Uri.encode("#");
                                String ussd = "tel:" + ussdCode.replace("#", encodedHash);
                                Intent intent = new Intent(Intent.ACTION_CALL);
                                intent.setData(Uri.parse(ussd));
                                startActivity(intent);
                                result.success("USSD Launched");
                            } catch (Exception e) {
                                result.error("UNAVAILABLE", "Could not launch USSD", null);
                            }
                        } else {
                            result.error("INVALID_ARGUMENT", "USSD code is null", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                });
    }

}
package mn.ddishtv.ddish;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import java.util.List;

import io.flutter.app.FlutterFragmentActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {
  private static final String CHANNEL = "mn.ddish.app";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        List<String> arguments = methodCall.arguments();

        //is phone call
        if(methodCall.method.matches("call")){
          if(!arguments.isEmpty()){
            String phoneNumber = arguments.get(0);

            Intent intent = new Intent(Intent.ACTION_CALL);

            intent.setData(Uri.parse("tel:" + phoneNumber));
            getFlutterView().getContext().startActivity(intent);
          }
          //else
          //TODO no parameter ???
        }
      }
    });
  }
}

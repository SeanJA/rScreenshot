require 'tray_application';
require 'screen_shot';

app = TrayApplication.new("rScreenShot")
app.icon_filename = 'camera-web.png'
app.item('Take Screenshot'){Screenshot.capture}
app.item('Exit'){java.lang.System::exit(0)}
app.run
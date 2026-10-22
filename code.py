import time
import usb_hid
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keyboard_layout_us import KeyboardLayoutUS
from adafruit_hid.keycode import Keycode

kbd = Keyboard(usb_hid.devices)
layout = KeyboardLayoutUS(kbd)

# Wait for Mac to recognize the Pico keyboard
time.sleep(2.5)

# 1. Open Spotlight
kbd.send(Keycode.COMMAND, Keycode.SPACE)
time.sleep(0.4)

# 2. Type Terminal and hit Enter
layout.write("Terminal")
kbd.send(Keycode.RETURN)
time.sleep(0.8)

# 3. Run script, wait for completion, and exit
layout.write("curl -sSL https://raw.githubusercontent.com/rustdev55/rasb/main/setup.sh | bash && exit\n")
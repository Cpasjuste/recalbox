## Input Devices ##

There are seven types of joysticks emulated:

    Cursor
    Kempston
    Sinclair 1
    Sinclair 2
    Timex 1
    Timex 2
    Fuller Joystick

Users can configure their joystick types in the input configuration on the front end (Hotkey+B). However, fuse-libretro allows for two joysticks at maximum so only users one and two can actually use theirs in the emulation.

Users 1 and 2 can choose any of the joysticks as their device types, user 3 can only choose the Sinclair Keyboard.

Buttons A, X and Y are mapped to the joystick's fire button, and button B is mapped to the UP directional button. Buttons L1 and R1 are mapped to RETURN and SPACE, respectively. The SELECT button brings up the embedded, on-screen keyboard which is useful if you only have controllers attached to your box.

There are some conflicts in the way the input devices interact because of the use of the physical keyboard keys as joystick buttons. For a good gaming experience, set the user device types as follows:

    For joystick games: Set user 1 to a joystick type. Optionally, set user 2 to another joystick type (local cooperative games). Set user 3 to none. This way, you can use L1 as RETURN, R1 as SPACE, and SELECT to bring the embedded keyboard.
    For keyboard games: Set users 1 and 2 to none, and user 3 to Sinclair Keyboard. You won't have any joystick and the embedded keyboard won't work, but the entire physical keyboard will be available for you to type in those text adventure commands.

If you set a joystick along with the keyboard, the joystick will work just fine except for the bindings to RETURN and SPACE, and the keyboard won't register the keys assigned to the Cursor joystick, or to the L1 and R1 buttons for all other joystick types.

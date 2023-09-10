const c = @import("c.zig").c;
const window = @import("../Engine/window.zig");
const camera = @import("camera.zig");
const types = @import("types.zig");

//Keyboard Input Values
//https://www.glfw.org/docs/latest/group__keys.html#gabf48fcc3afbe69349df432b470c96ef2
pub const KEY_UNKNOWN: c_int = -1;
pub const KEY_SPACE: c_int = 32;
pub const KEY_APOSTROPHE: c_int = 39;
pub const KEY_COMMA: c_int = 44;
pub const KEY_MINUS: c_int = 45;
pub const KEY_PERIOD: c_int = 46;
pub const KEY_SLASH: c_int = 47;
pub const KEY_0: c_int = 48;
pub const KEY_1: c_int = 49;
pub const KEY_2: c_int = 50;
pub const KEY_3: c_int = 51;
pub const KEY_4: c_int = 52;
pub const KEY_5: c_int = 53;
pub const KEY_6: c_int = 54;
pub const KEY_7: c_int = 55;
pub const KEY_8: c_int = 56;
pub const KEY_9: c_int = 57;
pub const KEY_SEMICOLON: c_int = 59;
pub const KEY_EQUAL: c_int = 61;
pub const KEY_A: c_int = 65;
pub const KEY_B: c_int = 66;
pub const KEY_C: c_int = 67;
pub const KEY_D: c_int = 68;
pub const KEY_E: c_int = 69;
pub const KEY_F: c_int = 70;
pub const KEY_G: c_int = 71;
pub const KEY_H: c_int = 72;
pub const KEY_I: c_int = 73;
pub const KEY_J: c_int = 74;
pub const KEY_K: c_int = 75;
pub const KEY_L: c_int = 76;
pub const KEY_M: c_int = 77;
pub const KEY_N: c_int = 78;
pub const KEY_O: c_int = 79;
pub const KEY_P: c_int = 80;
pub const KEY_Q: c_int = 81;
pub const KEY_R: c_int = 82;
pub const KEY_S: c_int = 83;
pub const KEY_T: c_int = 84;
pub const KEY_U: c_int = 85;
pub const KEY_V: c_int = 86;
pub const KEY_W: c_int = 87;
pub const KEY_X: c_int = 88;
pub const KEY_Y: c_int = 89;
pub const KEY_Z: c_int = 90;
pub const KEY_LEFT_BRACKET: c_int = 91;
pub const KEY_BACKSLASH: c_int = 92;
pub const KEY_RIGHT_BRACKET: c_int = 93;
pub const KEY_GRAVE_ACCENT: c_int = 96;
pub const KEY_WORLD_1: c_int = 161; // non-US #1
pub const KEY_WORLD_2: c_int = 162; // non-US #2
pub const KEY_ESCAPE: c_int = 256;
pub const KEY_ENTER: c_int = 257;
pub const KEY_TAB: c_int = 258;
pub const KEY_BACKSPACE: c_int = 259;
pub const KEY_INSERT: c_int = 260;
pub const KEY_DELETE: c_int = 261;
pub const KEY_RIGHT: c_int = 262;
pub const KEY_LEFT: c_int = 263;
pub const KEY_DOWN: c_int = 264;
pub const KEY_UP: c_int = 265;
pub const KEY_PAGE_UP: c_int = 266;
pub const KEY_PAGE_DOWN: c_int = 267;
pub const KEY_HOME: c_int = 268;
pub const KEY_END: c_int = 269;
pub const KEY_CAPS_LOCK: c_int = 280;
pub const KEY_SCROLL_LOCK: c_int = 281;
pub const KEY_NUM_LOCK: c_int = 282;
pub const KEY_PRINT_SCREEN: c_int = 283;
pub const KEY_PAUSE: c_int = 284;
pub const KEY_F1: c_int = 290;
pub const KEY_F2: c_int = 291;
pub const KEY_F3: c_int = 292;
pub const KEY_F4: c_int = 293;
pub const KEY_F5: c_int = 294;
pub const KEY_F6: c_int = 295;
pub const KEY_F7: c_int = 296;
pub const KEY_F8: c_int = 297;
pub const KEY_F9: c_int = 298;
pub const KEY_F10: c_int = 299;
pub const KEY_F11: c_int = 300;
pub const KEY_F12: c_int = 301;
pub const KEY_F13: c_int = 302;
pub const KEY_F14: c_int = 303;
pub const KEY_F15: c_int = 304;
pub const KEY_F16: c_int = 305;
pub const KEY_F17: c_int = 306;
pub const KEY_F18: c_int = 307;
pub const KEY_F19: c_int = 308;
pub const KEY_F20: c_int = 309;
pub const KEY_F21: c_int = 310;
pub const KEY_F22: c_int = 311;
pub const KEY_F23: c_int = 312;
pub const KEY_F24: c_int = 313;
pub const KEY_F25: c_int = 314;
pub const KEY_KP_0: c_int = 320;
pub const KEY_KP_1: c_int = 321;
pub const KEY_KP_2: c_int = 322;
pub const KEY_KP_3: c_int = 323;
pub const KEY_KP_4: c_int = 324;
pub const KEY_KP_5: c_int = 325;
pub const KEY_KP_6: c_int = 326;
pub const KEY_KP_7: c_int = 327;
pub const KEY_KP_8: c_int = 328;
pub const KEY_KP_9: c_int = 329;
pub const KEY_KP_DECIMAL: c_int = 330;
pub const KEY_KP_DIVIDE: c_int = 331;
pub const KEY_KP_MULTIPLY: c_int = 332;
pub const KEY_KP_SUBTRACT: c_int = 333;
pub const KEY_KP_ADD: c_int = 334;
pub const KEY_KP_ENTER: c_int = 335;
pub const KEY_KP_EQUAL: c_int = 336;
pub const KEY_LEFT_SHIFT: c_int = 340;
pub const KEY_LEFT_CONTROL: c_int = 341;
pub const KEY_LEFT_ALT: c_int = 342;
pub const KEY_LEFT_SUPER: c_int = 343;
pub const KEY_RIGHT_SHIFT: c_int = 344;
pub const KEY_RIGHT_CONTROL: c_int = 345;
pub const KEY_RIGHT_ALT: c_int = 346;
pub const KEY_RIGHT_SUPER: c_int = 347;
pub const KEY_MENU: c_int = 348;
pub const KEY_LAST: c_int = KEY_MENU;

//mouse buttons
pub const MOUSE_BUTTON_1: c_int = 0;
pub const MOUSE_BUTTON_2: c_int = 1;
pub const MOUSE_BUTTON_3: c_int = 2;
pub const MOUSE_BUTTON_4: c_int = 3;
pub const MOUSE_BUTTON_5: c_int = 4;
pub const MOUSE_BUTTON_6: c_int = 5;
pub const MOUSE_BUTTON_7: c_int = 6;
pub const MOUSE_BUTTON_8: c_int = 7;
pub const MOUSE_BUTTON_LAST: c_int = MOUSE_BUTTON_8;
pub const MOUSE_BUTTON_LEFT: c_int = MOUSE_BUTTON_1;
pub const MOUSE_BUTTON_RIGHT: c_int = MOUSE_BUTTON_2;
pub const MOUSE_BUTTON_MIDDLE: c_int = MOUSE_BUTTON_3;

//wrapper functions
var prevMousePos = types.Vec2{};

pub fn GetKey(key: c_int) bool {
    return c.glfwGetKey(window.window, key) == c.GLFW_PRESS;
}

pub fn GetMouseButton(button: c_int) bool {
    return c.glfwGetMouseButton(window.window, button) == c.GLFW_PRESS;
}

pub fn GetRawMousePos() types.Vec2 {
    var x: f64 = undefined;
    var y: f64 = undefined;
    c.glfwGetCursorPos(window.window, &x, &y);
    return types.Vec2{ .x = @floatCast(x), .y = @floatCast(y) };
}

pub fn GetMousePos() types.Vec2 {
    var mousePos = GetRawMousePos();
    var windowSize = window.GetWindowSize();

    mousePos = types.Vec2.Sub(mousePos, types.Vec2.DivX(windowSize, 2));
    mousePos = types.Vec2.MulX(types.Vec2.DivX(mousePos, windowSize.x), camera.scale * 2);
    mousePos.y *= -1;

    return mousePos;
}

pub fn DeltaMousePos() types.Vec2 {
    var mousePos = GetMousePos();
    var out = types.Vec2.Sub(mousePos, prevMousePos);
    return out;
}

var locked: bool = false;
var hidden: bool = false;

pub fn lockCursor(enabled: bool) void {
    locked = enabled;
    updateCursorState();
}

pub fn hideCursor(enabled: bool) void {
    hidden = enabled;
    updateCursorState();
}

fn updateCursorState() void {
    if (locked) {
        c.glfwSetInputMode(window.window, c.GLFW_CURSOR, c.GLFW_CURSOR_DISABLED);
    } else if (hidden) {
        c.glfwSetInputMode(window.window, c.GLFW_CURSOR, c.GLFW_CURSOR_HIDDEN);
    } else {
        c.glfwSetInputMode(window.window, c.GLFW_CURSOR, c.GLFW_CURSOR_NORMAL);
    }
}

pub fn Update() void {
    prevMousePos = GetMousePos();
}

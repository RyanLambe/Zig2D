pub const c = @cImport({
    @cDefine("GLFW_INCLUDE_NONE", {});
    @cInclude("GLFW/glfw3.h");
    @cInclude("glad/gl.h");
    @cInclude("LodePng/lodepng.h");
});

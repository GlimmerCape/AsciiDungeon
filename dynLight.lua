display.setDefault("isShaderCompilerVerbose", true)
local kernel = {}

-- "filter.custom.myBrighten"
kernel.language = "glsl"
kernel.category = "filter"
kernel.name = "dynLight"

kernel.vertexData =
{
    {
        name = "playerX",
        default = 0,
        min = -256,
        max = 256,
        index = 0, -- This corresponds to "CoronaVertexUserData.x"
    },
    {
        name = "playerY",
        default = 0,
        min = -256,
        max = 256,
        index = 1,
    },
    {
        name = "lightAngle",
        default = 0,
        min = -360,
        max = 360,
        index = 2,
    },
}
--abs(lAngle - atan(plP, tileP))
kernel.fragment =
[[
P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
{
    P_COLOR float brightness = 0.9;
    P_COLOR vec4 texColor = texture2D( CoronaSampler0, texCoord );
    P_DEFAULT float plX = CoronaVertexUserData.x;
    P_DEFAULT float plY = CoronaVertexUserData.y;
    P_UV vec2 plP = vec2(plX, plY) ;
    P_DEFAULT float lAngle = CoronaVertexUserData.z;
    
    P_UV vec2 tileP = vec2(mod(texCoord.x,float(64)), mod(texCoord.y, float(64)));
;
    // Pre-multiply the alpha to brightness
    brightness = brightness * texColor.a;
    
    if( distance(plP, tileP) < float(0.05) && float(15) > float(10))
    {
        // Add the brightness
        texColor.rgb += brightness;
    } 
 
 
    // Modulate by the display object's combined alpha/tint.
    return CoronaColorScale( texColor );
}
]]

graphics.defineEffect(kernel);
return kernel;

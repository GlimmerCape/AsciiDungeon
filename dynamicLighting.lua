local kernel = {}

kernel.language = "glsl"

kernel.category = "filter"

kernel.name = "dynamicLighting"

kernel.uniformData =
{
    {
        name = "playerData",
        default = { 1, 1 },
        min = { -256, -256 },
        max = { 256, 256 },
        type = "vec2",
        index = 0,
    },
    {
        name = "lightDir",
        default = { 0 },
        min = { -360 },
        max = { 360 },
        type = "scalar",
        index = 1,
    }
}
--TRY VERTEXDATA IF THIS DOESNT WORK
kernel.fragment =
[[
uniform P_UV vec2 u_UserData0;
uniform P_UV vec2 u_UserData1;

P_COLOR vec 4 FragmentKernel( P_UV vec2 texCoord)
{
    P_COLOR float brightness = 0.5;
    P_COLOR vec4 texColor = texture2D( CoronaSampler0, texCoord );

    P_UV vec2 player = u_UserData0;
    p_UV vec2 lightDir = u_UserData1;
    P_UV float tileHeight = 64;
    P_UV float tileWidth = 64;

    P_UV float angleLimit = 15;
    P_UV float radius = 500;
 
    // Pre-multiply the alpha to brightness
    brightness = brightness * texColor.a;

    tilex = position.x % tileWidth 
    tiley = position.y % tileHeight

    vec2 tileCoord = vec2(tilex,tiley) 

    distance = distance(player, tileCoord)
    angle = atan2(player, tileCoord)
    
    if(distance < radius && angleLimit > abs(ligthDir - angle))
    {
        Add the brightness
        texColor.rgb += brightness;
    }
    // Modulate by the display object's combined alpha/tint.
    return CoronaColorScale( texColor );
}
]]

graphics.defineEffect(kernel)

return kernel

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

const float PI = 3.1415926535897932384626433832795;
float atan2(in float y, in float x)
{
    return x == 0.0 ? sign(y)*PI/2.0 : atan(y, x);
}


P_COLOR vec4 FragmentKernel( P_UV vec2 texCoord )
{

    P_COLOR vec4 texColor = texture2D( CoronaSampler0, texCoord );
    P_UV vec2 pP = gl_FragCoord.xy; 

    P_DEFAULT float plX = CoronaVertexUserData.x;
    P_DEFAULT float plY = CoronaVertexUserData.y;
    P_DEFAULT float lAngle = CoronaVertexUserData.z;
    P_UV vec2 plP = vec2(plX, plY) ;
    P_COLOR float brightness = 8.5; 
    
    P_UV vec2 tileP = vec2(floor(pP.x/float(32)), floor(pP.y/ float(32)));
    P_UV vec2 targetV = tileP - plP;
    // Pre-multiply the alpha to brightness
    brightness = brightness * (texColor.r * 0.3 + texColor.g * 0.3 + texColor.b * 0.3 - 0.05);
    //Dont forget angles in radians    
    if((distance(plP, tileP) <10.0) && (abs((2.0 * PI - lAngle) - (atan2(targetV.y, targetV.x) + PI)) < 0.4))
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

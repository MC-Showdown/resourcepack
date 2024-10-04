#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

uniform vec2 ScreenSize;

in float vertexDistance;
in float depthLevel;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

bool isRed(vec4 a) {
    return a.r == 0.988235294 && a.g == 0.329411765 && a.b == 0.329411765 && a.a == 1.0;
}

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
	
	if(color.a < 0.05) discard;
	
	vec3 light = vec3(0.25, 0.25, 0.25);
	vec3 shadow = vec3(0.248, 0.248, 0.248);
	
	//remove shadow from all non-chat/non-hover text (level = 0) and don't remove dark_gray UI/inventory text
	if (depthLevel == 0 && lessThan(vertexColor.rgb,shadow) == bvec3(true)) {
		discard;
	}
	
	//remove shadow from chat text
	if (depthLevel == 100) {
		discard;
	}
	
	//remove shadow from hover text
	if (depthLevel == 400) {
		discard;
	}
	
	if(color.a < 0.1) discard;
	
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
	
	//if(vertexDistance > 2020.0 && isRed(fragColor) && ScreenSize.x - gl_FragCoord.x < 52) discard;
}

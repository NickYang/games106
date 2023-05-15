#version 450

layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec2 inUV;
layout (location = 3) in vec4 inTangent;
layout (location = 4) in uint inIdx;

layout (set = 0, binding = 0) uniform UBOScene
{
	mat4 projection;
	mat4 view;
	vec4 lightPos;
	vec3 camPos;
} uboScene;


layout (std430, set = 2, binding = 0) readonly buffer NodeMatrices
{
	mat4 nodeMatrices[];
};


layout (location = 0) out vec3 outWorldPos;
layout (location = 1) out vec3 outWorldNormal;
layout (location = 2) out vec2 outUV;
layout (location = 3) out vec4 outWorldTangent;

void main() 
{	
	mat4 model = nodeMatrices[inIdx];

	vec3 locPos = vec3(model * vec4(inPos, 1.0));
	vec4 viewPos = uboScene.view * vec4(inPos, 1.0);

	outWorldPos = locPos;
	outWorldNormal = mat3(model) * inNormal;
	outWorldTangent = vec4(mat3(model) * inTangent.xyz, inTangent.w);
	outUV = inUV;

	gl_Position = uboScene.projection * uboScene.view *  vec4(outWorldPos, 1.0);	
}
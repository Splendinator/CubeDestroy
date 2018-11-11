#version 440 core

layout(vertices = 4) out;//num vertices in patch output

uniform float tessLevelInner;
uniform float tessLevelOuter;

in Vertex{
	vec2 texCoord;
	vec4 colour;
		vec3 position;
	vec3 normal;
} IN[];

out Vertex{
	vec2 texCoord;
	vec4 colour;
		vec3 position;
	vec3 normal;
} OUT[];

uniform int code;

patch out vec4 subColor;

void main() {

	 OUT [ gl_InvocationID ]. texCoord = IN [ gl_InvocationID ]. texCoord ;
	  OUT [ gl_InvocationID ]. colour = IN [ gl_InvocationID ]. colour ;
	  	 OUT [ gl_InvocationID ]. position = IN [ gl_InvocationID ]. position ;
	  OUT [ gl_InvocationID ]. normal = IN [ gl_InvocationID ]. normal ;

	gl_TessLevelInner[0] = 64;
	gl_TessLevelInner[1]= 64;//quadsonly!

	gl_TessLevelOuter[0] = 64;
	gl_TessLevelOuter[1] = 64;
	gl_TessLevelOuter[2] = 64;
	gl_TessLevelOuter[3]= 64;//Quadsonly!

	barrier();//Not actually necessary in this particular shader!
	gl_out[gl_InvocationID].gl_Position =
		gl_in[gl_InvocationID].gl_Position;
}
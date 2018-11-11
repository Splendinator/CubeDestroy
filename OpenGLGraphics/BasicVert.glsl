#version 440 core

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projMatrix;

in  vec3 position;
in  vec2 texCoord;
in  vec4 colour;
in  vec3 normal;

out Vertex	{
	vec2 texCoord;
	vec4 colour;
	vec3 position;
	vec3 normal;
} OUT;


uniform float time;
uniform int code;

const float SHRINK_TIME = 10000; //Time in MS for the object to shrink.


//Ex1 - Shrink object
void Ex1(void){
	gl_Position *=  1 - min((time/SHRINK_TIME),1);
}



void main(void)	{
	//gl_Position		= (projMatrix * viewMatrix * modelMatrix) * vec4(position, 1.0);
	gl_Position = vec4(position, 1.0);
	
	if(code == 1) Ex1();
	
	
	OUT.texCoord	= texCoord;
	OUT.colour		= colour;
	OUT.position	= position;
	OUT.normal		= normal;


}


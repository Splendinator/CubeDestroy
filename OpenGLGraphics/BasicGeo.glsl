#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

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
} OUT;

uniform float time;
uniform int code;

//Create random direction for fallApart() using texCoord as the seed.
vec3 randomDir(){

	float randx = 8 - int(IN[0].texCoord.x * 10007 + IN[1].texCoord.y * 9931 + IN[2].texCoord.x * 9929)%17;
	float randy = int(IN[1].texCoord.x * 9973 + IN[2].texCoord.y * 9941 + IN[0].texCoord.x * 9923)%29;
	float randz = 8 - int(IN[2].texCoord.x * 9967 + IN[0].texCoord.y * 9949 + IN[1].texCoord.x * 9907)%17;
	
	return normalize(vec3(randx,randy,randz));
}

const float MOVE_SPEED = 40;

void fallApart(int i){

		gl_Position += (vec4(randomDir() * time/MOVE_SPEED,0) + vec4(0,-1*pow(time,1.82)/15000,0,0));

}

void main() {
	for (int i = 0; i < gl_in.length(); ++i) {
		gl_Position = gl_in[i].gl_Position;
		if(code == 4) fallApart(i);
		OUT.colour = IN[i].colour;
		OUT.texCoord = IN[i].texCoord;
		OUT.position = IN[i].position;
		OUT.normal = IN[i].normal;
		EmitVertex();


	}

	EndPrimitive();
	

}
#version 400

layout ( quads ,equal_spacing, cw ) in ;


uniform mat4 modelMatrix ;
uniform mat4 viewMatrix ;
uniform mat4 projMatrix ;



in Vertex {//Sent from the TCS
	vec2 texCoord;
	vec4 colour;
			vec3 position;
	vec3 normal;
} IN [];//Equal to TCS layoutsize

out Vertex {//EachTESworksonasinglevertex!
	vec2 texCoord;
	vec4 colour;
			vec3 position;
	vec3 normal;
} OUT ;


vec3 QuadMixVec3 ( vec3 a , vec3 b , vec3 c , vec3 d ) {
vec3 p0 = mix (a ,c , gl_TessCoord . x );
vec3 p1 = mix (b ,d , gl_TessCoord . x );

return mix ( p0 , p1 , gl_TessCoord . y );
 }

 vec3 QuadMixVec3t ( vec3 a , vec3 b , vec3 c , vec3 d ) {
vec3 p0 = mix (a ,c , 0.5 );
vec3 p1 = mix (b ,d , 0.5 );

return mix ( p0 , p1 , 0.5);
 }

vec2 QuadMixVec2 ( vec2 a , vec2 b , vec2 c , vec2 d ) {
 vec2 p0 = mix (a ,c , gl_TessCoord . x );
 vec2 p1 = mix (b ,d , gl_TessCoord . x );

return mix ( p0 , p1 , gl_TessCoord . y );
 
}

vec4 QuadMixVec4 ( vec4 a , vec4 b , vec4 c , vec4 d ) {
 vec4 p0 = mix (a ,c , gl_TessCoord . x );
 vec4 p1 = mix (b ,d , gl_TessCoord . x );

return mix ( p0 , p1 , gl_TessCoord . y );
 
}

uniform int code;
uniform float time;
const float CRATER_DEPTH = 4;
const float CRATER_SIZE = 0.5;
const float CRATER_TIME = 7000;

vec3 Crater (vec3 pos) {
	if(time > CRATER_TIME && pos.z == -1){ //Select front face
		pos.z  = (-1+(clamp((sqrt(2)-sqrt(pos.x*pos.x + pos.y*pos.y)-CRATER_SIZE)*CRATER_DEPTH,0,2)));
	}
	return pos;
}


void main () {
 vec3 combinedPos = QuadMixVec3 ( gl_in [0]. gl_Position . xyz ,
 gl_in [1]. gl_Position . xyz ,
 gl_in [2]. gl_Position . xyz ,
 gl_in [3]. gl_Position . xyz );

 OUT . texCoord = QuadMixVec2 ( IN [0]. texCoord ,
 IN [1]. texCoord ,
 IN [2]. texCoord ,
 IN [3]. texCoord );
 
 if(code == 5) combinedPos = Crater(combinedPos);

 OUT.colour		= QuadMixVec4(IN[0].colour,IN[1].colour,IN[2].colour,IN[3].colour);


 //NORMAL
 vec3 normal = normalize(QuadMixVec3(IN[0].normal,IN[1].normal,IN[2].normal,IN[3].normal));
 vec4 normal4 = normalize(modelMatrix * vec4 ( normal , 1));	//Translate normal to world position?
 normal4.x = -normal4.x;	
 //normal4.z = -normal4.z;//I have no idea what is going on.
 OUT.normal = normalize(vec3(normal4.x,normal4.y,normal4.z));



 //POSITION
 vec4 worldPos = modelMatrix * vec4 ( combinedPos , 1) ;
 gl_Position = projMatrix * viewMatrix * worldPos ;
 OUT.position = vec3(gl_Position.x,gl_Position.y,gl_Position.z);
 

 }

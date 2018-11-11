#version 440 core

in Vertex	{
	vec2 texCoord;
	vec4 colour;
	vec3 position;
	vec3 normal;
} IN;

//In the tutorial notes, I've used gl_FragColor for the output variable. This is fine on the uni machines, but 
//doesn't play very nicely with some intel and amd graphics drivers, due to the gl_ prefix. For this reason,
//it's better to use a different variable name - so pick something sensible.
out vec4 fragColour;

vec2 texC;

uniform sampler2D texBrick;
uniform sampler2D texBrickD;

uniform float time;
uniform vec3 lightPos;
uniform int code;

//EX2
const float TEX_TIME = 10000;

//EX3
const float FADE_TIME = 10000;

//WAVEY
const float WAVE_TIME = 10000;
const float WAVE_FREQ = 8;				//Waves per cube face
const float WAVE_AMP = 0.7;				//Max distortion percent
const float WAVE_START_SPEED = 2000;	//Speed of effect, lower faster
const float WAVE_END_SPEED = 200;

//LIGHT
const float LIGHT_RADIUS = 20;	
const vec4 LIGHT_COLOUR = vec4(1,0,0,1);
const vec4 AMBIENCE_COLOUR = vec4(0,0,0,1);
const vec4 SPEC_COLOUR = vec4(1,1,1,1);
const float LIGHT_TIME = 7500;



//Texture deterioration
void Ex2(){
	fragColour = mix(texture(texBrick,texC),texture(texBrickD,texC),min((time/TEX_TIME),1));
}

//Alpha Fade
void Ex3(){
	fragColour.w = 1 - time/FADE_TIME;
}

//Makes the block look like it's being beamed up by waving texture.
void Wavey(){
	texC.x += (WAVE_AMP*sin(texC.y*WAVE_FREQ + time/(WAVE_START_SPEED - (WAVE_START_SPEED - WAVE_END_SPEED)*min(time/WAVE_TIME,1.0f))));
}

void Light(){
	
		//Apply Ambience
		fragColour = mix(fragColour,AMBIENCE_COLOUR,0.7);
		//Apply Diffuse
		vec3 incident = normalize(lightPos - IN.position);
		float lightPct = clamp(dot(incident,IN.normal),0,1);
		fragColour = mix(fragColour,LIGHT_COLOUR,lightPct*clamp((1-abs(length(lightPos - IN.position))/LIGHT_RADIUS),0,1));


		//Apply Specularity 
		vec3 halfAngle = normalize(incident + vec3(0,0,-10));
		vec4 spec = SPEC_COLOUR * pow(clamp(dot(IN.normal,halfAngle),0,1),8);
		spec.w = 1;
		fragColour = mix(fragColour,spec,lightPct*clamp((1-abs(length(lightPos - IN.position))/LIGHT_RADIUS),0,1));

		if(IN.colour.w == 0){
			fragColour = LIGHT_COLOUR;
		}
	
}

void main(void)	{	
	

	texC = IN.texCoord;
	
	//if (IN.normal.x + IN.normal.z + IN.normal.y > 0 ) fragColour = vec4(1,1,1,1);
	
	if (code == 3) Wavey();
	
	fragColour = texture(texBrick,texC);


	if(code == 5) Light();
	


	if (code == 2) Ex2();

	if (code == 3) Ex3();

	

	
}
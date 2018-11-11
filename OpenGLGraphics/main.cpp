#include "Renderer.h"
#include "RenderObject.h"

#pragma comment(lib, "nclgl.lib")






void main(void) {
	Window w = Window(800, 800);
	Renderer r(w);

	Mesh*	m	= Mesh::LoadMeshFile("cubePatch.asciimesh");
	//Mesh *m = Mesh::GenerateSquarePatch();
	Shader* s = new Shader("basicvert.glsl", "basicFrag.glsl", "BasicGeo.glsl", "BasicTessCont.glsl", "BasicTessEva.glsl");
	Vector3 lightPos = Vector3(-20,0,0);

	if (s->UsingDefaultShader()) {
		cout << "Warning: Using default shader! Your shader probably hasn't worked..." << endl;
		cout << "Press any key to continue." << endl;
		std::cin.get();
	}
	m->type = GL_PATCHES;
	RenderObject o(m, s);

	glUseProgram(o.GetShader()->GetShaderProgram());

	//SETTING UP ALPHA BLENDING
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


	//TEXTURES -- BRICK WALL UNDESTROYED.
	GLuint tex[2];
	glGenTextures(2, tex);
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, tex[0]);
	int width = 512, height = 512;
	unsigned char* image = SOIL_load_image("Brick1.jpg", &width, &height, 0, SOIL_LOAD_AUTO);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, image);
	SOIL_free_image_data(image);
	glUniform1i(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "texBrick"), 0);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	
	//TEXTURES -- DESTROYED BRICK WALL
	glActiveTexture(GL_TEXTURE1);
	glBindTexture(GL_TEXTURE_2D, tex[1]);
	image = SOIL_load_image("Brick3.png", &width, &height, 0, SOIL_LOAD_AUTO);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, image);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glUniform1i(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "texBrickD"), 1);


	

	//OPENGL PARAMETERS

	float time = 0;

	glPatchParameteri(GL_PATCH_VERTICES, 4);
	//glEnable(GL_CULL_FACE);

	
	

	
	o.SetModelMatrix(Matrix4::Translation(Vector3(0,0,0)) * Matrix4::Scale(Vector3(1.5,1.2,0.9)));
	r.AddRenderObject(o);

	r.SetProjectionMatrix(Matrix4::Perspective(1, 100, 1.33f, 45.0f));

	r.SetViewMatrix(Matrix4::BuildViewMatrix(Vector3(0, 0, -10), Vector3(0, 0, 0)));

	


	//LASER
	Mesh*	laserMesh = Mesh::GenerateLaser();
	laserMesh->type = GL_PATCHES;
	RenderObject laserObject = RenderObject(laserMesh,s);
	
	r.AddRenderObject(laserObject);

	glUniform1i(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "code"), 0);


	while(w.UpdateWindow()) {
		float msec = w.GetTimer()->GetTimedMS();

		if (Keyboard::KeyTriggered(KeyboardKeys::KEY_0)) {
			time = 0;
			glUniform1i(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "code"), 0);
			lightPos = Vector3(-20, 0, 0);
		}
		else if (Keyboard::KeyTriggered(KeyboardKeys::KEY_1)) {
			time = 0;
			glUniform1i(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "code"), 1);
			lightPos = Vector3(-20, 0, 0);
		}
		else if (Keyboard::KeyTriggered(KeyboardKeys::KEY_2)) {
			time = 0;
			glUniform1i(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "code"), 2);
			lightPos = Vector3(-20, 0, 0);
		}
		else if (Keyboard::KeyTriggered(KeyboardKeys::KEY_3)) {
			time = 0;
			glUniform1i(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "code"), 3);
			lightPos = Vector3(-20, 0, 0);
			glEnable(GL_CULL_FACE);
		}
		else if (Keyboard::KeyTriggered(KeyboardKeys::KEY_4)) {
			time = 0;
			glUniform1i(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "code"), 4);
			glDisable(GL_CULL_FACE);
			lightPos = Vector3(-20, 0, 0);
		}
		else if (Keyboard::KeyTriggered(KeyboardKeys::KEY_5)) {
			time = 0;
			glUniform1i(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "code"), 5);
			lightPos = Vector3(13, 0, 5);
			o.SetModelMatrix(Matrix4::Translation(Vector3(0, 0, 0)) * Matrix4::Scale(Vector3(1.5, 1.2, 0.9)) * Matrix4::Rotation(45,Vector3(0,1,0)));
		}

		//cout << time << endl;

		//Pass time in MS as global variable.
		GLuint loc = glGetUniformLocation(o.GetShader()->GetShaderProgram(), "time");
		glUniform1f(loc, time += msec);

		//Light location
		if (time < 5000)						lightPos.x -= msec / 115;
		else if (time < 7000)					lightPos += Vector3(msec / 72, 0 , msec/500);
		else lightPos += Vector3(-200, 0, 0);

		laserObject.SetModelMatrix(Matrix4::Translation(Vector3(-lightPos.x, lightPos.y, -10+lightPos.z)*0.5) * Matrix4::Scale(Vector3(0.40,0.08,0.08)));
		glUniform3fv(glGetUniformLocation(o.GetShader()->GetShaderProgram(), "lightPos"), 1, (float *)&lightPos);

		//r.SetViewMatrix(Matrix4::Rotation(0.1f*msec, Vector3(0, 1, 0)));
		

		o.SetModelMatrix(o.GetModelMatrix() * Matrix4::Rotation(msec*0.04f, Vector3(0, 1, 0)));
		//o.SetModelMatrix(o.GetModelMatrix() * Matrix4::Translation(Vector3(0, 0, -20)));
		

		r.UpdateScene(msec);
		r.ClearBuffers();
		r.RenderScene();
		r.SwapBuffers();
	}
	delete m;
	delete s;
}


#version 100

attribute vec3 pos;
attribute vec3 normal;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

varying vec3 norm;

void kore() {
	norm = (model * vec4(normal, 0.0)).xyz;
	gl_Position = projection * view * model * vec4(pos, 1.0);
}

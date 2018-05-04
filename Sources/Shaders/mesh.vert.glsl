#version 450

in vec3 pos;
in vec3 normal;
in vec2 texcoord;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

out vec3 norm;
out vec2 tex;

void main() {
	norm = (model * vec4(normal, 0.0)).xyz;
	tex = texcoord;
	gl_Position = projection * view * model * vec4(pos, 1.0);
}

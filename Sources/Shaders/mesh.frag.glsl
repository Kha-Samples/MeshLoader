#version 450

in vec3 norm;

out vec4 frag;

void main() {
	vec3 lightdir = vec3(-0.2, 0.5, -0.3);
	frag = vec4(dot(norm, lightdir) * vec3(1.0, 1.0, 1.0), 1.0);
}

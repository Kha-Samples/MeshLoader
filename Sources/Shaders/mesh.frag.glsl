#version 450

in vec3 norm;
in vec2 tex;

uniform sampler2D image;

out vec4 frag;

void main() {
	vec3 lightdir = vec3(-0.2, 0.5, -0.3);
	frag = vec4(dot(norm, lightdir) * texture(image, vec2(tex.x, 1 - tex.y)).xyz, 1.0);
}

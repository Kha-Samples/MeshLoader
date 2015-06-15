#version 100

precision mediump float;

varying vec3 norm;

void kore() {
	vec3 lightdir = vec3(-0.2, 0.5, -0.3);
	gl_FragColor = vec4(dot(norm, lightdir) * vec3(1.0, 1.0, 1.0), 1.0);
}

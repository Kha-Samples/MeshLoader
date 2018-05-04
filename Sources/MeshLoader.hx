package;

import kha.Framebuffer;
import kha.Color;
import kha.graphics4.CompareMode;
import kha.graphics4.ConstantLocation;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Assets;
import kha.Shaders;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.Scheduler;
import kha.System;

class MeshLoader {
	private var pipeline: PipelineState;
	private var vertexBuffer: VertexBuffer;
	private var indexBuffer: IndexBuffer;
	private var rotationLocation: ConstantLocation;
	private var projectionLocation: ConstantLocation;
	private var viewLocation: ConstantLocation;
	private var modelLocation: ConstantLocation;
	private var texUnit: TextureUnit;
	private var started: Bool = false;
	
	public function new() {
		Assets.loadEverything(start);
	}
	
	private function start(): Void {
		var data = new OgexData(Assets.blobs.tiger_ogex.toString());
		var vertices = data.geometryObjects[0].mesh.vertexArrays[0].values;
		var normals = data.geometryObjects[0].mesh.vertexArrays[1].values;
		var texcoords = data.geometryObjects[0].mesh.vertexArrays[2].values;
		var indices = data.geometryObjects[0].mesh.indexArray.values;
		
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("normal", VertexData.Float3);
		structure.add("texcoord", VertexData.Float2);
		vertexBuffer = new VertexBuffer(vertices.length, structure, Usage.StaticUsage);
		var buffer = vertexBuffer.lock();
		for (i in 0...Std.int(vertices.length / 3)) {
			buffer.set(i * 8 + 0, vertices[i * 3 + 0]);
			buffer.set(i * 8 + 1, vertices[i * 3 + 1]);
			buffer.set(i * 8 + 2, vertices[i * 3 + 2]);
			buffer.set(i * 8 + 3, normals[i * 3 + 0]);
			buffer.set(i * 8 + 4, normals[i * 3 + 1]);
			buffer.set(i * 8 + 5, normals[i * 3 + 2]);
			buffer.set(i * 8 + 6, texcoords[i * 2 + 0]);
			buffer.set(i * 8 + 7, texcoords[i * 2 + 1]);
		}
		vertexBuffer.unlock();
		
		indexBuffer = new IndexBuffer(indices.length, Usage.StaticUsage);
		var ibuffer = indexBuffer.lock();
		for (i in 0...indices.length) {
			ibuffer[i] = indices[i];
		}
		indexBuffer.unlock();
		
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.mesh_vert;
		pipeline.fragmentShader = Shaders.mesh_frag;
		pipeline.depthWrite = true;
		pipeline.depthMode = CompareMode.Less;
		pipeline.compile();
		
		projectionLocation = pipeline.getConstantLocation("projection");
		viewLocation = pipeline.getConstantLocation("view");
		modelLocation = pipeline.getConstantLocation("model");
		texUnit = pipeline.getTextureUnit("image");
		
		started = true;
	}
	
	public function render(frame: Framebuffer): Void {
		var g = frame.g4;
		g.begin();
		g.clear(Color.Black, Math.POSITIVE_INFINITY);
		if (started) {
			g.setPipeline(pipeline);
			g.setMatrix(projectionLocation, FastMatrix4.perspectiveProjection(45, System.windowWidth(0) / System.windowHeight(0), 0.1, 50));
			g.setMatrix(viewLocation, FastMatrix4.lookAt(new FastVector3(0, 0, -5), new FastVector3(0, 0, 0), new FastVector3(0, 1, 0)));
			g.setMatrix(modelLocation, FastMatrix4.rotationY(Scheduler.time()));
			g.setTexture(texUnit, Assets.images.tiger_atlas);
			
			g.setIndexBuffer(indexBuffer);
			g.setVertexBuffer(vertexBuffer);
			g.drawIndexedVertices();
		}
		g.end();
	}
}

package;

import kha.Framebuffer;
import kha.Game;
import kha.Color;
import kha.graphics4.CompareMode;
import kha.graphics4.ConstantLocation;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Program;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Loader;
import kha.math.Matrix4;
import kha.math.Vector3;
import kha.math.Vector4;
import kha.Scheduler;

using StringTools;

class MeshLoader extends Game {
	private var program: Program;
	private var vertexBuffer: VertexBuffer;
	private var indexBuffer: IndexBuffer;
	private var rotationLocation: ConstantLocation;
	private var projectionLocation: ConstantLocation;
	private var viewLocation: ConstantLocation;
	private var modelLocation: ConstantLocation;
	private var started: Bool = false;
	
	public function new() {
		super("MeshLoader");
	}
	
	override public function init(): Void {
		Loader.the.loadRoom('level1', start);
	}
	
	private function start(): Void {
		var data = new OgexData(Loader.the.getBlob('body').toString());
		var vertices = data.geometryObjects[0].mesh.vertexArrays[0].values;
		var normals = data.geometryObjects[0].mesh.vertexArrays[1].values;
		var indices = data.geometryObjects[0].mesh.indexArray.values;
			
		var structure = new VertexStructure();
		structure.add('pos', VertexData.Float3);
		structure.add('normal', VertexData.Float3);
		vertexBuffer = new VertexBuffer(vertices.length, structure, Usage.StaticUsage);
		var buffer = vertexBuffer.lock();
		for (i in 0...Std.int(vertices.length / 3)) {
			buffer.set(i * 6 + 0, vertices[i * 3 + 0]);
			buffer.set(i * 6 + 1, vertices[i * 3 + 1]);
			buffer.set(i * 6 + 2, vertices[i * 3 + 2]);
			buffer.set(i * 6 + 3, normals[i * 3 + 0]);
			buffer.set(i * 6 + 4, normals[i * 3 + 1]);
			buffer.set(i * 6 + 5, normals[i * 3 + 2]);
		}
		vertexBuffer.unlock();
		
		indexBuffer = new IndexBuffer(indices.length, Usage.StaticUsage);
		var ibuffer = indexBuffer.lock();
		for (i in 0...indices.length) {
			ibuffer[i] = indices[i];
		}
		indexBuffer.unlock();
		
		var vs = new VertexShader(Loader.the.getShader('mesh.vert'));
		var fs = new FragmentShader(Loader.the.getShader('mesh.frag'));
		
		program = new Program();
		program.setVertexShader(vs);
		program.setFragmentShader(fs);
		program.link(structure);
		
		projectionLocation = program.getConstantLocation("projection");
		viewLocation = program.getConstantLocation("view");
		modelLocation = program.getConstantLocation("model");
		
		started = true;
	}
	
	override public function render(frame: Framebuffer): Void {
		var g = frame.g4;
		g.begin();
		g.clear(Color.Black, Math.POSITIVE_INFINITY);
		if (started) {
			g.setDepthMode(true, CompareMode.Less);
			g.setProgram(program);
			g.setMatrix(projectionLocation, Matrix4.perspectiveProjection(Math.PI / 4, width / height, 0.1, 1000));
			g.setMatrix(viewLocation, Matrix4.lookAt(new Vector3(0, 0, -500), new Vector3(0, 0, 0), new Vector3(0, 1, 0)));
			g.setMatrix(modelLocation, Matrix4.rotationY(Scheduler.time()));
			
			g.setIndexBuffer(indexBuffer);
			g.setVertexBuffer(vertexBuffer);
			g.drawIndexedVertices();
		}
		g.end();
	}
}

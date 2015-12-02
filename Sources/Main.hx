package;

import kha.System;

class Main {
	public static function main() {
		System.init("MeshLoader", 800, 600, init);
	}

	static function init() {
		var game = new MeshLoader();
		System.notifyOnRender(game.render);
	}
}

package;

import kha.System;

class Main {
	public static function main() {
		System.init({title: "MeshLoader", width: 800, height: 600}, init);
	}

	static function init() {
		var game = new MeshLoader();
		System.notifyOnRender(game.render);
	}
}

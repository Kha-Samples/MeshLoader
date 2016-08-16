let project = new Project('MeshLoader');

project.addSources('Sources');
project.addShaders('Sources/Shaders/**');
project.addAssets('Assets/**');

resolve(project);

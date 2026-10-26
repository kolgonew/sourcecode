#version 150

// SDF GUI shader - vertex stage.
//
// Vertex format: VertexFormats.POSITION_TEXTURE_COLOR (net.minecraft.client.render.VertexFormats),
// czyli atrybuty "Position", "UV0", "Color" - dokladnie te same, ktorych uzywa waniliowy
// shader position_tex_color, wiec nie potrzebujemy wlasnego VertexFormat.
//
// UV0 niesie LOKALNY offset wierzcholka od srodka prostokata (w jednostkach logicznych GUI),
// a nie wspolrzedne tekstury - sampler nie jest uzywany (JSON: "samplers": []).

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 vLocal;
out vec4 vColor;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vLocal = UV0;
    vColor = Color;
}

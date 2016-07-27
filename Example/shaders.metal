//
//  shaders.metal
//  MetalMemory
//
//  Created by Silvan Mosberger on 27/07/16.
//
//

#include <metal_stdlib>
using namespace metal;

struct Particle {
	float x;
	float y;
};

struct Point {
	float4 position [[ position ]];
	float size [[ point_size ]];
};

vertex Point basicVertex(const device Particle *particles [[ buffer(0) ]],
					uint i [[ vertex_id ]]) {
	Point point;
	point.position = float4(particles[i].x * 2 - 1, particles[i].y * 2 - 1, 0.5, 1);
	point.size = 1;
	
	return point;
}

fragment float4 basicFragment(Point point [[ stage_in ]]) {
	return 1;
}
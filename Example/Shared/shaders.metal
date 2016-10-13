//
//  shaders.metal
//  MetalMemory
//
//  Created by Silvan Mosberger on 27/07/16.
//
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basicVertex(const device float2 *data [[ buffer(0) ]],
						  uint i [[ vertex_id ]]) {
	return float4(data[i].x, data[i].y, 0, 1);
}

fragment float4 basicFragment() {
	return 1;
}

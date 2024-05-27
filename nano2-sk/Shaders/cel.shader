//
//  cel.shader
//  nano2-sk
//
//  Created by Althaf Nafi Anwar on 20/05/24.
//
//

//#include <metal_stdlib>
//using namespace metal;

const float PIover2 = (3.14159265358979 / 2.0);
const float lineTolerance = 1.2;

float dotProduct = dot(_surface.view, _surface.normal);

if ( !((PIover2 + lineTolerance) >= dotProduct && dotProduct >= (PIover2 - lineTolerance)) ) {
    _output.color.rgba = vec4(1.0, 0.5, 0.0, 1.0);
}



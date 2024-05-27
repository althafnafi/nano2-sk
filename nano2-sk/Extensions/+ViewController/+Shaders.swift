//
//  +Shaders.swift
//  nano2-sk
//
//  Created by Althaf Nafi Anwar on 27/05/24.
//

import Foundation
import SceneKit

extension ViewController {
    func initShaders(node: SCNNode){
        // Add shaders to models
        let shaderUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "Shaders/cel", ofType: "shader")!)
        var shaderData:String!
        
        do {
            shaderData = try String(contentsOf: shaderUrl, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
        self.shaders[SCNShaderModifierEntryPoint.fragment] = shaderData
        self.shaderMod = "float flakeSize = sin(u_time * 0.2);\n" + "float flakeIntensity = 0.7;\n" + "vec3 paintColor0 = vec3(0.9, 0.4, 0.3);\n" + "vec3 paintColor1 = vec3(0.9, 0.75, 0.2);\n" + "vec3 flakeColor = vec3(flakeIntensity, flakeIntensity, flakeIntensity);\n" + "vec3 rnd =  texture2D(u_diffuseTexture, _surface.diffuseTexcoord * vec2(1.0) * sin(u_time*0.1) ).rgb;\n" + "vec3 nrm1 = normalize(0.05 * rnd + 0.95 * _surface.normal);\n" + "vec3 nrm2 = normalize(0.3 * rnd + 0.4 * _surface.normal);\n" + "float fresnel1 = clamp(dot(nrm1, _surface.view), 0.0, 1.0);\n" + "float fresnel2 = clamp(dot(nrm2, _surface.view), 0.0, 1.0);\n" + "vec3 col = mix(paintColor0, paintColor1, fresnel1);\n" + "col += pow(fresnel2, 106.0) * flakeColor;\n" + "_surface.normal = nrm1;\n" + "_surface.diffuse = vec4(col.r,col.b,col.g, 1.0);\n" + "_surface.emission = (_surface.reflective * _surface.reflective) * 2.0;\n" + "_surface.reflective = vec4(0.0);\n"
    }

    func addCelShaders(node: SCNNode) -> SCNNode {
        shaders[SCNShaderModifierEntryPoint.surface] = self.shaderMod
        node.geometry?.firstMaterial?.shaderModifiers = self.shaders
        
        return node
    }
}

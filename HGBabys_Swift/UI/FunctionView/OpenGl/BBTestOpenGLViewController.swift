
//
//  BBTestOpenGLViewController.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/9/4.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES.ES1.gl
class BBTestOpenGLViewController: BBOpenGLViewController {

	var interval: GLfloat = 0
	var vertexBuffer: [GLfloat] = [0,50,
	                               50,75,
	                               100,50,
	                               50,25]

    override func viewDidLoad() {
        super.viewDidLoad()



		
        // Do any additional setup after loading the view.
		glkView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
		glkView.context = EAGLContext(api: .openGLES1)!
		EAGLContext.setCurrent(glkView.context)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


	// MARK: - OpenGL
	override func updata() {
		if vertexBuffer[4] >= 100 {
			interval = -1
		}else if vertexBuffer[4] < 50{
			interval = 1
		}
		vertexBuffer[2] += interval
		vertexBuffer[4] += interval

	}
	override func glkView(_ view: GLKView, drawIn rect: CGRect) {

		glViewport(0, 0, GLsizei(rect.width * 3), GLsizei(rect.height * 3))
		glMatrixMode(GLenum(GL_PROJECTION))
		glLoadIdentity()
		glOrthof(0, 100, 0, 100, -1024, 1024)
		glMatrixMode(GLenum(GL_MODELVIEW))
		glLoadIdentity()

		glEnable(GLenum(GL_BLEND))
		glDisable(GLenum(GL_DEPTH_TEST))
		glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_SRC_COLOR))

		glEnableClientState(GLenum(GL_VERTEX_ARRAY))
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
		glColor4f(1, 0, 0, 1)


		glVertexPointer(2, GLenum(GL_FLOAT), 0, vertexBuffer)
		glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, 4)
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


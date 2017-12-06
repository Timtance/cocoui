# COCOUI Framework

  > cocoui是一个基于as3的组件框架



  `使用demo`

  ```java
  public class demo extends Application
  	{
  		public function demo()
  		{
  		}
  		
  		override protected function createChildren():void
          {
          	super.createChildren();
          	
          	// add child here
          	var button:Button = new Button();
          	button.label = "this is my first demo";
          	addChild(button);
          }
  		
  	}

  ```

  ​


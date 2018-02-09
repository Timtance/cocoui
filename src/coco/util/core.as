package coco.util
{
	/**
     * 输出核心信息，当CocoUI.userCore=true时才会输出调试信息
     */    
	public function core(...parameters):void
	{
		if (CocoUI.useCore)
		{
			var arg:Array = parameters as Array;
			if (arg.length > 0)
				arg[0] = "[cocoui" + CocoUI.VERSION + "][Core] " + arg[0];
			trace(arg);
		}
	}
}


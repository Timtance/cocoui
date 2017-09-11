package coco.component
{
	import flash.display.DisplayObject;
	
	import coco.core.UIComponent;
	import coco.core.coco;
	
	/**
	 *
	 * 原始视图
	 * 
	 * 原始视图中 含有一个真实视图
	 *  
	 * @author coco
	 * 
	 */	
	public class RawView extends SkinComponent
	{
		public function RawView()
		{
			super();
			
			autoDrawSkin = false;
		}
		
		protected var realView:UIComponent;
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// child application
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override coco function setChildrenApplication():void
		{
			var child:DisplayObject;
			for (var i:int = 0; i < numRawChildren; i++)
			{
				child = getRawChildAt(i);
				if (child is UIComponent)
					UIComponent(child).application = application;
			}
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Raw Child
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		public function addRawChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child, index);
		}
		
		public function removeRawChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		
		public function removeRawChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index);
		}
		
		public function get numRawChildren():int
		{
			return super.numChildren;
		}
		
		public function getRawChildAt(index:int):DisplayObject
		{
			return super.getChildAt(index);
		}
		
		public function getRawChildByName(name:String):DisplayObject
		{
			return super.getChildByName(name);
		}
		
		public function getRawChildIndex(child:DisplayObject):int
		{
			return super.getChildIndex(child);
		}
		
		public function removeAllRawChild():void
		{
			super.removeAllChild();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Child
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if (realView)
				return realView.addChild(child);
			else
				return null;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if (realView)
				return realView.addChildAt(child, index);
			else
				return null;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if (realView)
				return realView.removeChild(child);
			else
				return null;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			if (realView)
				return realView.removeChildAt(index);
			else
				return null;
		}
		
		override public function get numChildren():int
		{
			if (realView)
				return realView.numChildren;
			else 
				return null;
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			if (realView)
				return realView.getChildAt(index);
			else
				return null;
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			if (realView)
				return realView.getChildByName(name);
			else
				return null;
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			if (realView)
				return realView.getChildIndex(child);
			else
				return -1;
		}
		
		override public function removeAllChild():void
		{
			if (realView)
				realView.removeAllChild();
		}
		
	}
}
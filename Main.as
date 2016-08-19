package 
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.dj.net.DJSharedObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author David Lai
	 * 
	 * HOW TO USE:
	 * 1. Drag the MovieClip and MOUSE_UP, DJSharedObject will save the MC's position.
	 * 2. Close the SWF and reopen it, you will find the point of MovieClip is last MOUSE_UP.
	 * 3. Click the "CLEAR  SharedObject", DJSharedObject's data will be removed.
	 */
	
	public class Main extends Sprite	{
		
		private const MY_TEST:String = "myTest";						// SharedObject Name
		private const MC_POSITION:String = "mcPosition";				// SharedObject Property Name
		
		private var dragObj_mc:MovieClip;
		
		
		
		public function Main() {
			this.init();
		}
		
		//
		// INIT, LOAD SO
		//
		private function init():void {
			
			this.dragObj_mc = new DragObj();
			this.dragObj_mc.buttonMode = true;
			this.dragObj_mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
			this.addChild(this.dragObj_mc);
			
			//
			// LOAD
			//
			var _point:* = DJSharedObject.localLoad(this.MY_TEST, this.MC_POSITION);
			var _btn:PushButton = new PushButton(this, 50, 25, "CLEAR  SharedObject", clearHandler);
			var _msg:String;
			var _lastPosLabel:Label;
			
			if(_point == undefined)
			{
				this.dragObj_mc.x = stage.stageWidth / 2;
				this.dragObj_mc.y = stage.stageHeight / 2;
				_msg = "IT HAVE NOT SharedObject BEFORE.";
			}
			else 
			{
				this.dragObj_mc.x = _point.x;
				this.dragObj_mc.y = _point.y;
				_msg = "xPos: " + String(_point.x) + " , " + "yPos: " + String(_point.y);
			}
			
			_lastPosLabel = new Label(this, 50, 50, "LAST POSITION: " + _msg );
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
		}
		
		//
		// ON MOUSE UP, SAVE SO
		//
		private function onMouseHandler(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:
					this.dragObj_mc.startDrag(true);
					e.updateAfterEvent();
					break;
					
				case MouseEvent.MOUSE_UP:
					this.dragObj_mc.stopDrag();										//trace(this.dragObj_mc.x);		trace(this.dragObj_mc.y);
					var mcPos:Point = new Point(this.dragObj_mc.x, this.dragObj_mc.y);
					
					//
					// SAVE
					//
					DJSharedObject.localSave(this.MY_TEST, this.MC_POSITION, mcPos);
					break;
			}
		}
		
		//
		// CLEAR SO
		//
		private function clearHandler(e:MouseEvent):void {
			DJSharedObject.clearSO(this.MY_TEST);
		}
		
		
	}
	
}
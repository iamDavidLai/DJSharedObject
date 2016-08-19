package com.dj.net {
	
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.display.DisplayObject;
	
	/**
	 * @author 	David Lai
	 * @version 	1.0.0
	 * @remark 	ONE LINE CODE, to save or load your data that you want.
	 * 
	 * @created 	2014.04.14
	 * @updated 	2016.06.21
	 * 
	 * HOW TO USE：
	 * (1) SAVE: DJSharedObject.localSave("SO_Name", "Obj_PropertyName", Value);							
	 * (2) LOAD: DJSharedObject.localLoad("SO_Name", "Obj_PropertyName") ;  						// It will return objectValue in SharedObject.data.
	 * (3) CLEAR: DJSharedObject.clearSO("SO_Name"); 
	 * 
	 * String參數建議使用 public static const 單元名or屬性名稱:String (ex:自訂事件的EventType)
	 * 可建立列舉(enum)類別儲存其靜態常數字串並引用之，避免手寫輸入時的錯誤發生
	 * 
	 */
	
	
	public class DJSharedObject {

		private static var mySO:SharedObject;
	
	
	
	public function DJSharedObject() {
			throw new Error("請使用類別靜態方法而不是new()~");
		}
		
		
		/**	Local 端儲存資料。注意資料類型不可為DisplayObject	**/
		public static function localSave(_appName:String, _soPropertyName:String, _value:*):void 
		{
			if ((_value is DisplayObject) || (_value == undefined))
			{	// undefined is const instead of  資料類型
				trace("SharedObject 儲存的資料格式有誤,內容不可為DisplayObject 或 undefined !");
				return;
			}
			
			mySO = SharedObject.getLocal(_appName);						// 先定位找到Local Shared Object，若沒有則創造新的 (name參數-物件名稱)
			mySO.data[_soPropertyName] = _value;							// 把要儲存的值指定給data屬性(Object物件)的一個欄位名稱
			var flushResult:String = mySO.flush();								// 直接寫入，flush()方法會傳回String
			switch(flushResult)
			{
				case SharedObjectFlushStatus.FLUSHED:						trace("共享物件 " + _appName + " 已經成功寫入。");					break;
				case SharedObjectFlushStatus.PENDING:
				/* 使用者已經允許這個網域的物件進行本機資訊儲存，但配置的空間量不足以儲存此物件。 
					Flash Player 會提示使用者預留更多空間。 若要在儲存時預留空間，讓共享空間能夠成長，
					進而防止 SharedObjectFlushStatus.PENDING 傳回值，請傳遞值給 minDiskSpace。*/
					mySO.flush(500);													trace("配置空間不足，已擴充儲存空間。");								break;
			}
			
			//
			// ONLY TEST - 把data內的所有值都撈出來確認是否儲存成功
			//
			//for (var i in mySO.data){
				//trace("mySO.data 的屬性: " + i + "	, 屬性值: " + mySO.data[i]);
			//}
			//for each (var j in mySO.data){		trace("成員: " + j);		};
		}
		
		
		
		/**	Local 端 讀取資料		**/
		public static function localLoad(_appName:String, _soPropertyName:String):*
		{	
			mySO = SharedObject.getLocal(_appName);
			
			if (mySO.data[_soPropertyName] == undefined)
			{
				trace("mySO.data中未定義此屬性，請透過localSave()方法新增屬性!!");
				//trace("mySO.data._soPropertyName:" + mySO.data[_soPropertyName]);
				return;
			}
			else
			{
				var _value:*; 
				_value = mySO.data[_soPropertyName];
				//trace("_value: " +_value)
			}
			return _value;
		}
		
		
		/**	清除SharedObject的資料。若是清除網路遠端的SharedObject，這裡的_appName參數就是hostName。	**/
		public static function clearSO(_appName:String):void
		{
			/* 會針對本機共享物件，清除所有資料並從磁碟中刪除共享物件。 
				共享物件的參照仍然會處於使用中狀態，不過會刪除其資料屬性。
				對於搭配 Flash Media Server 一起使用的遠端共享物件，clear() 會使物件中斷連線，並清除所有資料。 
				如果物件是本機持續共享物件，這個方法也會將共享物件從磁碟上刪除。 
				共享物件的參照仍然會處於使用中狀態，不過會刪除其資料屬性。*/
			mySO = SharedObject.getLocal(_appName);
			mySO.clear();
		}

	}
}

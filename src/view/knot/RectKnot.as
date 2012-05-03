package view.knot
{
	import model.KnotType;

	public class RectKnot extends Knot
	{
		public function RectKnot(width:Number,height:Number, type:String = KnotType.NOTHING,color:uint=0x000000, alpha:Number=1.0)
		{
			super(type,color, alpha);
			super._knot.graphics.drawRect(0,0,width,height);
			super._knot.graphics.endFill();
		}
	}
}
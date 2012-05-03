package view.knot
{
	import model.KnotType;

	public class RoundRectKnot extends Knot
	{
		public function RoundRectKnot(width:Number,height:Number,ellipse:Number, type:String = KnotType.NOTHING,color:uint=0x000000, alpha:Number=1.0)
		{
			super(type,color, alpha);
			super._knot.graphics.drawRoundRect(0,0,width,height,ellipse);
			super._knot.graphics.endFill();
		}
	}
}
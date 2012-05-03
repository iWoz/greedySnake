package view.knot
{
	import model.KnotType;

	public class CircleKnot extends Knot
	{
		public function CircleKnot(radis:Number,type:String = KnotType.NOTHING,color:uint = 0x000000,alpha:Number = 1.0)
		{
			super(type,color,alpha);
			super._knot.graphics.drawCircle(0,0,radis);
			super._knot.graphics.endFill();
		}
	}
}
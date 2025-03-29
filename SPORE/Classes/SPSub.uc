//================================================================================
// SPSub.
//================================================================================
class SPSub expands SPActor;

var() float ShrinkTime;
var() float ScaleRate;
var() float ShrinkDelay;
var() float AnimSpeed;
var() bool bSpawnBubbles;
var() float BubbleDrawScale;

event PostBeginPlay ()
{
	if ( AnimSpeed > 0 )
	{
		LoopAnim('swim',AnimSpeed);
	}
	else
	{
		LoopAnim('swim');
	}
	if ( ShrinkDelay == 0 )
	{
		SetTimer(ShrinkTime,True);
	}
	else
	{
		SetTimer(ShrinkDelay,False);
	}
}

event Timer ()
{
	local SPBubble bubble;

	if ( ShrinkDelay > 0 )
	{
		SetTimer(ShrinkTime,True);
		ShrinkDelay=0.00;
	}
	else
	{
		DrawScale=DrawScale + ScaleRate;
		if ( DrawScale <= 0 )
		{
			Disable('Timer');
		}
		if ( bSpawnBubbles )
		{
			bubble=Spawn(Class'SPBubble');
			if ( BubbleDrawScale != 0 )
			{
				bubble.DrawScale=BubbleDrawScale;
			}
			else
			{
				bubble.DrawScale=0.25;
			}
			bubble.Texture=Texture'bubble';
			bubble.LifeSpan=5.00;
		}
	}
}

defaultproperties
{
    ScaleRate=-0.01
    DrawType=DT_Sprite
    Mesh=LodMesh'sub'
}
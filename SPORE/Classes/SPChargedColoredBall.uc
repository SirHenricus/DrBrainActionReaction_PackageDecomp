//================================================================================
// SPChargedColoredBall.
//================================================================================
class SPChargedColoredBall expands SPChargedMedBall;

var() ESporeColor BallColor;

event BeginPlay ()
{
	Super.BeginPlay();
	if ( BallColor == 6 )
	{
		Randomize();
	}
	if ( Level.bEnhancedContent )
	{
		if ( BallColor == 0 )
		{
			Skin=FireTexture(DynamicLoadObject("SporeFX.ball05",Class'FireTexture'));
		}
		else
		{
			if ( BallColor == 2 )
			{
				Skin=FireTexture(DynamicLoadObject("SporeFX.ball01",Class'FireTexture'));
			}
			else
			{
				if ( BallColor == 3 )
				{
					Skin=FireTexture(DynamicLoadObject("SporeFX.ball02",Class'FireTexture'));
				}
				else
				{
					if ( BallColor == 1 )
					{
						Skin=FireTexture(DynamicLoadObject("SporeFX.ball03",Class'FireTexture'));
					}
					else
					{
						if ( BallColor == 5 )
						{
							Skin=FireTexture(DynamicLoadObject("SporeFX.ball04",Class'FireTexture'));
						}
						else
						{
							if ( BallColor == 4 )
							{
								Skin=FireTexture(DynamicLoadObject("SporeFX.ball06",Class'FireTexture'));
							}
						}
					}
				}
			}
		}
	}
	else
	{
		if ( BallColor == 0 )
		{
			Skin=Texture(DynamicLoadObject("SporeFX.ball05",Class'Texture'));
		}
		else
		{
			if ( BallColor == 2 )
			{
				Skin=Texture(DynamicLoadObject("SporeFX.ball01",Class'Texture'));
			}
			else
			{
				if ( BallColor == 3 )
				{
					Skin=Texture(DynamicLoadObject("SporeFX.ball02",Class'Texture'));
				}
				else
				{
					if ( BallColor == 1 )
					{
						Skin=Texture(DynamicLoadObject("SporeFX.ball03",Class'Texture'));
					}
					else
					{
						if ( BallColor == 5 )
						{
							Skin=Texture(DynamicLoadObject("SporeFX.ball04",Class'Texture'));
						}
						else
						{
							if ( BallColor == 4 )
							{
								Skin=Texture(DynamicLoadObject("SporeFX.ball06",Class'Texture'));
							}
						}
					}
				}
			}
		}
	}
}

function Randomize ()
{
	local int C;

	C=Rand(6);
	if ( C == 0 )
	{
		BallColor=0;
	}
	else
	{
		if ( C == 1 )
		{
			BallColor=1;
		}
		else
		{
			if ( C == 2 )
			{
				BallColor=2;
			}
			else
			{
				if ( C == 3 )
				{
					BallColor=3;
				}
				else
				{
					if ( C == 4 )
					{
						BallColor=4;
					}
					else
					{
						if ( C == 5 )
						{
							BallColor=5;
						}
					}
				}
			}
		}
	}
}

defaultproperties
{
    ScaleGlow=5.00
    bUnlit=True
}
//================================================================================
// SPLargeColoredBall.
//================================================================================
class SPLargeColoredBall expands SPLargeBall;

var() ESporeColor BallColor;

event BeginPlay ()
{
	Super.BeginPlay();
	if ( BallColor == 6 )
	{
		Randomize();
	}
	if ( BallColor == 0 )
	{
		Skin=Texture'BallLG05';
	}
	else
	{
		if ( BallColor == 2 )
		{
			Skin=Texture'BallLG01';
		}
		else
		{
			if ( BallColor == 3 )
			{
				Skin=Texture'BallLG02';
			}
			else
			{
				if ( BallColor == 1 )
				{
					Skin=Texture'BallLG03';
				}
				else
				{
					if ( BallColor == 5 )
					{
						Skin=Texture'BallLG04';
					}
					else
					{
						if ( BallColor == 4 )
						{
							Skin=Texture'BallLG06';
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
    BallColor=SC_Green
}
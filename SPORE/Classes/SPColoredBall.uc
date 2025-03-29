//================================================================================
// SPColoredBall.
//================================================================================
class SPColoredBall expands SPMediumBall;

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
		Skin=Texture'BallMD05';
	}
	else
	{
		if ( BallColor == 2 )
		{
			Skin=Texture'BallMD01';
		}
		else
		{
			if ( BallColor == 3 )
			{
				Skin=Texture'BallMD02';
			}
			else
			{
				if ( BallColor == 1 )
				{
					Skin=Texture'BallMD03';
				}
				else
				{
					if ( BallColor == 5 )
					{
						Skin=Texture'BallMD04';
					}
					else
					{
						if ( BallColor == 4 )
						{
							Skin=Texture'BallMD06';
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
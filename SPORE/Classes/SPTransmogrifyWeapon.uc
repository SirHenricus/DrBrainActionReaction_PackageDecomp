//================================================================================
// SPTransmogrifyWeapon.
//================================================================================
class SPTransmogrifyWeapon expands SPPushWeapon;

var() Class<Actor> TransmogrifyClass;

function PreBeginPlay ()
{
	Super.PreBeginPlay();
	ProjectileClass=Class'SPTransmogrifyProjectile';
}

function Projectile ProjectileFire (Class<Projectile> ProjClass, float projSpeed, bool bWarn)
{
	local Vector Start;
	local Vector X;
	local Vector Y;
	local Vector Z;
	local Projectile proj;

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
	Start=Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim=Pawn(Owner).AdjustAim(projSpeed,Start,aimerror,True,bWarn);
	proj=Spawn(ProjClass,Owner,,Start,AdjustedAim);
	if ( SPTransmogrifyProjectile(proj) != None )
	{
		SPTransmogrifyProjectile(proj).SetSpeed(ProjectileSpeed);
		SPTransmogrifyProjectile(proj).Mass=100000.00 / ProjectileSpeed;
		SPTransmogrifyProjectile(proj).TransmogrifyClass=TransmogrifyClass;
		SPTransmogrifyProjectile(proj).Go();
		PlaySound(Sound'helpingh',3);
		AnimState=2;
		CurSkin=0;
		Skin=SkinList[CurSkin];
	}
	return proj;
}

defaultproperties
{
    TransmogrifyClass=Class'SPLargeBall'
}
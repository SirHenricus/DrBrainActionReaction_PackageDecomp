//================================================================================
// NavigationPoint.
//================================================================================
class NavigationPoint expands Actor
	native;

var() name ownerTeam;
var bool taken;
var int upstreamPaths[16];
var int Paths[16];
var int PrunedPaths[16];
var NavigationPoint VisNoReachPaths[16];
var int visitedWeight;
var Actor RouteCache;
var const int bestPathWeight;
var const NavigationPoint nextNavigationPoint;
var const NavigationPoint nextOrdered;
var const NavigationPoint prevOrdered;
var const NavigationPoint startPath;
var const NavigationPoint previousPath;
var int cost;
var() int ExtraCost;
var() bool bPlayerOnly;
var bool bEndPoint;
var bool bEndPointOnly;
var bool bSpecialCost;
var() bool bOneWayPath;
var() byte PathDescription;

native(519) final function describeSpec (int iSpec, out Actor Start, out Actor End, out int ReachFlags, out int Distance);

event int SpecialCost (Pawn Seeker);

event bool Accept (Actor Incoming)
{
	taken=Incoming.SetLocation(Location + vect(0.00,0.00,20.00));
	if ( taken )
	{
		Incoming.Velocity=vect(0.00,0.00,0.00);
		Incoming.SetRotation(Rotation);
	}
	PlayTeleportEffect(Incoming,True);
	return taken;
}

function PlayTeleportEffect (Actor Incoming, bool bOut)
{
	Level.Game.PlayTeleportEffect(Incoming,bOut,False);
}

defaultproperties
{
    upstreamPaths(0)=-1
    upstreamPaths(1)=-1
    upstreamPaths(2)=-1
    upstreamPaths(3)=-1
    upstreamPaths(4)=-1
    upstreamPaths(5)=-1
    upstreamPaths(6)=-1
    upstreamPaths(7)=-1
    upstreamPaths(8)=-1
    upstreamPaths(9)=-1
    upstreamPaths(10)=-1
    upstreamPaths(11)=-1
    upstreamPaths(12)=-1
    upstreamPaths(13)=-1
    upstreamPaths(14)=-1
    upstreamPaths(15)=-1
    Paths(0)=-1
    Paths(1)=-1
    Paths(2)=-1
    Paths(3)=-1
    Paths(4)=-1
    Paths(5)=-1
    Paths(6)=-1
    Paths(7)=-1
    Paths(8)=-1
    Paths(9)=-1
    Paths(10)=-1
    Paths(11)=-1
    Paths(12)=-1
    Paths(13)=-1
    Paths(14)=-1
    Paths(15)=-1
    PrunedPaths(0)=-1
    PrunedPaths(1)=-1
    PrunedPaths(2)=-1
    PrunedPaths(3)=-1
    PrunedPaths(4)=-1
    PrunedPaths(5)=-1
    PrunedPaths(6)=-1
    PrunedPaths(7)=-1
    PrunedPaths(8)=-1
    PrunedPaths(9)=-1
    PrunedPaths(10)=-1
    PrunedPaths(11)=-1
    PrunedPaths(12)=-1
    PrunedPaths(13)=-1
    PrunedPaths(14)=-1
    PrunedPaths(15)=-1
    PathDescription=12
    bStatic=True
    bHidden=True
    bCollideWhenPlacing=True
    SoundVolume=0
    CollisionRadius=46.00
    CollisionHeight=50.00
}
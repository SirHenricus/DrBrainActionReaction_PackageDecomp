//================================================================================
// Effects.
//================================================================================
class Effects expands Actor;

var() Sound EffectSound1;
var() Sound EffectSound2;
var() bool bOnlyTriggerable;

defaultproperties
{
    bNetTemporary=True
    DrawType=0
    bGameRelevant=True
    CollisionRadius=0.00
    CollisionHeight=0.00
}
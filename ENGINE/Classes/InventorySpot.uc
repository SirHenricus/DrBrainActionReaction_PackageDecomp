//================================================================================
// InventorySpot.
//================================================================================
class InventorySpot expands NavigationPoint
	native;

var Inventory markedItem;

defaultproperties
{
    bEndPointOnly=True
    bCollideWhenPlacing=False
    bHiddenEd=True
    CollisionRadius=20.00
    CollisionHeight=40.00
}
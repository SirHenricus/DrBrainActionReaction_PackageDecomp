//================================================================================
// SPTrigger.
//================================================================================
class SPTrigger expands SPActor;

function Touch (Actor Other)
{
	if ( Other.IsA('SPPlayer') )
	{
		SPPlayer(Other).Trigger(Other,Other.Instigator);
	}
}

defaultproperties
{
    bHidden=True
    bCollideActors=True
}
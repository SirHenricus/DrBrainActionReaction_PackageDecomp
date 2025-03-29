//================================================================================
// SPCreditsPlayerMenu.
//================================================================================
class SPCreditsPlayerMenu expands SPCharacterMenu;

function Setup ()
{
	local int i;
	local Class<SPPlayer> PlayerClass;

	bSetup=True;
	CurCharacter=0;
	if (  !Level.Title ~= "Base" )
	{
		HelpMessage[1]=HelpMessage[2];
	}
	PlayerClass=Class<SPPlayer>(DynamicLoadObject("Spore." $ Characters[CurCharacter],Class'Class'));
	if ( PlayerClass != None )
	{
		CharacterClass=PlayerClass;
		Mesh=CharacterClass.Default.Mesh;
		Skin=CharacterClass.Default.Skin;
		DrawScale=Default.DrawScale * CharacterClass.Default.DrawScale;
		MenuValues[1]=CharacterClass.Default.CharacterName;
	}
}

function bool ProcessSelection ()
{
	local string Map;

	if (  !Level.Title ~= "Base" )
	{
		bExitAllMenus=True;
		return True;
	}
	if ( Selection == 1 )
	{
		bExitAllMenus=True;
		if ( Level.bEnhancedContent )
		{
			Map="CreditLevel" $ "?Class=" $ string(CharacterClass);
		}
		else
		{
			Map="CreditLevel" $ "?Class=" $ string(CharacterClass);
		}
		if ( SPConsole(PlayerOwner.Player.Console) != None )
		{
			SPConsole(PlayerOwner.Player.Console).NextLevel="";
		}
		PlayerOwner.ClientTravel(Map,0,False);
	}
}

function MenuTick (float DeltaTime)
{
	local Rotator NewRot;

	if ( PlayerOwner.ViewTarget == None )
	{
		NewRot=Rotation;
		NewRot.Yaw=PlayerOwner.ViewRotation.Yaw + 30000;
		SetRotation(NewRot);
	}
	else
	{
		NewRot=Rotation;
		NewRot.Yaw=PlayerOwner.ViewTarget.Rotation.Yaw + 30000;
		SetRotation(NewRot);
	}
	if ( Mesh == LodMesh'Tom' )
	{
		AnimSequence='Land';
	}
	else
	{
		AnimSequence=Default.AnimSequence;
	}
	Super.MenuTick(DeltaTime);
}

defaultproperties
{
    Characters(0)="SPTom"
    Characters(1)="SPAnthony"
    Characters(2)="SPGeoff"
    Characters(3)="SPJeremy"
    Characters(4)="SPLee"
    Characters(5)="SPStephen"
    Characters(6)="SPMarcus"
    Characters(7)="SPBob"
    Characters(8)="SPChris"
    Characters(9)="SPAlbert"
    Characters(10)="SPAri"
    Characters(11)="SPBo"
    Characters(12)="SPNaren"
    NationalityString="Job: "
    HelpMessage(1)="Use the arrow keys to pick a character. Hit Enter when ready, or Esc to cancel."
    HelpMessage(2)="You can only play the credits level from the intro screen."
    RotationRate=(Pitch=0,Yaw=0,Roll=0)
}
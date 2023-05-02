class AALMut extends KFMutator;

var private AAL AAL;

public simulated function bool SafeDestroy()
{
	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	Super.PreBeginPlay();

	if (WorldInfo.NetMode == NM_Client) return;

	foreach WorldInfo.DynamicActors(class'AAL', AAL)
	{
		break;
	}

	if (AAL == None)
	{
		AAL = WorldInfo.Spawn(class'AAL');
	}

	if (AAL == None)
	{
		`Log_Base("FATAL: Can't Spawn 'AAL'");
		SafeDestroy();
	}
}

public function AddMutator(Mutator Mut)
{
	if (Mut == Self) return;

	if (Mut.Class == Class)
		Mut.Destroy();
	else
		Super.AddMutator(Mut);
}

public function NotifyLogin(Controller C)
{
	AAL.NotifyLogin(C);

	Super.NotifyLogin(C);
}

public function NotifyLogout(Controller C)
{
	AAL.NotifyLogout(C);

	Super.NotifyLogout(C);
}

defaultproperties
{

}
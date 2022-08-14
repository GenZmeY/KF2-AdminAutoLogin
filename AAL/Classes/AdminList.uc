class AdminList extends Object
	config(AAL)
	abstract;

var private config Array<String> AdminId;

public static function InitConfig(int Version, int LatestVersion, E_LogLevel LogLevel)
{
	`Log_TraceStatic();
	
	switch (Version)
	{
		case `NO_CONFIG:
			ApplyDefault(LogLevel);
			
		default: break;
	}
	
	if (LatestVersion != Version)
	{
		StaticSaveConfig();
	}
}

public static function Array<UniqueNetId> Load(OnlineSubsystem OS, E_LogLevel LogLevel)
{
	local Array<UniqueNetId> UIDs;
	local UniqueNetId UID;
	local String ID;
	
	`Log_TraceStatic();
	
	foreach default.AdminId(ID)
	{
		if (AnyToUID(OS, ID, UID, LogLevel))
		{
			UIDs.AddItem(UID);
			`Log_Debug("Loaded:" @ ID);
		}
		else
		{
			`Log_Warn("Can't load AdminId:" @ ID);
		}
	}
	
	if (default.AdminId.Length == UIDs.Length)
	{
		`Log_Info("Loaded" @ UIDs.Length @ "entries");
	}
	else
	{
		`Log_Info("Loaded" @ UIDs.Length @ "of" @ default.AdminId.Length @ "entries");
	}
	
	return UIDs;
}

private static function ApplyDefault(E_LogLevel LogLevel)
{
	`Log_TraceStatic();
	
	default.AdminId.Length = 0;
	default.AdminId.AddItem("76561190000000000");
	default.AdminId.AddItem("0x0000000000000000");
}

private static function bool IsUID(String ID, E_LogLevel LogLevel)
{
	`Log_TraceStatic();
	
	return (Locs(Left(ID, 2)) ~= "0x");
}

private static function bool AnyToUID(OnlineSubsystem OS, String ID, out UniqueNetId UID, E_LogLevel LogLevel)
{
	`Log_TraceStatic();
	
	return IsUID(ID, LogLevel) ? OS.StringToUniqueNetId(ID, UID) : OS.Int64ToUniqueNetId(ID, UID);
}

defaultproperties
{

}

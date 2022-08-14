class AAL extends Info
	config(AAL);

const LatestVersion = 1;

const CfgAdminList = class'AdminList';

var private config int         Version;
var private config E_LogLevel  LogLevel;

var private OnlineSubsystem    OS;
var private Array<UniqueNetId> AdminUIDList;

public simulated function bool SafeDestroy()
{
	`Log_Trace();
	
	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	`Log_Trace();
	
	if (WorldInfo.NetMode == NM_Client)
	{
		`Log_Fatal("Wrong NetMode:" @ WorldInfo.NetMode);
		SafeDestroy();
		return;
	}
	
	Super.PreBeginPlay();
	
	PreInit();
}

public event PostBeginPlay()
{
	`Log_Trace();
	
	if (bPendingDelete || bDeleteMe) return;
	
	Super.PostBeginPlay();
	
	PostInit();
}

private function PreInit()
{
	`Log_Trace();
	
	if (Version == `NO_CONFIG)
	{
		LogLevel = LL_Info;
		SaveConfig();
	}
	
	CfgAdminList.static.InitConfig(Version, LatestVersion, LogLevel);
	
	switch (Version)
	{
		case `NO_CONFIG:
			`Log_Info("Config created");
			
		case MaxInt:
			`Log_Info("Config updated to version" @ LatestVersion);
			break;
			
		case LatestVersion:
			`Log_Info("Config is up-to-date");
			break;
			
		default:
			`Log_Warn("The config version is higher than the current version (are you using an old mutator?)");
			`Log_Warn("Config version is" @ Version @ "but current version is" @ LatestVersion);
			`Log_Warn("The config version will be changed to" @ LatestVersion);
			break;
	}
	
	if (LatestVersion != Version)
	{
		Version = LatestVersion;
		SaveConfig();
	}

	if (LogLevel == LL_WrongLevel)
	{
		LogLevel = LL_Info;
		
		`Log_Warn("Wrong 'LogLevel', return to default value");
		
		SaveConfig();
	}
	`Log_Base("LogLevel:" @ LogLevel);
	
	OS = class'GameEngine'.static.GetOnlineSubsystem();
	if (OS != None)
	{
		AdminUIDList = CfgAdminList.static.Load(OS, LogLevel);
	}
	else
	{
		`Log_Fatal("Can't get online subsystem!");
		SafeDestroy();
	}
}

private function PostInit()
{
	`Log_Trace();
}

public function NotifyLogin(Controller C)
{
	local PlayerController PC;
	local PlayerReplicationInfo PRI;
	local String UniqueID;
	local String SteamID;
	local String Profile;
	
	`Log_Trace();
	
	if (C == None || C.PlayerReplicationInfo == None) return;
	
	PRI = C.PlayerReplicationInfo;
	
	if (AdminUIDList.Find('Uid', PRI.UniqueId.Uid) != INDEX_NONE)
	{
		PRI.bAdmin = true;
		
		UniqueID = OS.UniqueNetIdToString(PRI.UniqueId);
		
		PC = PlayerController(C);
		if (PC != None && !PC.bIsEosPlayer)
		{
			SteamID = OS.UniqueNetIdToInt64(PRI.UniqueId);
			Profile = "https://steamcommunity.com/profiles/" $ SteamID;
			
			`Log_Info("Admin login:" @ PRI.PlayerName @ "(" $ UniqueID $ "," @ SteamID $ "," @ Profile $ ")");
		}
		else
		{
			`Log_Info("Admin login:" @ PRI.PlayerName @ "(" $ UniqueID $ ")");
		}
	}
}

public function NotifyLogout(Controller C)
{
	`Log_Trace();
}

defaultproperties
{

}
// This file is part of Admin Auto Login.
// Admin Auto Login - a mutator for Killing Floor 2.
//
// Copyright (C) 2022-2024 GenZmeY (mailto: genzmey@gmail.com)
//
// Admin Auto Login is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Admin Auto Login is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with Admin Auto Login. If not, see <https://www.gnu.org/licenses/>.

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

	return (Left(ID, 2) ~= "0x");
}

private static function bool AnyToUID(OnlineSubsystem OS, String ID, out UniqueNetId UID, E_LogLevel LogLevel)
{
	`Log_TraceStatic();

	return IsUID(ID, LogLevel) ? OS.StringToUniqueNetId(ID, UID) : OS.Int64ToUniqueNetId(ID, UID);
}

defaultproperties
{

}
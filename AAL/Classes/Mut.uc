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

class Mut extends KFMutator;

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

public function AddMutator(Mutator M)
{
	if (M == Self) return;

	if (M.Class == Class)
		Mut(M).SafeDestroy();
	else
		Super.AddMutator(M);
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

static function String GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return String(class'AAL');
}

defaultproperties
{

}
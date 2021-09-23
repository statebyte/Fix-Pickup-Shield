#include <sdktools>

Address g_FixPickUpAddress;
int g_iOS;

public Plugin myinfo =
{
	name = "Fix Pickup Shield",
	author = "FIVE",
	version = "1.0.0",
	url = "http://hlmod.ru"
};

public void OnPluginStart()
{
	GameData hGameData = LoadGameConfigFile("Fix_Pickup_Shield");
	
	if(!hGameData)
	{
		SetFailState("Failed to load NoDisarmMod gamedata.");
		return;
	}

	Address IsWeaponAllowed = hGameData.GetAddress("IsWeaponAllowed");

	if(IsWeaponAllowed == Address_Null)
	{
		SetFailState("Failed to get IsWeaponAllowed address.");
		return;
	}

	g_FixPickUpAddress = IsWeaponAllowed + view_as<Address>(hGameData.GetOffset("FixShit"));

	g_iOS = hGameData.GetOffset("WhatIsOS");

	hGameData.Close();

	if(g_iOS == 1)
	{
		if(LoadFromAddress(g_FixPickUpAddress, NumberType_Int16) != 0xBE66)
		{
			SetFailState("Found not what they expected.");
			return;
		}

		g_FixPickUpAddress += view_as<Address>(2);
		StoreToAddress(g_FixPickUpAddress, 0, NumberType_Int16);
	}
	else
	{
		if(LoadFromAddress(g_FixPickUpAddress, NumberType_Int8) != 0xB8)
		{
			SetFailState("Found not what they expected.");
			return;
		}

		g_FixPickUpAddress++;
		StoreToAddress(g_FixPickUpAddress, 0, NumberType_Int32);
	}

}

public void OnPluginEnd()
{
	// TODO: return the value that was
	if(g_iOS == 1) StoreToAddress(g_FixPickUpAddress, 7, NumberType_Int16);
	else StoreToAddress(g_FixPickUpAddress, 7, NumberType_Int32);
}
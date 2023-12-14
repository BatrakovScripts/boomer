#pragma semicolon 1

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//*
//*                 Boomer
//*                 Status: beta
//*					Автор релиза BatrakovScripts Ник на форуме(Alexander_Mirny)
//*
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

#pragma tabsize 0

public OnPluginStart()
{
	HookEvent("player_now_it", PlayerNowIt);
}		

public Action:PlayerNowIt(Handle:event, const String:name[], bool:dontBroadcast) 
{
	new attacker  = GetClientOfUserId(GetEventInt(event, "attacker"));
	new i  = GetClientOfUserId(GetEventInt(event, "userid"));
	switch(GetRandomInt(0, 5))
	{
		case 0:
		{
			PrintToChat(i,"\x04Рвота толстяка ядовита -15HP");
			applyDamage(15, i, attacker);
		}
		case 1:
		{
			PrintToChat(i,"\x04Рвота толстяка ядовита -20HP");
			applyDamage(20, i, attacker);
		}
		case 2:
		{
			PrintToChat(i,"\x04Рвота толстяка ядовита -35HP");
			applyDamage(35, i, attacker);
		}
		case 3:
		{
			PrintToChat(i,"\x04Рвота толстяка ядовита -46HP");
			applyDamage(46, i, attacker);
		}
		case 4:
		{
			PrintToChat(i,"\x04Рвота толстяка ядовита -51HP");
			applyDamage(51, i, attacker);
		}
	}
}
static applyDamage(damage, victim, attacker)
{ 
	new Handle:dataPack = CreateDataPack();
	WritePackCell(dataPack, damage);  
	WritePackCell(dataPack, victim);
	WritePackCell(dataPack, attacker);
	
	CreateTimer(0.10, timer_stock_applyDamage, dataPack);
}

public Action:timer_stock_applyDamage(Handle:timer, Handle:dataPack)
{
	ResetPack(dataPack);
	new damage = ReadPackCell(dataPack);  
	new victim = ReadPackCell(dataPack);
	new attacker = ReadPackCell(dataPack);
	CloseHandle(dataPack);
	
	decl Float:victimPos[3], String:strDamage[16], String:strDamageTarget[16];
	
	if (!IsClientInGame(victim)) return;
	GetClientEyePosition(victim, victimPos);
	IntToString(damage, strDamage, sizeof(strDamage));
	Format(strDamageTarget, sizeof(strDamageTarget), "hurtme%d", victim);
	
	new entPointHurt = CreateEntityByName("point_hurt");
	if(!entPointHurt) return;

	DispatchKeyValue(victim, "targetname", strDamageTarget);
	DispatchKeyValue(entPointHurt, "DamageTarget", strDamageTarget);
	DispatchKeyValue(entPointHurt, "Damage", strDamage);
	DispatchSpawn(entPointHurt);
	
	TeleportEntity(entPointHurt, victimPos, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(entPointHurt, "Hurt", (attacker > 0 && attacker < MaxClients && IsClientInGame(attacker)) ? attacker : -1);
	
	DispatchKeyValue(entPointHurt, "classname", "point_hurt");
	DispatchKeyValue(victim, "targetname", "null");
	RemoveEdict(entPointHurt);
}

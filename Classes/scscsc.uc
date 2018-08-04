class scscsc extends KFMutator
	config(scscsc);//by berochlu


var config bool		bConfigsInit;
var config float	SpawnCycle;
var config int		FPWave;
var config bool		bFuryScrake;
var config int		SpawnSC;
var config int		SpawnFP;

var int				CurrentWave;
var bool			bResetDilation;


function PostBeginPlay()
{
	if(!bConfigsInit)
	{
		bConfigsInit = true;
		SpawnCycle = 192.f;
		FPWave = 1;//Spawn FP from FPWave
		bFuryScrake = false;
		SpawnSC = 1;//spawn ammount sc
		SpawnFP = 1;//spawn ammount fp
		SaveConfig();
	}
	
	SetTimer(SpawnCycle, true, nameof(SpawnGorilla) );
}

function SpawnGorilla()
{
	local class<KFPawn_Monster>				KFPawn_M;
	local KFSpawnVolume						SpawnVolume;
	local array< class<KFPawn_Monster> >	FakeSpawnList;
	local byte								i;

	if(MyKFGI.MyKFGRI != None)
	{
		CurrentWave = MyKFGI.MyKFGRI.WaveNum;//Get CurrentWave
	}
	
	if(MyKFGI.MyKFGRI.bTraderIsOpen)
	{
		ModifyTimerTimeDilation(nameof(SpawnGorilla), 3.f, self);
		bResetDilation = true;
		return;
	}
	
	
	if(FPWave <= CurrentWave)
	{
		for(i=0; i<SpawnFP; i++)
		{
			KFPawn_M = class<KFPawn_Monster>(DynamicLoadObject("KFGameContent.KFPawn_ZedFleshPound_Versus", class'Class') );
			FakeSpawnList.AddItem( KFPawn_M );
		}
		
		FPWave = FPWave + 1;
		ModifyTimerTimeDilation(nameof(SpawnGorilla), 8.f, self);
		bResetDilation = true;
	}
	else
	{
		for(i=0; i<SpawnSC; i++)
		{
			if(bFuryScrake)
			{
				KFPawn_M = class<KFPawn_Monster>(DynamicLoadObject("scscsc.beropawn_ZedScrake", class'Class') );//mutatorName.className
			}
			else
			{
				KFPawn_M = class<KFPawn_Monster>(DynamicLoadObject("KFGameContent.KFPawn_ZedScrake_Versus", class'Class') );
			}
			FakeSpawnList.AddItem( KFPawn_M );
		}
		
		if(bResetDilation)
		{
			ResetTimerTimeDilation(nameof(SpawnGorilla), self);
			bResetDilation = false;
		}
	}

	if( KFGameInfo(WorldInfo.Game) != None)
	{
		KFGameInfo(WorldInfo.Game).SpawnManager.DesiredSquadType = EST_Large;//set spawn location
		SpawnVolume = KFGameInfo(WorldInfo.Game).SpawnManager.GetBestSpawnVolume( FakeSpawnList );
	}
	
	if(SpawnVolume != None)
    {
		SpawnVolume.SpawnWave(FakeSpawnList, true);
    }
}

defaultproperties
{
	bResetDilation=false
}

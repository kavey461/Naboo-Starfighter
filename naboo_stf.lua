--tab 0

function _init()
	cls(0)
	shipx=64
	shipy=64
	
	shipspr=2
	
	shipsx=0
	shipsy=0
	
	blax=64
	blay=-10
	
	blaspr=17
	
	torx=64
	tory=-20
	
	torspr=38
	
	tdspr=13
	tdfspr=14
	
	lifespr=2
	dthspr=11
	
	muzzle=0
	
	score=10000
	
	lives=3
	
	torps=3
	
	starx={}
	stary={}
	starspd={}
	
	for i=1,100 do
		add(starx,flr(rnd(128)))
		add(stary,flr(rnd(128)))
		add(starspd,rnd(1.5)+0.5)
	end
		

end

function _update()
	
	shipsx=0
	shipsy=0
	shipspr=2

	--controls
	if btn(0) then
		shipsx=-2
		shipspr=1
	elseif btn(1) then
		shipsx=2
		shipspr=3
	elseif btn(2) then
		shipsy=-2
	elseif btn(3) then
		shipsy=2
	end
	
	if btnp(5) then
		blax=shipx
		blay=shipy-3
		sfx(0)
		muzzle=5
	end
	
	if btnp(4) and torps>=1 then
		torx=shipx
		tory=shipy-3
		sfx(1)
		muzzle=5
		torps=torps-1
	end
	
	--moving the ship
	shipx=shipx+shipsx
	shipy=shipy+shipsy
	
	--moving blaster bolts
	blay=blay-8
	
	--moving torpedoes
	tory=tory-4
	
	--animate torpedoes
	torspr=torspr+1
	
	if torspr>44 then
		torspr=38
	end
	
	--animate muzzle flash
	
	if muzzle>0 then
		muzzle=muzzle-1
	end
	
	if shipx>120 then
		shipx=0
	elseif shipx<0 then
		shipx=120
	end
	
	--animate stars
	animatestars()
		
end


function _draw()
	cls(0)
	starfield()
	spr(shipspr,shipx,shipy)
	spr(blaspr,blax,blay)
	spr(torspr,torx,tory)

	
	if muzzle>0 then
		circfill(shipx+2,shipy-1,muzzle,7)
		circfill(shipx+5,shipy-1,muzzle,7)
	end
	
	print("score:"..score,40,1,12)
	
	--lives display
	
	for i=1,3 do
		if lives>=i then
			spr(lifespr,i*9-8,1)
		else
			spr(dthspr,i*9-8,1)
		end		
	end
	
	--torpedoes display
	
	for i=1,3 do
		if torps>=i then
			spr(tdspr,(i*9)+93,1)
		else
			spr(tdfspr,(i*9)+93,1)
		end
	end
	
end

--tab 1

function starfield()
	for i=1,#starx do
		local scol=6
		
		if starspd[i]<1 then
			scol=1
		elseif starspd[i]<1.5 then
			scol=13
		end
		
		pset(starx[i],stary[i],scol)
	end
end	

function animatestars()
	for i=1,#stary do
		local sy=stary[i]
		sy=sy+starspd[i]
		
		if sy>128 then
			sy=sy-128
		end
		stary[i]=sy
	end
end
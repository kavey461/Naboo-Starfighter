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
	
	muzzle=0
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
	
	--moving the ship
	shipx=shipx+shipsx
	shipy=shipy+shipsy
	
	--moving blaster bolts
	blay=blay-8
	
	--animate muzzle flash
	
	if muzzle>0 then
		muzzle=muzzle-1
	end
	
	if shipx>120 then
		shipx=0
	elseif shipx<0 then
		shipx=120
	end
		
end

function _draw()
	cls(0)
	spr(shipspr,shipx,shipy)
	spr(blaspr,blax,blay)
	
	if muzzle>0 then
		circfill(shipx+2,shipy-1,muzzle,7)
		circfill(shipx+5,shipy-1,muzzle,7)
	end
end
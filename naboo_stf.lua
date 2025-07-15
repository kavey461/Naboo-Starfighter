--tab 0

function _init()

	cls(0)
	
	mode="start"
	blinkt=1

end

function _update()
	
	blinkt+=1

	if mode=="game" then
		update_game()
	elseif mode=="start" then
		update_start()
	elseif mode=="over" then
		update_over()
	end
	
end


function _draw()

	if mode=="game" then
		draw_game()
	elseif mode=="start" then
		draw_start()
	elseif mode=="over" then
		draw_over()
	end
	
end

function start_game()

	mode="game"
	
	shipx=64
	shipy=64
	
	shipsx=0
	shipsy=0
	
	shipspr=2
	
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
	
	stars={}
	
	for i=1,100 do
		local newstar={}
		newstar.x=flr(rnd(128))
		newstar.y=flr(rnd(128))
		newstar.spd=rnd(1.5)+0.5
		add(stars,newstar)
	end
	
	blabs={}
	
end

--tab 1

--helpers

function starfield()
	
	for i=1,#stars do
		local mystar=stars[i]
		local scol=6
		
		if mystar.spd<1 then
			scol=1
		elseif mystar.spd<1.5 then
			scol=13
		end
		
		pset(mystar.x,mystar.y,scol)
	end
	
end	

function animatestars()
	
	for i=1,#stars do
		local mystar=stars[i]
		mystar.y=mystar.y+mystar.spd
	
		if mystar.y>128 then
		mystar.y=mystar.y-128
		end
	end
	
end

function blink()
	local banim={5,5,6,6,7,7,6,6,5}
	if blinkt>#banim then
		blinkt=1
	end
	
	return banim[blinkt]
	
end

--tab 2

--update

function update_game()
	
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
		local newblab={}
		newblab.x=shipx
		newblab.y=shipy-3
		add(blabs,newblab)
		
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
	for i=#blabs,1,-1 do
		local myblab=blabs[i]
		myblab.y=myblab.y-8
		
		if myblab.y<-8 then
			del(blabs,myblab)
		end
	end
	
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

function update_start()
	if btnp(4) or btnp(5) then
		start_game()
	end
end

function update_over()
	if btnp(4) or btnp(5) then
		mode="start"
	end
end

--tab 3

--draw

function draw_game()

	cls(0)
	starfield()
	spr(shipspr,shipx,shipy)

	for i=1,#blabs do
		local myblab=blabs[i]
		spr(blaspr,myblab.x,myblab.y)
	end

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

function draw_start()

	cls(1)
	print("naboo starfighter",30,40,12)
	print("press any key to start",21,80,blink())

end

function draw_over()

	cls(8)
	print("game over",48,40,12)
	print("press any key to continue",19,80,7)
	

end
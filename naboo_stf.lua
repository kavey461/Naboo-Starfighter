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
	
	ship={}
	
	ship.x=64
	ship.y=64
	ship.sx=0
	ship.sy=0
	ship.spr=2
	
	blax=64
	blay=-10
	
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
	
	enemies={}
	
	local myen={}
	myen.x=60
	myen.y=5
	myen.spr=5
	
	add(enemies,myen)
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

function drwmyspr(myspr)
	spr(myspr.spr,myspr.x,myspr.y)
end

function col(a,b)

	local a_left=a.x
	local a_top=a.y
	local a_right=a.x+7
	local a_btm=a.y+7
	
	local b_left=b.x
	local b_top=b.y
	local b_right=b.x+7
	local b_btm=b.y+7
	
	if a_top>b_btm then
		return false
	end
	if b_top>a_btm then
		return false
	end
	if a_left>b_right then
		return false
	end
	if b_left>b_right then
		return false
	end
	
	return true
	
end

--tab 2

--update

function update_game()
	
	ship.sx=0
	ship.sy=0
	ship.spr=2

	--controls
	if btn(0) then
		ship.sx=-2
		ship.spr=1
	elseif btn(1) then
		ship.sx=2
		ship.spr=3
	elseif btn(2) then
		ship.sy=-2
	elseif btn(3) then
		ship.sy=2
	end
	
	if btnp(5) then
		local newblab={}
		newblab.x=ship.x
		newblab.y=ship.y-3
		newblab.spr=17
		add(blabs,newblab)
		
		sfx(0)
		muzzle=5
	end
	
	if btnp(4) and torps>=1 then
		torx=ship.x
		tory=ship.y-3
		sfx(1)
		muzzle=5
		torps=torps-1
	end
	
	--moving the ship
	ship.x+=ship.sx
	ship.y+=ship.sy
	
		--checking if ship hits edge
	if ship.x>120 then
		ship.x=0
	elseif ship.x<0 then
		ship.x=120
	end
	if ship.y<0 then
		ship.y=0
	end
	if ship.y>120 then
		ship.y=120
	end
	
	--moving blaster bolts
	for i=#blabs,1,-1 do
		local myblab=blabs[i]
		myblab.y=myblab.y-8
		
		if myblab.y<-8 then
			del(blabs,myblab)
		end
	end
	
	--moving enemies
	for myen in all(enemies) do
		myen.y+=1
		
		myen.spr+=0.2
		if myen.spr>=9 then
			myen.spr=5
		end
		
		if myen.y>128 then
			del(enemies.myen)
		end
	end
	
	--moving torpedoes
	tory=tory-4
	
	--animate torpedoes
	torspr=torspr+1
	
	if torspr>44 then
		torspr=38
	end
	
	--collision ship x enemies
	for myen in all(enemies) do
		if col(myen,ship) then
			lives-=1
			sfx(2)
			del(enemies,myen)
		end
	end
	
	if lives<=0 then
		mode="over"
		return
	end
	
	
	--animate muzzle flash
	
	if muzzle>0 then
		muzzle=muzzle-1
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
	drwmyspr(ship)

	--drawing enemies
	for myen in all(enemies) do
		drwmyspr(myen)
	end

	--drawing blaster bolts
	for myblab in all(blabs) do
		drwmyspr(myblab)
	end

	spr(torspr,torx,tory)

	
	if muzzle>0 then
		circfill(ship.x+2,ship.y-1,muzzle,7)
		circfill(ship.x+5,ship.y-1,muzzle,7)
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